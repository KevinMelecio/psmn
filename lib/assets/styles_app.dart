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

  static IconThemeData darkIcon(BuildContext context){
    final icon = IconThemeData.fallback();
    return icon.copyWith(
      color: Color.fromARGB(255, 86, 164, 210)
    );
  }

  static IconThemeData lightIcon(BuildContext context){
    final icon = IconThemeData.fallback();
    return icon.copyWith(
      color: Color.fromARGB(230, 11, 80, 32)
    );
  }

  static Color darkIconDrawer(BuildContext context){
    return Color.fromARGB(255, 86, 164, 210);
  }

  static Color lightIconDrawer(BuildContext context){
    return Color.fromARGB(230, 11, 80, 32);
  }
}