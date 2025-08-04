import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    @JsonKey(name: "notify_id") @Default(-1) int notifyId,
    @Default("") String title,
    @Default("") String content,
    @JsonKey(name: "send_date") @Default("") String sendDate,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
