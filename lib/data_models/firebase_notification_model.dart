class FirebaseNotificationModel {
  final String title;
  final String body;
  final int? ticketId;
  final int? notificationId;

  FirebaseNotificationModel({
    required this.title,
    required this.body,
    this.ticketId,
    this.notificationId,
  });

  factory FirebaseNotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json.isEmpty) throw ArgumentError("JSON cannot be empty");

      var data = json['data'] as Map<String, dynamic>?;
      return FirebaseNotificationModel(
        title: json['notification']?['title'] ?? '',
        body: json['notification']?['body'] ?? '',
        ticketId: data != null && data.containsKey('id') ? int.tryParse(data['id'].toString()) : null,
        notificationId:
            data != null && data.containsKey('notificationId') ? int.tryParse(data['notificationId'].toString()) : null,
      );
    } catch (ex) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'notification': {'title': title, 'body': body},
      'data': {
        'id': ticketId?.toString(),
        'notificationId': notificationId?.toString(),
      }
    };
  }
}
