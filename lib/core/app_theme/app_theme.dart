import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 55, 155, 255),
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //     backgroundColor: Color.fromARGB(255, 0, 122, 193)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 70, 198, 221),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      fontFamily: 'Montserrat Bold',
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat Bold'),
        backgroundColor: Colors.blue[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      )));
}
