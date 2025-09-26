// ignore_for_file: invalid_annotation_target
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_notification.freezed.dart';
part 'auto_notification.g.dart';

@freezed
class AutoNotification with _$AutoNotification {
  const factory AutoNotification({
    @Default(-1) int id,
    @Default("-1") String days,
    @Default("0") String status, // disable
    @Default("0") String app,
    @Default("0") String browser,
    @Default("Vui đọc cùng em xin chào bạn!") String application,
    @Default("") String title,
    @Default("") String content,
    @Default(-1) int type, // 1 là push_notification - 0 là auto_notification
    @Default(0) int notiType, // 1 là push_notification - 0 là auto_notification
    @JsonKey(name: "created_at") @Default("") String createdAt,
    @JsonKey(name: "is_read") @Default(0) int isRead,
    @JsonKey(name: "parent_id") @Default(0) int parentId,
    // @JsonKey("is_sent") String isSent,
  }) = _AutoNotification;
  factory AutoNotification.fromJson(Map<String, dynamic> json) =>
      _$AutoNotificationFromJson(json);
}
