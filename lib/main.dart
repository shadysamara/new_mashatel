import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mashatel/error_screen.dart';
import 'package:mashatel/features/messanger/ui/pages/massenger.dart';
import 'package:mashatel/features/sign_in/ui/pages/testpage.dart';
import 'package:mashatel/loading_screen.dart';
import 'package:mashatel/services/connectvity_service.dart';
import 'package:mashatel/splach.dart';
import 'package:mashatel/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/services/shared_prefrences_helper.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );

  bool isFirstTime = await SPHelper.spHelper.checkIfFirstTime();
  if (isFirstTime == true) {
    SPHelper.spHelper.setLanguage(translator.currentLanguage);
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
  runApp(LocalizedApp(child: MyApp()));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
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

var _myTheme = new ThemeData(
    primarySwatch: MaterialColor(0xFFC10627, color),
    primaryColor: MaterialColor(0xff88A53B, color),
    buttonColor: MaterialColor(0xff88A53B, color),
    brightness: Brightness.light,
    accentColor: Colors.white,
    fontFamily: "DIN NEXT ARABIC REGULAR",
    textTheme: TextTheme(body1: TextStyle(fontSize: 17)));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityService connectivityService;
  @override
  void initState() {
    super.initState();
    connectivityService = ConnectivityService();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _myTheme,
      localizationsDelegates: translator.delegates,
      locale: translator.locale,
      supportedLocales: translator.locals(),
      home: MaterialApp(
        theme: _myTheme,
        title: 'Ecards',
        home: BrokerPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class BrokerPage extends StatefulWidget {
  @override
  _BrokerPageState createState() => _BrokerPageState();
}

class _BrokerPageState extends State<BrokerPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SplashScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SplashScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );

    // EditMarketProfilePage();
  }
}
