import 'package:aip/l10n/l10n.dart';
import 'package:ap_common/models/notification_data.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/views/notification_list_view.dart';
import 'package:ap_common/widgets/item_picker.dart';
import 'package:flutter/cupertino.dart';

import '../api/notification_helper.dart';

class ExtendedNotificationListView extends StatefulWidget {
  final NotificationState notificationState;
  final List<Notifications> notificationList;
  final int notificationDeptIndex;
  final int notificationTypeIndex;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadingMore;
  final void Function(int) onSelectDept;
  final void Function(int) onSelectType;

  const ExtendedNotificationListView(
      {super.key,
        required this.notificationDeptIndex,
        required this.notificationTypeIndex,
      required this.notificationState,
      required this.notificationList,
      required this.onRefresh,
      required this.onLoadingMore,
      required this.onSelectDept,
      required this.onSelectType});

  @override
  State<StatefulWidget> createState() => ExtendedNotificationListViewState();
}

class ExtendedNotificationListViewState extends State<ExtendedNotificationListView> {
  late NthuApLocalization local;

  @override
  Widget build(BuildContext context) {
    local = NthuApLocalization.of(context);
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            height: 48,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: ItemPicker(
                    items: NotificationHelper.codes.map((e) => e.deptName!.of(Locale(Intl.defaultLocale!))).toList(),
                    currentIndex: widget.notificationDeptIndex,
                    dialogTitle: local.notificationDeptDialog,
                    onSelected: widget.onSelectDept,
                    featureTag: 'notification',
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: ItemPicker(
                    items: NotificationHelper.codes[widget.notificationDeptIndex].types!.map((e) => e.typeName!.of(Locale(Intl.defaultLocale!))).toList(),
                    currentIndex: widget.notificationTypeIndex,
                    dialogTitle: local.notificationTypeDialog,
                    onSelected: widget.onSelectType,
                    featureTag: 'notification',
                  ),
                )
              ],
            )),
        Expanded(
          child: NotificationListView(
            state: widget.notificationState,
            notificationList: widget.notificationList,
            onRefresh: widget.onRefresh,
            onLoadingMore: widget.onLoadingMore,
          ),
        )
      ],
    );
  }
}
