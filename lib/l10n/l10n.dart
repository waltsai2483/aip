// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class NthuApLocalization {
  NthuApLocalization();

  static NthuApLocalization? _current;

  static NthuApLocalization get current {
    assert(_current != null,
        'No instance of NthuApLocalization was loaded. Try to initialize the NthuApLocalization delegate before accessing NthuApLocalization.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<NthuApLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = NthuApLocalization();
      NthuApLocalization._current = instance;

      return instance;
    });
  }

  static NthuApLocalization of(BuildContext context) {
    final instance = NthuApLocalization.maybeOf(context);
    assert(instance != null,
        'No instance of NthuApLocalization present in the widget tree. Did you add NthuApLocalization.delegate in localizationsDelegates?');
    return instance!;
  }

  static NthuApLocalization? maybeOf(BuildContext context) {
    return Localizations.of<NthuApLocalization>(context, NthuApLocalization);
  }

  /// `NTHU AiP`
  String get appName {
    return Intl.message(
      'NTHU AiP',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Campus News`
  String get campusNewsName {
    return Intl.message(
      'Campus News',
      name: 'campusNewsName',
      desc: '',
      args: [],
    );
  }

  /// `Initializing...`
  String get initializing {
    return Intl.message(
      'Initializing...',
      name: 'initializing',
      desc: '',
      args: [],
    );
  }

  /// `Select Departments`
  String get notificationDeptDialog {
    return Intl.message(
      'Select Departments',
      name: 'notificationDeptDialog',
      desc: '',
      args: [],
    );
  }

  /// `Select Notification Types`
  String get notificationTypeDialog {
    return Intl.message(
      'Select Notification Types',
      name: 'notificationTypeDialog',
      desc: '',
      args: [],
    );
  }

  /// `Select Campus`
  String get selectCampusDialog {
    return Intl.message(
      'Select Campus',
      name: 'selectCampusDialog',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get busNotAvailable {
    return Intl.message(
      'Not Available',
      name: 'busNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Main Campus`
  String get mainCampus {
    return Intl.message(
      'Main Campus',
      name: 'mainCampus',
      desc: '',
      args: [],
    );
  }

  /// `Nanda Campus`
  String get nandaCampus {
    return Intl.message(
      'Nanda Campus',
      name: 'nandaCampus',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get campusPhone {
    return Intl.message(
      'Phone',
      name: 'campusPhone',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get campusEmergencyPhone {
    return Intl.message(
      'Emergency',
      name: 'campusEmergencyPhone',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get libraryPhone {
    return Intl.message(
      'Library',
      name: 'libraryPhone',
      desc: '',
      args: [],
    );
  }

  /// `Counseling Center`
  String get counselCenterPhone {
    return Intl.message(
      'Counseling Center',
      name: 'counselCenterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Read More...`
  String get readMore {
    return Intl.message(
      'Read More...',
      name: 'readMore',
      desc: '',
      args: [],
    );
  }

  /// `minute{suffix}`
  String minute(String suffix) {
    return Intl.message(
      'minute$suffix',
      name: 'minute',
      desc: '',
      args: [suffix],
    );
  }

  /// `Update in {val} seconds`
  String busUpdateCountdown(int val) {
    return Intl.message(
      'Update in $val seconds',
      name: 'busUpdateCountdown',
      desc: '',
      args: [val],
    );
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Departed`
  String get busDeparted {
    return Intl.message(
      'Departed',
      name: 'busDeparted',
      desc: '',
      args: [],
    );
  }

  /// `Arriving`
  String get busArriving {
    return Intl.message(
      'Arriving',
      name: 'busArriving',
      desc: '',
      args: [],
    );
  }

  /// `Service Ends`
  String get lastBus {
    return Intl.message(
      'Service Ends',
      name: 'lastBus',
      desc: '',
      args: [],
    );
  }

  /// `No Service Today`
  String get noServiceToday {
    return Intl.message(
      'No Service Today',
      name: 'noServiceToday',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<NthuApLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<NthuApLocalization> load(Locale locale) =>
      NthuApLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
