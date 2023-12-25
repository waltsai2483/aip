import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class Constants {
  static final key = Key.fromUtf8('eIJ9cUI6cT1HaipGxbm7wI47Xbayhrs7');
  static final iv = IV.fromUtf8('p7KhNbwjlvt1Ozm6');
}

class PreferenceKeys {
  static const themeModeIdx = 'prefsThemeModeIndex';
  static const offlineLogin = "prefsOfflineLogin";
  static const tdxAccessToken = 'prefsTdxAccessToken';
  static const tdxTokenExpiry = "prefsTdxTokenExpiry";
  static const notificationConfig = "prefsNotificationConfig";
}

class RemoteConfigKeys {
  static const schedulePdfUrl = 'schedule_pdf_url';
}

class Assets {
  static const backgroundLight = 'assets/background_light.png';
  static const backgroundDark = 'assets/background_dark.png';

  static Future<Map<String, dynamic>> get tdxClientSecret async =>
      jsonDecode(await rootBundle.loadString("assets/tdx_client_secret.json")) as Map<String, dynamic>;
}
