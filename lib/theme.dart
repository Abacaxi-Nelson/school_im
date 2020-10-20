import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFFffffff);
const PrimaryColorLight = const Color(0xFFffffff);
const PrimaryColorDark = const Color(0xFFcccccc);

const SecondaryColor = const Color(0xFFffca5d);
const SecondaryColorLight = const Color(0xFFfffd8d);
const SecondaryColorDark = const Color(0xFFc9992c);

const Background = Colors.white;
const TextColor = Colors.pink;

/*
const PrimaryColor = const Color(0xFF008080);
const PrimaryColorLight = const Color(0xFF4cb0af);
const PrimaryColorDark = const Color(0xFF005354);

const SecondaryColor = const Color(0xFFb2dfdb);
const SecondaryColorLight = const Color(0xFFe5ffff);
const SecondaryColorDark = const Color(0xFF82ada9);

const Background = const Color(0xFFfffdf7);
const TextColor = const Color(0xFF004d40);
*/
class MyTheme {
  static final ThemeData defaultTheme = _buildTheme();

  static ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.light,
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.light,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      scaffoldBackgroundColor: Background,
      cardColor: Background,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: Background,
      /*
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: TextColor),
        headline5: TextStyle(color: TextColor),
        headline4: TextStyle(color: TextColor),
        headline3: TextStyle(color: TextColor),
        headline2: TextStyle(color: TextColor),
        headline1: TextStyle(color: TextColor),
        bodyText2: TextStyle(color: TextColor),
        bodyText1: TextStyle(color: TextColor),
        // etc...
      ),
      textTheme: base.textTheme.copyWith(
          headline6: base.textTheme.headline6.copyWith(color: TextColor),
          headline5: base.textTheme.headline6.copyWith(color: TextColor),
          headline4: base.textTheme.headline6.copyWith(color: TextColor),
          headline3: base.textTheme.headline6.copyWith(color: TextColor),
          headline2: base.textTheme.headline6.copyWith(color: TextColor),
          headline1: base.textTheme.headline6.copyWith(color: TextColor),
          bodyText2: base.textTheme.bodyText2.copyWith(color: TextColor),
          bodyText1: base.textTheme.bodyText1.copyWith(color: TextColor)),
    */
    );
  }
}
