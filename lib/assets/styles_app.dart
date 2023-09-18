import 'package:flutter/material.dart';

class StyleApp{
  static ThemeData lightTheme(BuildContext context){
    final theme = ThemeData.light();
    return theme.copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: Color.fromARGB(210, 43, 141, 73)
      )
    );
  }

  static ThemeData darkTheme(BuildContext context){
    final theme = ThemeData.dark();
    return theme.copyWith(
      // primaryColor: const Color.fromARGB(211, 234, 234, 0)
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: Color.fromARGB(210, 36, 15, 170)
      )
    );
  }
}