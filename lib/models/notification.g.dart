// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDept _$NotificationDeptFromJson(Map<String, dynamic> json) =>
    NotificationDept(
      deptName: json['name'] == null
          ? null
          : LocalizedString.fromJson(json['name'] as Map<String, dynamic>),
      link: json['link'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => NotificationType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationDeptToJson(NotificationDept instance) =>
    <String, dynamic>{
      'name': instance.deptName?.toJson(),
      'link': instance.link,
      'types': instance.types?.map((e) => e.toJson()).toList(),
    };

NotificationType _$NotificationTypeFromJson(Map<String, dynamic> json) =>
    NotificationType(
      rcgKey: json['rcg'] as int?,
      typeName: json['name'] == null
          ? null
          : LocalizedString.fromJson(json['name'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationTypeToJson(NotificationType instance) =>
    <String, dynamic>{
      'rcg': instance.rcgKey,
      'name': instance.typeName?.toJson(),
    };
