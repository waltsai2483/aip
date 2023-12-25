import 'package:aip/config/constants.dart';
import 'package:aip/config/themes.dart';
import 'package:ap_common/resources/ap_colors.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/resources/resources.dart';
import 'package:flutter/material.dart';

export 'package:cupertino_back_gesture/cupertino_back_gesture.dart';

class NthuColor {
  static const Color purple50 = Color(0xFFF9F4F9);
  static const Color purple100 = Color(0xFFF3E8F3);
  static const Color purple200 = Color(0xFFDFC4E1);
  static const Color purple300 = Color(0xFFCB9ECD);
  static const Color purple400 = Color(0xFFA658A9);
  static const Color purple500 = Color(0xFF7F1084);
  static const Color purple600 = Color(0xFF720F76);
  static const Color purple700 = Color(0xFF4D0A50);
  static const Color purple800 = Color(0xFF3A083C);
  static const Color purple900 = Color(0xFF250527);
}

class NthuApTheme extends InheritedWidget {
  NthuApTheme(this.themeMode, {required super.child});

  final ThemeMode themeMode;

  static NthuApTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType()!;
  }

  @override
  bool updateShouldNotify(NthuApTheme oldWidget) {
    return true;
  }

  Brightness get brightness {
    switch (themeMode) {
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
      default:
        return Brightness.dark;
    }
  }

  String get drawerBackground {
    switch (brightness) {
      case Brightness.light:
        return Assets.backgroundLight;
      case Brightness.dark:
      default:
        return Assets.backgroundDark;
    }
  }

  Color get purple {
    switch (brightness) {
      case Brightness.dark:
        return NthuColor.purple700;
      case Brightness.light:
      default:
        return NthuColor.purple500;
    }
  }

  Color get purpleText {
    switch (brightness) {
      case Brightness.dark:
        return NthuColor.purple300;
      case Brightness.light:
      default:
        return NthuColor.purple500;
    }
  }

  Color get purpleAppbar {
    switch (brightness) {
      case Brightness.light:
        return NthuColor.purple500;
      case Brightness.dark:
      default:
        return NthuColor.purple800;
    }
  }

  Color get purpleTabbarDark {
    switch (brightness) {
      case Brightness.light:
        return NthuColor.purple600;
      case Brightness.dark:
      default:
        return NthuColor.purple900;
    }
  }

  static ThemeData get light => ThemeData(
        //platform: TargetPlatform.iOS,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: NthuColor.purple500,
        ),
        indicatorColor: NthuColor.purple500,
        pageTransitionsTheme: _pageTransitionsTheme,
        unselectedWidgetColor: ApColors.grey500,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: NthuColor.purple200,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: NthuColor.purple500,
        ).copyWith(background: Colors.black12),
      );

  static ThemeData get dark => ThemeData(
        //platform: TargetPlatform.iOS,
        brightness: Brightness.dark,
        pageTransitionsTheme: _pageTransitionsTheme,
        appBarTheme: const AppBarTheme(
          color: NthuColor.purple800,
        ),
        indicatorColor: NthuColor.purple300,
        scaffoldBackgroundColor: ApColors.onyx,
        unselectedWidgetColor: ApColors.grey200,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: NthuColor.purple200,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          accentColor: NthuColor.purple500,
        ).copyWith(background: Colors.black12),
      );
}

const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.windows: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.linux: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.fuchsia: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
  },
);