import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'localized_string.dart';

part 'bus_time.g.dart';

@JsonSerializable(explicitToJson: true)
class BusTime {
  @JsonKey(name: 'StopSequence')
  int? seq;
  @JsonKey(name: 'SubRouteUID')
  String? subrouteID;
  @JsonKey(name: 'Direction')
  int? direction;
  @JsonKey(name: 'StopUID')
  String? stopID;
  @JsonKey(name: 'EstimateTime', fromJson: _secondsToDuration, toJson: _durationToSeconds, includeIfNull: true)
  Duration? arrivalTime;
  @JsonKey(name: 'IsLastBus')
  bool? isLastBus;

  BusTime({this.seq, this.subrouteID, this.direction, this.stopID, this.arrivalTime, this.isLastBus});

  Map<String, dynamic> toJson() => _$BusTimeToJson(this);

  factory BusTime.fromJson(Map<String, dynamic> json) => _$BusTimeFromJson(json);

  static Duration? _secondsToDuration(int? second) => Duration(seconds: second ?? -1);

  static int? _durationToSeconds(Duration? duration) => duration?.inSeconds;
}

@JsonSerializable(explicitToJson: true)
class BusDepartSchedule {
  @JsonKey(name: 'SubRouteUID')
  String? subrouteID;
  @JsonKey(name: 'Direction')
  int? direction;
  @JsonKey(name: 'Timetables', fromJson: timetableFilter)
  List<BusDepartTime>? timetables;

  BusDepartSchedule({this.subrouteID, this.direction, this.timetables});

  Map<String, dynamic> toJson() => _$BusDepartScheduleToJson(this);

  factory BusDepartSchedule.fromJson(Map<String, dynamic> json) => _$BusDepartScheduleFromJson(json);

  static List<BusDepartTime>? timetableFilter(List<dynamic> list) {
    for (Map<String, dynamic> times in list) {
      if ((times['StopTimes'] as List).isEmpty) continue;
      final time = (times['StopTimes'][0]['ArrivalTime'] as String).split(':').map((e) => int.parse(e)).toList();
      if (time[0] > TimeOfDay.now().hour || time[0] == TimeOfDay.now().hour && time[1] > TimeOfDay.now().minute) {
        return (list[0]['StopTimes'] as List<dynamic>).map((e) => BusDepartTime.fromJson(e, false)).toList();
      }
    }
    return (list[0]['StopTimes'] as List<dynamic>).map((e) => BusDepartTime.fromJson(e, true)).toList();
  }
}

@JsonSerializable(explicitToJson: true)
class BusDepartTime {
  @JsonKey(name: 'StopSequence')
  int? seq;
  @JsonKey(name: 'ArrivalTime')
  String? arrivalTime;

  bool isTomorrow = false;

  BusDepartTime({this.seq, this.arrivalTime});

  Map<String, dynamic> toJson() => _$BusDepartTimeToJson(this);

  factory BusDepartTime.fromJson(Map<String, dynamic> json, bool isTomorrow) {
    final temp = _$BusDepartTimeFromJson(json);
    temp.isTomorrow = isTomorrow;
    return temp;
  }
}
