import 'dart:convert';

class NotificationModel {
  String content;
  String createdAt;
  String fromUID;
  String toUID;
  String heading;
  bool isRead;
  NotificationModel({
    required this.content,
    required this.createdAt,
    required this.fromUID,
    required this.toUID,
    required this.heading,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': createdAt,
      'fromUID': fromUID,
      'toUID': toUID,
      'heading': heading,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? '',
      fromUID: map['fromUID'] ?? '',
      toUID: map['toUID'] ?? '',
      heading: map['heading'] ?? '',
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
