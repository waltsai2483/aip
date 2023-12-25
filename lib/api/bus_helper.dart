import 'dart:convert';

import 'package:aip/config/constants.dart';
import 'package:aip/models/bus_time.dart';
import 'package:ap_common/api/announcement_helper.dart';
import 'package:ap_common/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/bus_info.dart';

class BusHelper {
  BusHelper(this.busType);

  static Dio dio = Dio();

  static BusHelper get cityBus => _cityBus ??= BusHelper('City/Hsinchu');

  static BusHelper get intercityBus => _intercityBus ??= BusHelper('InterCity');

  static BusHelper of(int code) => code == -1 || code == 0 ? cityBus : intercityBus;

  static BusHelper? _cityBus;
  static BusHelper? _intercityBus;

  static const baseUrl = 'https://tdx.transportdata.tw';

  final String busType;
  static String? accessToken;
  static DateTime? dateTime;

  static Future<void> init({required GeneralCallback<void> callback}) async {
    accessToken = Preferences.getString(PreferenceKeys.tdxAccessToken, '');
    dateTime = DateTime.tryParse(Preferences.getString(PreferenceKeys.tdxTokenExpiry, '1999/1/1'));
    if (dateTime == null || DateTime.now().compareTo(dateTime!.add(const Duration(days: 1))) > 0) {
      try {
        final busApi = await Assets.tdxClientSecret;
        dio.options.headers = {"content-type": "application/x-www-form-urlencoded"};
        final response = await dio.post('$baseUrl/auth/realms/TDXConnect/protocol/openid-connect/token',
            data: {"grant_type": "client_credentials", "client_id": busApi['client_id'], "client_secret": busApi['client_secret']});
        Preferences.setString(PreferenceKeys.tdxAccessToken, accessToken = response.data['access_token']);
        Preferences.setString(PreferenceKeys.tdxTokenExpiry, (dateTime = DateTime.now()).toIso8601String());
        dio.options.headers = {'accept': 'application/json', 'authorization': 'Bearer $accessToken',
          'Content-Encoding': 'br,gzip'};
        callback.onSuccess("");
      } on DioException catch (dioError) {
        if (dioError.response != null) {
          callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode!, message: dioError.message!));
        } else {
          callback.onFailure(dioError);
        }
      } on Exception catch (_) {
        callback.onError(GeneralResponse.unknownError());
      }
    }
  }

  Future<void> getBusInfo({required GeneralCallback<List<BusInfo>?> callback}) async {
    try {
      final response = await dio.get('https://waltsai2483.github.io/nthu-aip-storage/bus/bus_info.json');
      final List<BusInfo> jsonList = (response.data! as List).map((e) => BusInfo.fromJson(e)).toList();
      callback.onSuccess(jsonList);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode!, message: dioError.message!));
      } else {
        callback.onFailure(dioError);
      }
    } on Exception catch (_) {
      callback.onError(GeneralResponse.unknownError());
    }
  }

  Future<void> getBusRoutes({required String busID, required GeneralCallback<List<BusList>?> callback}) async {
    try {
      setHeaders();
      final response = await dio.get('$baseUrl/api/basic/v2/Bus/StopOfRoute/$busType/$busID?%24top=100&%24format=JSON');
      final List<BusList> jsonList = (response.data! as List<dynamic>).map((e) => BusList.fromJson(e as Map<String, dynamic>)).toList();
      final List<BusList> checkedList = [];
      for (BusList list in jsonList) {
        if (checkedList.isEmpty || checkedList.where((curr) => curr.subrouteUID == list.subrouteUID && curr.direction == list.direction).isEmpty) {
          checkedList.add(list);
        }
      }
      callback.onSuccess(checkedList);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode!, message: dioError.message!));
      } else {
        callback.onFailure(dioError);
      }
    } on Exception catch (_) {
      callback.onError(GeneralResponse.unknownError());
    }
  }

  Future<void> getBusTimes({required String busID, required GeneralCallback<List<BusTime>?> callback}) async {
    try {
      setHeaders();
      final response = await dio.get('$baseUrl/api/basic/v2/Bus/EstimatedTimeOfArrival/$busType/$busID?%24top=150&%24format=JSON');
      final List<BusTime> jsonList = (response.data! as List<dynamic>).map((e) => BusTime.fromJson(e as Map<String, dynamic>)).toList();
      callback.onSuccess(jsonList);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode!, message: dioError.message!));
      } else {
        callback.onFailure(dioError);
      }
    } on Exception catch (_) {
      callback.onError(GeneralResponse.unknownError());
    }
  }

  Future<void> getBusLastDepartTime({required String busID, required GeneralCallback<List<BusDepartSchedule>?> callback}) async {
    try {
      setHeaders();
      final response = await dio.get('$baseUrl/api/basic/v2/Bus/DailyTimeTable/$busType/$busID?%24top=150&%24format=JSON');
      final List<BusDepartSchedule> jsonList = (response.data! as List<dynamic>).map((e) => BusDepartSchedule.fromJson(e as Map<String, dynamic>)).toList();
      callback.onSuccess(jsonList);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        callback.onError(GeneralResponse(statusCode: dioError.response!.statusCode!, message: dioError.message!));
      } else {
        callback.onFailure(dioError);
      }
    } on Exception catch (_) {
      callback.onError(GeneralResponse.unknownError());
    }
  }

  void setHeaders() => dio.options.headers = {'accept': 'application/json', 'authorization': 'Bearer $accessToken',
    'Content-Encoding': 'br,gzip'};
}
