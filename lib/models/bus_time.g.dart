// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusTime _$BusTimeFromJson(Map<String, dynamic> json) => BusTime(
      seq: json['StopSequence'] as int?,
      subrouteID: json['SubRouteUID'] as String?,
      direction: json['Direction'] as int?,
      stopID: json['StopUID'] as String?,
      arrivalTime: BusTime._secondsToDuration(json['EstimateTime'] as int?),
      isLastBus: json['IsLastBus'] as bool?,
    );

Map<String, dynamic> _$BusTimeToJson(BusTime instance) => <String, dynamic>{
      'StopSequence': instance.seq,
      'SubRouteUID': instance.subrouteID,
      'Direction': instance.direction,
      'StopUID': instance.stopID,
      'EstimateTime': BusTime._durationToSeconds(instance.arrivalTime),
      'IsLastBus': instance.isLastBus,
    };

BusDepartSchedule _$BusDepartScheduleFromJson(Map<String, dynamic> json) =>
    BusDepartSchedule(
      subrouteID: json['SubRouteUID'] as String?,
      direction: json['Direction'] as int?,
      timetables: BusDepartSchedule.timetableFilter(
          json['Timetables'] as List<dynamic>),
    );

Map<String, dynamic> _$BusDepartScheduleToJson(BusDepartSchedule instance) =>
    <String, dynamic>{
      'SubRouteUID': instance.subrouteID,
      'Direction': instance.direction,
      'Timetables': instance.timetables?.map((e) => e.toJson()).toList(),
    };

BusDepartTime _$BusDepartTimeFromJson(Map<String, dynamic> json) =>
    BusDepartTime(
      seq: json['StopSequence'] as int?,
      arrivalTime: json['ArrivalTime'] as String?,
    );

Map<String, dynamic> _$BusDepartTimeToJson(BusDepartTime instance) =>
    <String, dynamic>{
      'StopSequence': instance.seq,
      'ArrivalTime': instance.arrivalTime,
    };
