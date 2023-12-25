// ignore_for_file: prefer_single_quotes

import 'package:aip/config/icons.dart';
import 'package:aip/config/themes.dart';
import 'package:aip/l10n/l10n.dart';
import 'package:ap_common/callback/general_callback.dart';
import 'package:ap_common/l10n/l10n.dart';
import 'package:ap_common/resources/ap_colors.dart';
import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/resources/ap_theme.dart';
import 'package:ap_common/widgets/hint_content.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/bus_helper.dart';
import '../../models/bus_info.dart';
import 'bus_time_page.dart';

enum _State { loading, finish, error }

class BusListPage extends StatefulWidget {
  final Locale locale;

  const BusListPage({
    Key? key,
    required this.locale,
  }) : super(key: key);

  @override
  _BusListPageState createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  _State state = _State.loading;

  List<BusInfo> busList = <BusInfo>[];

  late NthuApLocalization local;

  @override
  void initState() {
    print(widget.locale);
    _getData();
    FirebaseAnalyticsUtils.instance.setCurrentScreen(
      'BusListPage',
      "bus_list_page.dart",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    local = NthuApLocalization.of(context);
    final ApLocalizations ap = ApLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(ap.bus),
      ),
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
        return ListView.builder(
          itemCount: busList.length,
          itemBuilder: (_, int index) {
            final BusInfo bus = busList[index];
            return ListTile(
              title: Text(
                bus.routeName?.of(widget.locale) ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                (bus.code != -1) ? '${bus.departure?.of(widget.locale)} - ${bus.destination?.of(widget.locale)}' : local.busNotAvailable,
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
              trailing: Icon((bus.code != -1) ? NthuApIcon.arrowRight : ApIcon.cancel, color: (bus.code != -1) ? ApTheme.of(context).green : ApTheme.of(context).red),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<dynamic>(
                    builder: (_) => BusTimePage(
                      busInfo: bus,
                      locale: widget.locale,
                    ),
                  ),
                );
              },
            );
          },
        );
    }
  }

  Future<void> _getData() async {
    BusHelper.cityBus.getBusInfo(
      callback: GeneralCallback<List<BusInfo>?>(
        onFailure: (_) {
          setState(() => state = _State.error);
        },
        onError: (_) {
          setState(() => state = _State.error);
        },
        onSuccess: (List<BusInfo>? data) {
          busList = data ?? <BusInfo>[];
          setState(() => state = _State.finish);
        },
      ),
    );
  }
}
