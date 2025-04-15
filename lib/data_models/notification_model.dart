import 'package:intl/intl.dart';

class NotificationModel {
  final int? id;
  final String? title;
  final String? content;
  final int? ticketId;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  bool isRead;
  bool isDeleted;

  String? get dateCreatedString {
    return dateCreated == null ? null : DateFormat("d.M.y H:mm").format(dateCreated!);
  }

  NotificationModel(
      {this.id,
      this.title,
      this.content,
      this.ticketId,
      this.dateCreated,
      this.dateUpdated,
      this.isRead = false,
      this.isDeleted = false});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      ticketId: json['ticketId'] as int,
      dateCreated: DateTime.parse(json["dateCreated"]["date"]),
      dateUpdated: DateTime.parse(json["dateUpdated"]["date"]),
    );
  }
}
