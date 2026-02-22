import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String roomId;
  final Map<String, bool> participants;
  final List<String> participantIds;
  final Map<String, ParticipantData> participantData;
  final LastMessage lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatRoomMetadata metadata;

  ChatRoom({
    required this.roomId,
    required this.participants,
    required this.participantIds,
    required this.participantData,
    required this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.metadata = const ChatRoomMetadata(),
  });

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      roomId: map['roomId'],
      participants: Map<String, bool>.from(map['participants']),
      participantIds: List<String>.from(map['participantIds']),
      participantData: Map<String, ParticipantData>.fromEntries(
        (map['participantData'] as Map).entries.map(
              (e) => MapEntry(e.key, ParticipantData.fromMap(e.value)),
            ),
      ),
      lastMessage: LastMessage.fromMap(map['lastMessage']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      metadata: map.containsKey('metadata')
          ? ChatRoomMetadata.fromMap(map['metadata'])
          : ChatRoomMetadata(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'participants': participants,
      'participantIds': participantIds,
      'participantData': participantData.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'lastMessage': lastMessage.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata.toMap(),
    };
  }
}

class ParticipantData {
  final String name;
  final String? profileImage;
  final String role;

  ParticipantData({
    required this.name,
    this.profileImage,
    required this.role,
  });

  factory ParticipantData.fromMap(Map<String, dynamic> map) {
    return ParticipantData(
      name: map['name'],
      profileImage: map['profileImage'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'role': role,
    };
  }
}

class LastMessage {
  final String text;
  final String senderId;
  final DateTime timestamp;
  final bool isRead;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.timestamp,
    this.isRead = false,
  });

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      text: map['text'],
      senderId: map['senderId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

class ChatRoomMetadata {
  final bool isGroup;
  final String? customName;

  const ChatRoomMetadata({
    this.isGroup = false,
    this.customName,
  });

  factory ChatRoomMetadata.fromMap(Map<String, dynamic> map) {
    return ChatRoomMetadata(
      isGroup: map['isGroup'] ?? false,
      customName: map['customName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isGroup': isGroup,
      'customName': customName,
    };
  }
}
