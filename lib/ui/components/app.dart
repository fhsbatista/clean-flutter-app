import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final primaryColor = Color(0xFF7c4dff);
    final primaryDark = Color(0xFF3f1dcb);
    final primaryLight = Color(0xFFb47cff);
    final theme = ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryDark,
      primaryColorLight: primaryLight,
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryLight),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        alignLabelWithHint: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );

    return MaterialApp(
      title: 'ForDev',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: primaryColor),
      ),
      home: LoginPage(null),
    );
  }
}
