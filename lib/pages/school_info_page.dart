import 'dart:developer';
import 'dart:io';

import 'package:aip/widgets/shared_data_widget.dart';
import 'package:ap_common/callback/general_callback.dart';
import 'package:ap_common/models/notification_data.dart';
import 'package:ap_common/models/phone_model.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/utils/ap_utils.dart';
import 'package:ap_common/utils/preferences.dart';
import 'package:ap_common/views/notification_list_view.dart';
import 'package:ap_common/views/pdf_view.dart';
import 'package:ap_common/views/phone_list_view.dart';
import 'package:ap_common/widgets/item_picker.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:ap_common_firebase/utils/firebase_remote_config_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/notification_helper.dart';
import '../config/constants.dart';
import '../l10n/l10n.dart';
import '../views/extended_notification_view.dart';
import '../views/extended_pdf_view.dart';

class SchoolInfoPage extends StatefulWidget {
  static const String routerName = '/ShcoolInfo';

  @override
  SchoolInfoPageState createState() => SchoolInfoPageState();
}

class SchoolInfoPageState extends State<SchoolInfoPage> with SingleTickerProviderStateMixin {
  NotificationState notificationState = NotificationState.loading;
  List<Notifications> notificationList = <Notifications>[];

  int notificationPage = 1;

  int notificationDeptIndex = 0;
  int notificationTypeIndex = 0;
  int phoneCampusIndex = 0;

  PhoneState phoneState = PhoneState.finish;
  PdfState pdfState = PdfState.loading;

  late ApLocalizations ap;
  late NthuApLocalization local;
  late TabController controller;

  int _currentIndex = 0;
  Uint8List? data;

  List<PhoneModel> get phoneModelList => <PhoneModel>[
        PhoneModel(local.campusPhone, '03-571-5131'),
        PhoneModel(local.campusEmergencyPhone, campus('03-571-1814', '0911-799474')),
        PhoneModel(local.libraryPhone, campus('03-571-5131 #42983', '03-571-5131 #76341')),
        PhoneModel(local.counselCenterPhone, campus('03-571-5131 #31299', '03-571-5131 #76601')),
        PhoneModel('', 'number'),
        PhoneModel('', 'number')
      ];

  String campus(String main, String nanda) => phoneCampusIndex == 0 ? main : nanda;

  @override
  void initState() {
    FirebaseAnalyticsUtils.instance.setCurrentScreen('SchoolInfoPage', 'school_info_page.dart');
    controller = TabController(length: 3, vsync: this);
    _getNotifications();
    _getSchedules();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ap = ApLocalizations.of(context);
    local = NthuApLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(ap.schoolInfo)
      ),
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ExtendedNotificationListView(
              notificationDeptIndex: notificationDeptIndex,
              notificationTypeIndex: notificationTypeIndex,
              notificationState: notificationState,
              notificationList: notificationList,
              onRefresh: () async {
                setState(() => notificationList.clear());
                _getNotifications();
                notificationPage = 1;
              },
              onLoadingMore: () async {
                notificationPage++;
                setState(() => notificationState = NotificationState.loadingMore);
                _getNotifications();
              },
              onSelectDept: (int index) {
                setState(() {
                  notificationDeptIndex = index;
                  notificationTypeIndex = 0;
                  notificationList.clear();
                  notificationState = NotificationState.loading;
                });
                _getNotifications();
              },
              onSelectType: (int index) {
                setState(() {
                  notificationTypeIndex = index;
                  notificationList.clear();
                  notificationState = NotificationState.loading;
                });
                _getNotifications();
              }),
          Column(
            children: [
              Container(
                height: 48,
                child: ItemPicker(
                    items: [local.mainCampus, local.nandaCampus],
                    currentIndex: phoneCampusIndex,
                    dialogTitle: local.selectCampusDialog,
                    onSelected: (index) {
                      setState(() => phoneCampusIndex = index);
                    }),
              ),
              Expanded(
                  child: PhoneListView(
                state: phoneState,
                phoneModelList: phoneModelList,
              ))
            ],
          ),
          ExtendedPdfView(
            state: pdfState,
            data: data,
            onRefresh: () {
              setState(() => pdfState = PdfState.loading);
              _getSchedules();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            controller.animateTo(_currentIndex);
          });
        },
        fixedColor: ApTheme.of(context).yellow,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(ApIcon.fiberNew),
            label: ap.notifications,
          ),
          BottomNavigationBarItem(
            icon: Icon(ApIcon.phone),
            label: ap.phones,
          ),
          BottomNavigationBarItem(
            icon: Icon(ApIcon.dateRange),
            label: ap.events,
          ),
        ],
      ),
    );
  }

  void _getNotifications() async {
    if (Preferences.getBool(PreferenceKeys.offlineLogin, false)) {
      setState(() => notificationState = NotificationState.offline);
    } else {
      NotificationHelper.instance.getNotifications(
          deptIdx: notificationDeptIndex,
          typeIdx: notificationTypeIndex,
          page: notificationPage,
          callback: GeneralCallback(onSuccess: (data) async {
            notificationList.addAll(data.data.notifications);
            await NotificationHelper.instance.updateNotificationConfig();
            if (mounted) {
              setState(() => notificationState = NotificationState.finish);
            }
          }, onError: (e) {
            ApUtils.showToast(context, ap.somethingError);
            if (mounted && notificationList.isEmpty) {
              setState(() => notificationState = NotificationState.error);
            }
          }, onFailure: (e) {
            ApUtils.showToast(context, e.i18nMessage);
            if (mounted && notificationList.isEmpty) {
              setState(() => notificationState = NotificationState.error);
            }
          }));
    }
  }

  Future<void> _getSchedules() async {
    String pdfUrl = 'https://dgaa.site.nthu.edu.tw/var/file/209/1209/img/275/317165822.pdf';
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: const Duration(hours: 1),
          ),
        );
        await remoteConfig.fetchAndActivate();
        pdfUrl = remoteConfig.getString(RemoteConfigKeys.schedulePdfUrl);
        downloadFdf(pdfUrl);
      } catch (exception) {
        downloadFdf(pdfUrl);
      }
    } else {
      downloadFdf(pdfUrl);
    }
  }

  Future<void> downloadFdf(String url) async {
    try {
      final Response<Uint8List> response = await Dio().get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        pdfState = PdfState.finish;
        data = response.data;
      });
    } catch (e) {
      setState(() {
        pdfState = PdfState.error;
      });
      rethrow;
    }
  }
}
