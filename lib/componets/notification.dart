import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Screens/mazad/Notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class NotificationHandler {
  static final NotificationHandler _notificationHandler =
      NotificationHandler._internal();

  factory NotificationHandler() {
    return _notificationHandler;
  }

  NotificationHandler._internal();
  static int id = 0;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  BuildContext context;
  init(BuildContext con) {
    context = con;
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('userToken')) {
        _firebaseMessaging.getToken().then((token) {
          AuthProvider().customerDevice(token);
        });
      }
    });

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: naviagate);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onLaunch: handleNotification,
      onResume: handleNotification,
    );
  }

  Future<dynamic> handleNotification(Map<String, dynamic> message) {
    naviagate(message["data"]["type"]);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1', 'Local Notification', 'Notification when the app is opened',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        id,
        message["notification"]["title"],
        message["notification"]["body"],
        platformChannelSpecifics,
        payload: message["notification"]["type"]);
    id++;
  }

  Future naviagate(String payload) async {
    if (payload == "auction") {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => MazadNotifications()));
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
}
