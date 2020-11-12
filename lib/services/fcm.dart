import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:logger/logger.dart';

class FireMessaging {
  FireMessaging._();
  static FireMessaging firebaseMessaging = FireMessaging._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  initLocalNotifications() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    var iosInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<dynamic> onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      Logger().d(payLoad);
    }
  }

  void _showNotifications(String title, String body) async {
    notification(title, body);
  }

  Future<void> notification(String title, String body) async {
    var androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.high, importance: Importance.max, ticker: 'test');

    print('Notification Title : $title');
    print('Notification Body : $body');
    var iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  initFirebaseMessaging(context) {
    initLocalNotifications();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      // onMessage: (Map<String, dynamic> message) async {
      //   print('------------------------------------------------');
      //   print('onMessage $message');
      //   print('------------------------------------------------');

      //   String title = Platform.isIOS
      //       ? translator.currentLanguage == "ar"
      //           ? message['titleAr']
      //           : message['titleEn']
      //       : translator.currentLanguage == "ar"
      //           ? message['data']['titleAr']
      //           : message['data']['titleEn'];

      //   String body = Platform.isIOS
      //       ? translator.currentLanguage == "ar"
      //           ? message['bodyAr']
      //           : message['BodyEn']
      //       : translator.currentLanguage == "ar"
      //           ? message['data']['bodyAr']
      //           : message['data']['BodyEn'];
      //   _showNotifications(title, body);
      // },
      onLaunch: (Map<String, dynamic> message) async {
        print('------------------------------------------------');
        print('onLaunch $message');
        print('------------------------------------------------');
        String title = Platform.isIOS
            ? translator.currentLanguage == "ar"
                ? message['titleAr']
                : message['titleEn']
            : translator.currentLanguage == "ar"
                ? message['data']['titleAr']
                : message['data']['titleEn'];

        String body = Platform.isIOS
            ? translator.currentLanguage == "ar"
                ? message['bodyAr']
                : message['BodyEn']
            : translator.currentLanguage == "ar"
                ? message['data']['bodyAr']
                : message['data']['BodyEn'];

        _showNotifications(title, body);
      },
      onResume: (Map<String, dynamic> message) async {
        print('------------------------------------------------');
        print('onResume $message');
        print('------------------------------------------------');
        String title = Platform.isIOS
            ? translator.currentLanguage == "ar"
                ? message['titleAr']
                : message['titleEn']
            : translator.currentLanguage == "ar"
                ? message['data']['titleAr']
                : message['data']['titleEn'];

        String body = Platform.isIOS
            ? translator.currentLanguage == "ar"
                ? message['bodyAr']
                : message['BodyEn']
            : translator.currentLanguage == "ar"
                ? message['data']['bodyAr']
                : message['data']['BodyEn'];

        _showNotifications(title, body);
      },
    );
  }

  saveDeviceToken(String uid) async {
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      QuerySnapshot querySnapshot =
          await _db.collection('Users').doc(uid).collection('tokens').get();

      for (DocumentSnapshot ds in querySnapshot.docs) {
        ds.reference.delete();
      }

      var tokens =
          _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  deleteDeviceToken(String uid) async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      _db
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc('token')
          .delete();
    }
  }

  subscribeTopic() {
    _fcm.subscribeToTopic('sooq');
  }
}
