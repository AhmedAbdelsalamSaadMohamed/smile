import 'package:flutter/material.dart';

const Color _color1 = Colors.white;
const Color _color2 = Colors.black;
const Color _primary = Color.fromRGBO(225, 51, 1, 1);
const Color background2 = Colors.black26;
const Color onBackground2 = Colors.black54;
ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: _primary,
  hintColor: _color2,
  focusColor: _primary,
  hoverColor: _primary,
  colorScheme: const ColorScheme.light().copyWith(
    background: _color1,
    onBackground: _color2,
    primary: _color1,
    secondary: _color2,
  ),
  tabBarTheme: const TabBarTheme(
      labelColor: _color2,
      unselectedLabelColor: onBackground2,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: _primary),
        insets: EdgeInsets.all(2),
      )),
  appBarTheme: const AppBarTheme(
    backgroundColor: _color1,
    foregroundColor: _color2,
    elevation: 0,
    centerTitle: true,
  ),
  sliderTheme: const SliderThemeData(
      trackHeight: 1,
      thumbColor: Colors.white,
      activeTickMarkColor: Colors.white,
      activeTrackColor: Colors.white,
      disabledActiveTickMarkColor: Colors.grey,
      disabledActiveTrackColor: Colors.grey,
      disabledInactiveTickMarkColor: Colors.grey,
      disabledInactiveTrackColor: Colors.grey,
      disabledThumbColor: Colors.grey,
      thumbShape:
          RoundSliderThumbShape(disabledThumbRadius: 2, enabledThumbRadius: 4),
      rangeThumbShape: RoundRangeSliderThumbShape(
          enabledThumbRadius: 2,
          disabledThumbRadius: 1,
          elevation: 0,
          pressedElevation: 0)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: buttonStyle(),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(_color2),
  )),
  textButtonTheme: TextButtonThemeData(
    style: buttonStyle(),
  ),
  listTileTheme: const ListTileThemeData(),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _primary),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
      counterStyle: TextStyle(color: _color2)
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: _color2,),
  snackBarTheme: SnackBarThemeData(actionTextColor: _color2),
  textTheme: TextTheme()
);

ButtonStyle buttonStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    foregroundColor: MaterialStateProperty.all(_primary),
    elevation: MaterialStateProperty.all(0),
  );
}
