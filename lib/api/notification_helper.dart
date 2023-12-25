import 'dart:convert';

import 'package:aip/config/constants.dart';
import 'package:aip/models/notification.dart';
import 'package:ap_common/callback/general_callback.dart';
import 'package:ap_common/models/notification_data.dart';
import 'package:ap_common/utils/preferences.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class NotificationHelper {
  NotificationHelper();

  static NotificationHelper get instance => _instance ??= NotificationHelper();
  static NotificationHelper? _instance;

  static List<String> get depts => ['校本部', '資工系'];

  static List<NotificationDept> get codes => (jsonDecode(Preferences.getString(PreferenceKeys.notificationConfig, "[{\"name\": {\"zh\":\"--\", \"en\":\"--\"}, \"type\": [], \"link\":\"\"}]")) as List<dynamic>).map((e) => NotificationDept.fromJson(e)).toList();

  static int retryCount = 0;
  static int retryCountLimit = 3;

  Dio dio = Dio();

  Future<void> updateNotificationConfig() async {
    final response = await dio.get('https://waltsai2483.github.io/nthu-aip-storage/bulletin/notification.json');
    await Preferences.setString(PreferenceKeys.notificationConfig, jsonEncode(response.data));
  }

  Future<void> getNotifications({required int deptIdx, required int typeIdx, required int page, required GeneralCallback callback}) async {
    try {
      if (!Preferences.prefs!.containsKey(PreferenceKeys.notificationConfig)) {
        await updateNotificationConfig();
      }
      NotificationsData data = await _getNotifications(codes[deptIdx].link!, codes[deptIdx].types![typeIdx].rcgKey!, page);
      callback.onSuccess(data);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode ?? 200, message: dioError.response!.data));
      } else {
        callback.onFailure(dioError);
      }
    } catch (e, s) {
      callback.onError(GeneralResponse.unknownError());
      /*
      if (FirebaseCrashlyticsUtils.isSupported) {
        await FirebaseCrashlytics.instance.recordError(e, s);
      }
       */
    }
  }

  Future<NotificationsData> _getNotifications(String link, int deptCode, int page) async {
    final int baseIndex = (page - 1) * 15;
    if (retryCount > retryCountLimit) {
      throw 'NullThrownError';
    }
    final Response<String> res = await dio.post<String>(
      '$link?Action=mobilercglist',
      data: <String, dynamic>{
        'Rcg': deptCode,
        'Op': 'getpartlist',
        'Page': page - 1,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    List<Map<String, dynamic>> notificationDatas;
    if (res.statusCode == 200 && res.data != null) {
      notificationDatas = _parse(
        html: (json.decode(res.data!) as Map<String, dynamic>)['content'] as String,
        baseIndex: baseIndex,
      );
      retryCount = 0;
    } else {
      retryCount++;
      return _getNotifications(link, deptCode, page);
    }
    return NotificationsData.fromJson(<String, dynamic>{
      'data': <String, dynamic>{
        'page': page + 1,
        'notification': notificationDatas,
      }
    });
  }

  List<Map<String, dynamic>> _parse({
    required String? html,
    required int baseIndex,
  }) {
    final List<Map<String, dynamic>> dataList = <Map<String, dynamic>>[];
    final dom.Document document = parse(html?.replaceAll("\\\"", "\""));
    final List<dom.Element> tdElements = document.getElementsByClassName('row listBS');
    for (final dom.Element element in tdElements) {
      final Map<String, dynamic> temp = <String, dynamic>{};
      final Map<String, dynamic> info = <String, dynamic>{};
      if (element.getElementsByClassName('d-txt').isNotEmpty) {
        info['date'] = element.getElementsByClassName('mdate').first.text;
        info['department'] = '';
      }
      if (element.getElementsByTagName('a').isNotEmpty) {
        info['index'] = baseIndex;
        baseIndex++;
        info['title'] = element.getElementsByTagName('a')[0].attributes['title'];
        temp['link'] = element.getElementsByTagName('a')[0].attributes['href'];
        temp['info'] = info;
        dataList.add(temp);
      }
    }
    return dataList;
  }
}