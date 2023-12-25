import 'dart:async';

import 'package:aip/api/notification_helper.dart';
import 'package:aip/config/constants.dart';
import 'package:aip/l10n/l10n.dart';
import 'package:aip/pages/bus/bus_list_page.dart';
import 'package:aip/pages/school_info_page.dart';
import 'package:aip/pages/setting_page.dart';
import 'package:aip/views/extended_notification_view.dart';
import 'package:aip/widgets/nthu_ap_drawer.dart';
import 'package:aip/widgets/shared_data_widget.dart';
import 'package:ap_common/api/announcement_helper.dart';
import 'package:ap_common/config/analytics_constants.dart';
import 'package:ap_common/models/notification_data.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/scaffold/login_scaffold.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/utils/ap_utils.dart';
import 'package:ap_common/utils/preferences.dart';
import 'package:ap_common/views/notification_list_view.dart';
import 'package:ap_common/widgets/ap_drawer.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

export 'package:ap_common/models/announcement_data.dart';

enum HomeState { loading, finish, error, empty, offline }

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Widget? content;
  bool isLogin = false;
  int notificationPage = 1;
  int notificationDeptIndex = 0;
  int notificationTypeIndex = 0;

  late NthuApLocalization local;
  late ApLocalizations ap;

  PageController? pageController;
  NotificationState notificationState = NotificationState.loading;
  List<Notifications> notificationList = <Notifications>[];

  bool get isTablet => MediaQuery.of(context).size.shortestSide >= 680;

  bool get isMobile => MediaQuery.of(context).size.shortestSide < 680;

  @override
  void initState() {
    super.initState();
    _getNotifications();
    FirebaseAnalyticsUtils.instance.setUserProperty(
      AnalyticsConstants.language,
      Locale(Intl.defaultLocale!).languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    local = NthuApLocalization.of(context);
    ap = ApLocalizations.of(context);
    return Row(
      children: <Widget>[
        if (isTablet) drawer,
        Expanded(
          child: (isTablet && content != null)
              ? content!
              : ScaffoldMessenger(
                  key: _scaffoldMessengerKey,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(local.appName ?? ''),
                      actions: [
                        IconButton(
                          icon: Icon(ApIcon.settings),
                          onPressed: () => _openPage(SettingPage()),
                        ),
                      ],
                    ),
                    drawer: isTablet ? null : drawer,
                    body: OrientationBuilder(
                      builder: (_, Orientation orientation) => Column(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: (isTablet || orientation == Orientation.landscape) ? 32.0 : 8.0),
                                  child: ExtendedNotificationListView(
                                      notificationDeptIndex: notificationDeptIndex,
                                      notificationTypeIndex: notificationTypeIndex,
                                      notificationState: notificationState,
                                      notificationList: notificationList,
                                      onRefresh: () async {
                                        setState(() => notificationList.clear());
                                        _getNotifications();
                                        notificationPage = 1;
                                      },
                                      onLoadingMore: () async {},
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
                                      }))),
                          Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 12.0, left: orientation == Orientation.landscape ? 24.0 : 8.0, right: orientation == Orientation.landscape ? 24.0 : 8.0),
                            child: ApButton(
                              text: ap.schoolInfo,
                              onPressed: () {
                                //await FirebaseAnalytics.instance.setUserProperty(name: AnalyticsConstants.language, value: Locale(Intl.defaultLocale!).languageCode);
                                _openPage(SchoolInfoPage(), useCupertinoRoute: false);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(child: Container(
                                padding: EdgeInsets.only(top: 0.0, bottom: 16.0, left: orientation == Orientation.landscape ? 24.0 : 8.0, right: orientation == Orientation.landscape ? 24.0 : 8.0),
                                child: ApButton(
                                  text: local.readMore,
                                  onPressed: () {
                                    //await FirebaseAnalytics.instance.setUserProperty(name: AnalyticsConstants.language, value: Locale(Intl.defaultLocale!).languageCode);
                                    _openPage(SchoolInfoPage(), useCupertinoRoute: false);
                                  },
                                ),
                              ),),
                              Flexible(child: Container(
                                padding: EdgeInsets.only(top: 0.0, bottom: 16.0, left: orientation == Orientation.landscape ? 24.0 : 8.0, right: orientation == Orientation.landscape ? 24.0 : 8.0),
                                child: ApButton(
                                  text: local.readMore,
                                  onPressed: () {
                                    //await FirebaseAnalytics.instance.setUserProperty(name: AnalyticsConstants.language, value: Locale(Intl.defaultLocale!).languageCode);
                                    _openPage(SchoolInfoPage(), useCupertinoRoute: false);
                                  },
                                ),
                              ),),
                            ],
                          )
                        ],
                      ),
                    ),
                    bottomNavigationBar: (isTablet)
                        ? null
                        : BottomNavigationBar(
                            elevation: 12.0,
                            fixedColor: ApTheme.of(context).bottomNavigationSelect,
                            unselectedItemColor: ApTheme.of(context).bottomNavigationSelect,
                            type: BottomNavigationBarType.fixed,
                            selectedFontSize: 12.0,
                            selectedIconTheme: const IconThemeData(size: 24.0),
                            onTap: (int index) {
                              if (index == 0) {
                                _openPage(BusListPage(locale: Locale(Intl.defaultLocale!)));
                              }
                            },
                            items: [
                              BottomNavigationBarItem(
                                icon: Icon(ApIcon.directionsBus),
                                label: ap.bus,
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(ApIcon.classIcon),
                                label: ap.course,
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(ApIcon.assignment),
                                label: ap.score,
                              ),
                            ],
                          ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget get drawer => NthuApDrawer(
      onTapHeader: () {},
      widgets: [
        DrawerItem(
          icon: ApIcon.home,
          title: "TEST",
          onTap: () {
            setState(() {});
          },
        ),
      ]);

  void _getNotifications() async {
    if (Preferences.getBool(PreferenceKeys.offlineLogin, false)) {
      setState(() => notificationState = NotificationState.offline);
    } else {
      NotificationHelper.instance.getNotifications(
          deptIdx: notificationDeptIndex,
          typeIdx: notificationTypeIndex,
          page: notificationPage,
          callback: GeneralCallback(onSuccess: (data) {
            notificationList.addAll(data.data.notifications);
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

  Future<void> _openPage(
    Widget page, {
    bool needLogin = false,
    bool useCupertinoRoute = true,
  }) async {
    //if (isMobile) Navigator.of(context).pop();
    if (needLogin && !isLogin) {
      ApUtils.showToast(
        context,
        ApLocalizations.of(context).notLoginHint,
      );
    } else {
      if (isMobile) {
        if (useCupertinoRoute) {
          ApUtils.pushCupertinoStyle(context, page);
        } else {
          await Navigator.push(
            context,
            CupertinoPageRoute<void>(builder: (_) => page),
          );
        }
        // checkLogin();
      } else {
        setState(() => content = page);
      }
    }
  }

  void hideSnackBar() {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  void showBasicHint({required String text}) {
    showSnackBar(
      text: text,
      duration: const Duration(seconds: 2),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar({
    required String text,
    String? actionText,
    Function()? onSnackBarTapped,
    Duration? duration,
  }) {
    return _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: duration ?? const Duration(days: 1),
        action: actionText == null
            ? null
            : SnackBarAction(
                onPressed: onSnackBarTapped!,
                label: actionText,
                textColor: ApTheme.of(context).snackBarActionTextColor,
              ),
      ),
    );
  }
}
