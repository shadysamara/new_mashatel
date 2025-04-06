import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/loading_screen.dart';
import 'package:mashatel/localization_service.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/services/dynamic_links_service.dart';
import 'package:mashatel/splach.dart';
import 'package:mashatel/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails? notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<AppGet>(AppGet(), permanent: true);
  await SPHelper.spHelper.initSharedPrefrences();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
    if (response.payload != null) {
      debugPrint('notification payload: ${response.payload}');
    }
    selectNotificationSubject.add(response.payload ?? '');
  });

  bool isFirstTime = await SPHelper.spHelper.checkIfFirstTime();
  if (isFirstTime == true) {
    SPHelper.spHelper.setLanguage(Get.deviceLocale?.languageCode ?? 'ar');
  }

  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // navigation bar color

      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light

      // status bar color
      ));
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(201, 6, 40, .1),
  100: Color.fromRGBO(201, 6, 40, .2),
  200: Color.fromRGBO(201, 6, 40, .3),
  300: Color.fromRGBO(201, 6, 40, .4),
  400: Color.fromRGBO(201, 6, 40, .5),
  500: Color.fromRGBO(201, 6, 40, .6),
  600: Color.fromRGBO(201, 6, 40, .7),
  700: Color.fromRGBO(201, 6, 40, .8),
  800: Color.fromRGBO(201, 6, 40, .9),
  900: Color.fromRGBO(201, 6, 40, 1),
};

final ThemeData _myTheme = ThemeData(
    primarySwatch: MaterialColor(0xFFC10627, color),
    primaryColor: MaterialColor(0xff88A53B, color),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: MaterialColor(0xff88A53B, color)),
    ),
    brightness: Brightness.light,
    colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.white),
    fontFamily: "DIN NEXT ARABIC REGULAR",
    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            fontSize: 20.sp,
            fontFamily: "DIN",
            color: Colors.white,
            fontWeight: FontWeight.bold)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            textStyle: TextStyle(fontSize: 17.sp, fontFamily: "DIN"))),
    textTheme:
        TextTheme(bodyMedium: TextStyle(fontSize: 17.sp, fontFamily: "DIN")));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityService? connectivityService;
  @override
  void initState() {
    super.initState();
    connectivityService = ConnectivityService();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 821),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _myTheme,
            locale: LocalizationService.getSavedLocal(),
            fallbackLocale: LocalizationService.fallbackLocale,
            translations: LocalizationService(),
            home: MaterialApp(
              theme: _myTheme,
              title: 'app_name',
              home: BrokerPage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
  }
}

class BrokerPage extends StatefulWidget {
  @override
  _BrokerPageState createState() => _BrokerPageState();
}

class _BrokerPageState extends State<BrokerPage> with WidgetsBindingObserver {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer? _timerLink;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _timerLink = new Timer(
      const Duration(milliseconds: 1000),
      () {
        _dynamicLinkService.retrieveDynamicLink(context);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('error'),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder<Uri>(
              future: _dynamicLinkService.createDynamicLink(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SplashScreen();
                } else {
                  return Scaffold(
                    body: Center(
                      child: SplashScreen(),
                    ),
                  );
                }
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );

    // EditMarketProfilePage();
  }
}
