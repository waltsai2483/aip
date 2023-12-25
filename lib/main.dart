import 'dart:async';

import 'package:aip/api/notification_helper.dart';
import 'package:aip/config/constants.dart';
import 'package:aip/config/themes.dart';
import 'package:aip/l10n/l10n.dart';
import 'package:aip/pages/home_page.dart';
import 'package:aip/widgets/shared_data_widget.dart';
import 'package:ap_common/config/analytics_constants.dart';
import 'package:ap_common/config/ap_constants.dart';
import 'package:ap_common/models/user_info.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/scaffold/home_page_scaffold.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/utils/preferences.dart';
import 'package:ap_common/widgets/ap_drawer.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:ap_common_firebase/utils/firebase_crashlytics_utils.dart';
import 'package:ap_common_firebase/utils/firebase_performance_utils.dart';
import 'package:ap_common_firebase/utils/firebase_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Preferences.init(key: Constants.key, iv: Constants.iv);
    if (FirebaseUtils.isSupportCore) await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    if (kDebugMode) {
      if (FirebaseCrashlyticsUtils.isSupported) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
      if (FirebasePerformancesUtils.isSupported) {
        await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
      }
    }
    runApp(MyApp());
  }, (error, stack) {
    throw error;
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseAnalytics? _analytics;
  Brightness brightness = Brightness.light;
  ThemeMode themeMode = ThemeMode.system;
  Locale? locale;
  bool isLogin = false;
  UserInfo? userInfo;

  @override
  void initState() {
    _analytics = FirebaseUtils.init();
    themeMode = ThemeMode.values[Preferences.getInt(PreferenceKeys.themeModeIdx, 0)];
    FirebaseAnalyticsUtils.instance.logThemeEvent(themeMode);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
    FirebaseAnalyticsUtils.instance.logThemeEvent(themeMode);
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return SharedDataWidget(this,
        child: NthuApTheme(
          themeMode,
          child: ApTheme(
            themeMode,
            child: MaterialApp(
              onGenerateTitle: (context) => NthuApLocalization.of(context).appName,
              theme: NthuApTheme.light,
              darkTheme: NthuApTheme.dark,
              themeMode: themeMode,
              navigatorObservers: [if (FirebaseAnalyticsUtils.isSupported && _analytics != null) FirebaseAnalyticsObserver(analytics: _analytics!)],
              home: HomePage(),
              locale: locale,
              localizationsDelegates: const [
                NthuApLocalization.delegate,
                apLocalizationsDelegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalMaterialLocalizations.delegate
              ],
              supportedLocales: const [Locale('en', 'US'), Locale('zh', 'TW')],
              localeResolutionCallback: (locale, supportedLocales) {
                String languageCode = Preferences.getString(
                  ApConstants.prefLanguageCode,
                  ApSupportLanguageConstants.system,
                );
                if (languageCode == ApSupportLanguageConstants.system) {
                  return this.locale = ApLocalizations.delegate.isSupported(locale!) ? locale : const Locale('en', 'US');
                } else {
                  return Locale(
                    languageCode,
                    languageCode == ApSupportLanguageConstants.zh ? 'TW' : null,
                  );
                }
              },
            ),
          )
        ));
  }

  void loadLocale(Locale locale) {
    this.locale = locale;
    setState(() {
      apLocalizationsDelegate.load(locale);
      NthuApLocalization.delegate.load(locale);
    });
  }

  void update() {
    setState(() {});
  }

  void loadTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }
}