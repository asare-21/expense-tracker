import 'package:expense_tracker/pages/homepage.dart';
import 'package:expense_tracker/provider/expenseProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('storage');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (await Hive.box('storage').get('data') == null) {
    await Hive.box('storage').put('data', []);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.blue[900],
        appBarTheme: AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
          textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        // primarySwatch: Colors.pink,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(
        'Expense Tracker',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      backgroundColor: Colors.white,
      seconds: 3,
      navigateAfterSeconds: HomePage(),
    );
  }
}
