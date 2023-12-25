import 'package:aip/models/localized_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationDept {
  @JsonKey(name: 'name')
  LocalizedString? deptName;
  @JsonKey(name: 'link')
  String? link;
  @JsonKey(name: 'types')
  List<NotificationType>? types;

  NotificationDept({this.deptName, this.link, this.types});

  Map<String, dynamic> toJson() => _$NotificationDeptToJson(this);

  factory NotificationDept.fromJson(Map<String, dynamic> json) => _$NotificationDeptFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class NotificationType {
  @JsonKey(name: 'rcg')
  int? rcgKey;
  @JsonKey(name: 'name')
  LocalizedString? typeName;

  NotificationType({this.rcgKey, this.typeName});

  Map<String, dynamic> toJson() => _$NotificationTypeToJson(this);

  factory NotificationType.fromJson(Map<String, dynamic> json) => _$NotificationTypeFromJson(json);
}