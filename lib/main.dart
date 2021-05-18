import 'package:expense_tracker/pages/homepage.dart';
import 'package:expense_tracker/provider/expenseProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await Hive.openBox('storage');
  if (await Hive.box('storage').get('data') == null) {
    await Hive.box('storage').put('data', []);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
    )
  ], child: MyApp()));

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.blueGrey[900],
        appBarTheme: AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

Future selectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  // showDialog(context: context, builder: (BuildContext context) => Container());
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(
        'Expense Tracker',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      seconds: 3,
      navigateAfterSeconds: HomePage(),
    );
  }
}
