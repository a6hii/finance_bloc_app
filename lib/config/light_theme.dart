import 'package:finance_management/config/colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: const Color.fromRGBO(0, 82, 168, 100),
    primaryColorDark: const Color.fromRGBO(0, 82, 168, 100),
    primaryColorLight: const Color.fromRGBO(223, 239, 255, 100),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(buttonBlue),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Color(0xFF0D386B),
        fontSize: 20,
      ),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF0D386B),
        fontWeight: FontWeight.w500,
        fontSize: 32,
      ),
      displayMedium: TextStyle(
        //AppBar Titles
        color: Color.fromRGBO(13, 56, 107, 1),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF0D386B),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF0D386B),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF0D386B),
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      titleLarge: TextStyle(
        color: Color(0xff1b070b),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        color: Color.fromRGBO(13, 56, 107, 1),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color.fromRGBO(13, 56, 107, 1),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: Color.fromRGBO(13, 56, 107, 1),
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: Color(0xFFFEFEFE),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
  );
}
