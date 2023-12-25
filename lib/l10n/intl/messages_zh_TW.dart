// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_TW';

  static String m0(val) => "在 ${val} 秒後更新";

  static String m1(suffix) => "分";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("清大校務資訊平台"),
        "busArriving": MessageLookupByLibrary.simpleMessage("進站中"),
        "busDeparted": MessageLookupByLibrary.simpleMessage("已離站"),
        "busNotAvailable": MessageLookupByLibrary.simpleMessage("停駛"),
        "busUpdateCountdown": m0,
        "campusEmergencyPhone": MessageLookupByLibrary.simpleMessage("校安緊急電話"),
        "campusNewsName": MessageLookupByLibrary.simpleMessage("校園最新消息"),
        "campusPhone": MessageLookupByLibrary.simpleMessage("總機"),
        "counselCenterPhone": MessageLookupByLibrary.simpleMessage("諮詢中心"),
        "initializing": MessageLookupByLibrary.simpleMessage("初始化"),
        "lastBus": MessageLookupByLibrary.simpleMessage("結束發車"),
        "libraryPhone": MessageLookupByLibrary.simpleMessage("圖書館"),
        "mainCampus": MessageLookupByLibrary.simpleMessage("校本部"),
        "minute": m1,
        "nandaCampus": MessageLookupByLibrary.simpleMessage("南大校區"),
        "noServiceToday": MessageLookupByLibrary.simpleMessage("今日停駛"),
        "notificationDeptDialog": MessageLookupByLibrary.simpleMessage("選擇校系"),
        "notificationTypeDialog":
            MessageLookupByLibrary.simpleMessage("選擇公告類型"),
        "readMore": MessageLookupByLibrary.simpleMessage("更多..."),
        "selectCampusDialog": MessageLookupByLibrary.simpleMessage("選擇校區"),
        "tomorrow": MessageLookupByLibrary.simpleMessage("明日")
      };
}
