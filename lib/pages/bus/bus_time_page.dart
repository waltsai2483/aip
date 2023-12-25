import 'dart:async';

import 'package:aip/config/themes.dart';
import 'package:aip/l10n/l10n.dart';
import 'package:ap_common/api/announcement_helper.dart';
import 'package:ap_common/l10n/l10n.dart';
import 'package:ap_common/resources/ap_colors.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/widgets/hint_content.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:flutter/material.dart';

import '../../api/bus_helper.dart';
import '../../models/bus_info.dart';
import '../../models/bus_time.dart';

enum _State { loading, finishParts, finish, error }

class BusTimePage extends StatefulWidget {
  final Locale locale;
  final BusInfo busInfo;

  const BusTimePage({
    Key? key,
    required this.busInfo,
    required this.locale,
  }) : super(key: key);

  @override
  _BusTimePageState createState() => _BusTimePageState();
}

class _BusTimePageState extends State<BusTimePage> with TickerProviderStateMixin {
  _State state = _State.loading;

  List<BusList>? busRoutes;
  List<BusTime>? busTimes;
  List<BusDepartSchedule>? busSchedules;

  late final List<int>? _pageCache;
  late final Map<String, List<BusSubrouteInfo>>? subrouteDetails;

  late TabController _subrouteController;
  late TabController _directionController;
  late TabController _pageController;

  @override
  void initState() {
    subrouteDetails = widget.busInfo.getSubrouteDetails();
    _pageCache = List.filled(subrouteDetails!.length, 0);
    for (int i = 1; i < subrouteDetails!.length; i++) {
      _pageCache![i] = subrouteDetails!.values.elementAt(i - 1).length + _pageCache![i - 1];
    }
    _subrouteController = TabController(vsync: this, length: subrouteDetails!.length, initialIndex: 0);
    _subrouteController.addListener(() {
      if (_subrouteController.indexIsChanging) {
        setState(() {
          _directionController.dispose();
          _directionController = TabController(vsync: this, length: subrouteDetails!.values.elementAt(_subrouteController.index).length);
          _directionController.addListener(() async {
            if (_directionController.indexIsChanging) {
              _pageController.index = _pageCache![_subrouteController.index] + _directionController.index;
            }
          });
        });
        _directionController.animateTo(0);
        _pageController.index = _pageCache![_subrouteController.index] + _directionController.index;
      }
    });
    _directionController = TabController(vsync: this, length: subrouteDetails!.values.elementAt(_subrouteController.index).length);
    _directionController.addListener(() async {
      if (_directionController.indexIsChanging) {
        if (_directionController.indexIsChanging) {
          _pageController.index = _pageCache![_subrouteController.index] + _directionController.index;
        }
      }
    });
    _pageController = TabController(vsync: this, length: widget.busInfo.subroutes!.length);
    _initAndGetDatas();
    FirebaseAnalyticsUtils.instance.setCurrentScreen(
      'BusTimePage',
      'bus_time_page.dart',
    );
    super.initState();
  }

  @override
  void dispose() {
    _subrouteController.dispose();
    _directionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BusInfo busInfo = widget.busInfo;
    return Scaffold(
      appBar: AppBar(title: Text(widget.busInfo.routeName!.of(widget.locale)), elevation: 2),
      body: _body(),
    );
  }

