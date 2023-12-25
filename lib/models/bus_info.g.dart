// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusInfo _$BusInfoFromJson(Map<String, dynamic> json) => BusInfo(
      code: json['code'] as int?,
      routeID: json['routeID'] as String?,
      routeName: json['routeName'] == null
          ? null
          : LocalizedString.fromJson(json['routeName'] as Map<String, dynamic>),
      subroutes: (json['subroute'] as List<dynamic>?)
          ?.map((e) => BusSubrouteInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      departure: json['departure'] == null
          ? null
          : LocalizedString.fromJson(json['departure'] as Map<String, dynamic>),
      destination: json['destination'] == null
          ? null
          : LocalizedString.fromJson(
              json['destination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusInfoToJson(BusInfo instance) => <String, dynamic>{
      'code': instance.code,
      'routeID': instance.routeID,
      'routeName': instance.routeName?.toJson(),
      'subroute': instance.subroutes?.map((e) => e.toJson()).toList(),
      'departure': instance.departure?.toJson(),
      'destination': instance.destination?.toJson(),
    };

BusSubrouteInfo _$BusSubrouteInfoFromJson(Map<String, dynamic> json) =>
    BusSubrouteInfo(
      subrouteID: json['subrouteID'] as String?,
      subrouteName: json['subrouteName'] == null
          ? null
          : LocalizedString.fromJson(
              json['subrouteName'] as Map<String, dynamic>),
      headsign: json['headsign'] == null
          ? null
          : LocalizedString.fromJson(json['headsign'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusSubrouteInfoToJson(BusSubrouteInfo instance) =>
    <String, dynamic>{
      'subrouteID': instance.subrouteID,
      'subrouteName': instance.subrouteName?.toJson(),
      'headsign': instance.headsign?.toJson(),
    };

BusList _$BusListFromJson(Map<String, dynamic> json) => BusList(
      subrouteUID: json['SubRouteUID'] as String?,
      direction: json['Direction'] as int?,
      subrouteName: LocalizedString.fromJson(
          json['SubRouteName'] as Map<String, dynamic>),
      stops: (json['Stops'] as List<dynamic>?)
          ?.map((e) => BusStop.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BusListToJson(BusList instance) => <String, dynamic>{
      'SubRouteUID': instance.subrouteUID,
      'Direction': instance.direction,
      'SubRouteName': instance.subrouteName?.toJson(),
      'Stops': instance.stops?.map((e) => e.toJson()).toList(),
    };

BusStop _$BusStopFromJson(Map<String, dynamic> json) => BusStop(
      stopUID: json['StopUID'] as String?,
      stopName:
          LocalizedString.fromJson(json['StopName'] as Map<String, dynamic>),
      time: json['time'] == null
          ? null
          : BusTime.fromJson(json['time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusStopToJson(BusStop instance) => <String, dynamic>{
      'StopUID': instance.stopUID,
      'StopName': instance.stopName?.toJson(),
      'time': instance.time?.toJson(),
    };
