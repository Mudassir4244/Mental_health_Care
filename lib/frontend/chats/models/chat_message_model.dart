import 'package:cloud_firestore/cloud_firestore.dart';

// Add this helper method at the top level of the file (not inside any class)
MessageType _parseMessageType(dynamic type) {
  if (type is MessageType) return type;
  if (type is String) {
    return MessageType.values.firstWhere(
      (e) => e.name == type.toLowerCase(),
      orElse: () => MessageType.text,
    );
  }
  return MessageType.text;
}

MessageStatus _parseMessageStatus(dynamic status) {
  if (status is MessageStatus) return status;
  if (status is String) {
    return MessageStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => MessageStatus.sent,
    );
  }
  return MessageStatus.sent;
}

class ChatMessage {
  final String messageId;
  final String roomId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageReply? replyTo;
  final List<String> deletedFor;

  ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.replyTo,
    this.deletedFor = const [],
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] ?? '', // Add null check
      roomId: map['roomId'] ?? '', // Add null check
      senderId: map['senderId'] ?? '', // Add null check
      content: map['content'] ?? '', // Add null check
      type: _parseMessageType(map['type']), // Use helper
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ??
          DateTime.now(), // Add null check
      status: _parseMessageStatus(map['status']), // Use helper
      replyTo:
          map['replyTo'] != null ? MessageReply.fromMap(map['replyTo']) : null,
      deletedFor: List<String>.from(map['deletedFor'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
      'replyTo': replyTo?.toMap(),
      'deletedFor': deletedFor,
    };
  }
}

class MessageReply {
  final String messageId;
  final String senderId;
  final String preview;

  MessageReply({
    required this.messageId,
    required this.senderId,
    required this.preview,
  });

  factory MessageReply.fromMap(Map<String, dynamic> map) {
    return MessageReply(
      messageId: map['messageId'],
      senderId: map['senderId'],
      preview: map['preview'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'preview': preview,
    };
  }
}

enum MessageType {
  text,
  image,
  video,
  file,
  audio,
}

enum MessageStatus {
  sent,
  delivered,
  read,
}
