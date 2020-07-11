import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'backdrop.dart';
import 'colors.dart';
//import 'home.dart';
import 'login.dart';
//import 'category_menu_page.dart';
//import 'model/product.dart';
//import 'supplemental/cut_corners_border.dart';

class AlbumApp extends StatefulWidget {
  @override
  _AlbumAppState createState() => _AlbumAppState();
}

class _AlbumAppState extends State<AlbumApp> {
  //Category _currentcategory = Category.all;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      // 将来的に実装してもいい
      //home: Backdrop(
        //currentCategory: _currentCategory,
        //frontLayer: HomePage(category: _currentCategory),
        //backLayer: CategoryMenuPage(
        //  currentCategory: _currentCategory,
        //  onCategoryTap: _onCategoryTap,
        //),
        //frontTitle: Text('SHRINE'),
        //backTitle: Text('MENU'),
      //),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      theme: _kShrineTheme,
    );
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      //_currentCategory = category;
    });
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  if (settings.name != '/login') {
    return null;
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) => LoginPage(),
    fullscreenDialog: true,
  );
}

final ThemeData _kShrineTheme = _buildShrineTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kBrown900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kBrown900,
    primaryColor: kLightGreen,
    scaffoldBackgroundColor: kLightGreen,
    cardColor: kWhite,
    textSelectionColor: kMossGreen,
    errorColor: kErrorRed,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kWhite,
      colorScheme: base.colorScheme.copyWith(
        secondary: kBrown900,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    primaryIconTheme: base.iconTheme.copyWith(color: kBrown900),
    inputDecorationTheme: InputDecorationTheme(
      //border: CutCornersBorder(),
    ),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline5: base.headline5.copyWith(
      fontWeight: FontWeight.w500,
    ),
    headline6: base.headline6.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyText1: base.bodyText1.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kBrown900,
    bodyColor: kBrown900,
  );
}