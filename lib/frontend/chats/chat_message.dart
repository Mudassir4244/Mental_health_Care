// class ChatMessage {
//   final String senderId;
//   final String message;
//   final int timestamp;

//   ChatMessage({
//     required this.senderId,
//     required this.message,
//     required this.timestamp,
//   });

//   Map<String, dynamic> toMap() {
//     return {"senderId": senderId, "message": message, "timestamp": timestamp};
//   }

//   factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
//     return ChatMessage(
//       senderId: map["senderId"] ?? "",
//       message: map["message"] ?? "",
//       timestamp: map["timestamp"] ?? 0,
//     );
//   }
// }
class ChatMessage {
  final String id; // message key in Realtime DB
  final String senderId;
  final String text;
  final int timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {"senderId": senderId, "text": text, "timestamp": timestamp};
  }

  factory ChatMessage.fromMap(String id, Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: id,
      senderId: map["senderId"]?.toString() ?? "",
      text: map["text"]?.toString() ?? "",
      timestamp: (map["timestamp"] is int)
          ? map["timestamp"] as int
          : (map["timestamp"] is double)
          ? (map["timestamp"] as double).toInt()
          : 0,
    );
  }
}