  Widget _body() {
    switch (state) {
      case _State.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case _State.error:
        return InkWell(
          onTap: () {
            _getData();
          },
          child: HintContent(
            icon: ApIcon.error,
            content: ApLocalizations.current.clickToRetry,
          ),
        );
      default:
        return busRoutes == null || busRoutes!.isEmpty
            ? InkWell(
                onTap: () => _getData(),
                child: HintContent(
                  icon: ApIcon.info,
                  content: ApLocalizations.of(context).busEmpty,
                ),
              )
            : Column(
                children: [
                  Material(
                      color: NthuApTheme.of(context).purpleAppbar,
                      child: TabBar(
                        controller: _subrouteController,
                        tabs: subrouteDetails!.values
                            .map((e) => Tab(
                                  child: Text(e[0].subrouteName!.of(widget.locale), textAlign: TextAlign.center),
                                ))
                            .toList(),
                      )),
                  Material(
                      color: NthuApTheme.of(context).purpleTabbarDark,
                      child: TabBar.secondary(
                        controller: _directionController,
                        tabs: subrouteDetails!.values
                            .elementAt(_subrouteController.index)
                            .map((e) => Tab(
                                  child: Text(e.headsign!.of(widget.locale),
                                      style: TextStyle(fontSize: 12.0), textAlign: TextAlign.center, overflow: TextOverflow.visible),
                                ))
                            .toList(),
                      )),
                  Expanded(
                      child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: _getStopLists(),
                  )),
                  UpdateCountdownBar(counterListener: () {
                    _getData(firstLoad: false);
                  })
                ],
              );
    }
  }

  void _initAndGetDatas() async {
    await BusHelper.init(
        callback: GeneralCallback<void>(
      onFailure: (error) {
        setState(() => state = _State.error);
      },
      onError: (error) {
        setState(() => state = _State.error);
      },
      onSuccess: (_) {},
    ));
    await _getData();
  }

  void _updatePageController() {
    _pageController.index = _pageCache![_subrouteController.index] + _directionController.index;
  }

  List<Widget> _getStopLists() {
    List<Widget> lists = [];
    for (BusList route in busRoutes!) {
      lists.add(ListView.separated(
          itemCount: route.stops!.length,
          separatorBuilder: (_, __) => const Divider(height: 1.0),
          itemBuilder: (_, int index) => BusTimeItem(
                prevStopDuration: index == 0 ? null : route.stops?[index - 1].time?.arrivalTime,
                timeLoadFinished: state == _State.finishParts,
                stopData: route.stops![index],
                locale: widget.locale,
                scheduledTime: busSchedules?.where((e) => e.subrouteID == route.subrouteUID).firstOrNull?.timetables?[index],
              )));
    }
    return lists;
  }

  Future<void> _getData({bool firstLoad = true}) async {
    await BusHelper.of(widget.busInfo.code!).getBusRoutes(
      busID: widget.busInfo.routeName!.of(widget.locale),
      callback: GeneralCallback<List<BusList>?>(
        onFailure: (error) {
          setState(() => state = _State.error);
        },
        onError: (error) {
          setState(() => state = _State.error);
        },
        onSuccess: (List<BusList>? data) {
          busRoutes = data ?? <BusList>[];
          if (firstLoad) setState(() => state = _State.finishParts);
        },
      ),
    );
    await BusHelper.of(widget.busInfo.code!).getBusTimes(
      busID: widget.busInfo.routeName!.of(widget.locale),
      callback: GeneralCallback<List<BusTime>?>(
        onFailure: (error) {
          setState(() => state = _State.error);
        },
        onError: (error) {
          setState(() => state = _State.error);
        },
        onSuccess: (List<BusTime>? data) {
          setState(() {
            for (BusTime time in data!) {
              final list = busRoutes!.where((e) => e.subrouteUID == time.subrouteID && e.direction == time.direction).firstOrNull;
              if (list == null) continue;
              list.stops![time.seq! - 1].time = time;
            }
          });
        },
      ),
    );
    await BusHelper.of(widget.busInfo.code!).getBusLastDepartTime(
      busID: widget.busInfo.routeName!.of(widget.locale),
      callback: GeneralCallback<List<BusDepartSchedule>?>(
        onFailure: (error) {
          setState(() => state = _State.error);
        },
        onError: (error) {
          setState(() => state = _State.error);
        },
        onSuccess: (List<BusDepartSchedule>? data) {
          setState(() {
            busSchedules = data ?? <BusDepartSchedule>[];
            state = _State.finish;
          });
        },
      ),
    );
  }
}

class BusTimeItem extends StatelessWidget {
  final Duration? prevStopDuration;
  final BusDepartTime? scheduledTime;

  final BusStop stopData;
  final Locale locale;

  final bool timeLoadFinished;

  const BusTimeItem({Key? key, required this.stopData, required this.locale, required this.timeLoadFinished, this.prevStopDuration, this.scheduledTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = stopData.time;
    Color color = ApTheme.of(context).greyText;
    String arrivedTimeText = '';
    if (timeLoadFinished) {
      arrivedTimeText = ApLocalizations.of(context).loading;
    }
    else if (time != null && time.arrivalTime!.inSeconds != -1) {
      if (time.arrivalTime!.inMinutes < 1) {
        arrivedTimeText = NthuApLocalization.of(context).busArriving;
        color = ApTheme.of(context).green;
      } else {
        arrivedTimeText = '${time.arrivalTime!.inMinutes}${NthuApLocalization.of(context).minute(time.arrivalTime!.inMinutes == 1 ? 's' : '')}';
        if (prevStopDuration != null && (prevStopDuration!.inSeconds > time.arrivalTime!.inSeconds || prevStopDuration!.inSeconds == -1)) {
          color = ApTheme.of(context).yellow;
        }
      }
    } else {
      if (time != null) {
        arrivedTimeText = NthuApLocalization.of(context).lastBus;
      } else {
        arrivedTimeText = NthuApLocalization.of(context).busDeparted;
      }
      if ((time == null || time.isLastBus!) && scheduledTime != null) {
        if (scheduledTime!.isTomorrow) {
          arrivedTimeText = "${NthuApLocalization.of(context).tomorrow} ${scheduledTime!.arrivalTime!}";
        } else {
          arrivedTimeText = scheduledTime!.arrivalTime!;
        }
      } else if (scheduledTime == null) {
        arrivedTimeText = NthuApLocalization.of(context).noServiceToday;
      }
      color = ApTheme.of(context).red;
    }
    return ListTile(
      leading: Container(
        height: 40.0,
        width: 84.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          arrivedTimeText,
          style: TextStyle(
            fontSize: 12.0,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(stopData.stopName!.of(locale)),
    );
  }
}

class UpdateCountdownBar extends StatefulWidget {
  final void Function() counterListener;

  const UpdateCountdownBar({super.key, required this.counterListener});

  @override
  State<StatefulWidget> createState() => UpdateCountdownBarState();
}

class UpdateCountdownBarState extends State<UpdateCountdownBar> {
  late Timer timer;
  late int count;

  @override
  void initState() {
    count = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        count++;
      });
      if (count >= 30) {
        widget.counterListener();
        count = 0;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: ApTheme.of(context).grey))),
        child: Text(NthuApLocalization.of(context).busUpdateCountdown(30 - count)),
      );
}
