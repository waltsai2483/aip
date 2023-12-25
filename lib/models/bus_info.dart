import 'dart:collection';

import 'package:aip/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bus_time.dart';
import 'localized_string.dart';

part 'bus_info.g.dart';

@JsonSerializable(explicitToJson: true)
class BusInfo {
  @JsonKey(name: 'code')
  int? code;
  @JsonKey(name: 'routeID')
  String? routeID;
  @JsonKey(name: 'routeName')
  LocalizedString? routeName;
  @JsonKey(name: 'subroute')
  List<BusSubrouteInfo>? subroutes;
  @JsonKey(name: 'departure')
  LocalizedString? departure;
  @JsonKey(name: 'destination')
  LocalizedString? destination;

  BusInfo({this.code, this.routeID, this.routeName, this.subroutes, this.departure, this.destination});

  Map<String, List<BusSubrouteInfo>> getSubrouteDetails() {
    Map<String, List<BusSubrouteInfo>> formatted = {
    };
    for (BusSubrouteInfo subrouteInfo in subroutes!) {
      if (!formatted.containsKey(subrouteInfo.subrouteID)) {
        formatted[subrouteInfo.subrouteID!] = [];
      }
      formatted[subrouteInfo.subrouteID!]!.add(subrouteInfo);
    }
    return formatted;
  }
  
  Map<String, dynamic> toJson() => _$BusInfoToJson(this);

  factory BusInfo.fromJson(Map<String, dynamic> json) => _$BusInfoFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class BusSubrouteInfo {
  @JsonKey(name: 'subrouteID')
  String? subrouteID;
  @JsonKey(name: 'subrouteName')
  LocalizedString? subrouteName;
  @JsonKey(name: 'headsign')
  LocalizedString? headsign;

  BusSubrouteInfo({this.subrouteID, this.subrouteName, this.headsign});

  Map<String, dynamic> toJson() => _$BusSubrouteInfoToJson(this);

  factory BusSubrouteInfo.fromJson(Map<String, dynamic> json) => _$BusSubrouteInfoFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class BusList {
  @JsonKey(name: 'SubRouteUID')
  String? subrouteUID;
  @JsonKey(name: 'Direction')
  int? direction;
  @JsonKey(name: 'SubRouteName', includeFromJson: true, fromJson: LocalizedString.fromJson)
  LocalizedString? subrouteName;
  @JsonKey(name: 'Stops')
  List<BusStop>? stops;

  BusList({this.subrouteUID, this.direction, this.subrouteName, this.stops});

  Map<String, dynamic> toJson() => _$BusListToJson(this);

  factory BusList.fromJson(Map<String, dynamic> json) => _$BusListFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class BusStop {
  @JsonKey(name: 'StopUID')
  String? stopUID;
  @JsonKey(name: 'StopName', includeFromJson: true, fromJson: LocalizedString.fromJson)
  LocalizedString? stopName;
  BusTime? time;

  BusStop({this.stopUID, this.stopName, this.time});

  Map<String, dynamic> toJson() => _$BusStopToJson(this);

  factory BusStop.fromJson(Map<String, dynamic> json) => _$BusStopFromJson(json);
}