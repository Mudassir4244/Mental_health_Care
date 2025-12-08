import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat {
  final String roomId;
  final String otherUserId;
  final LastMessagePreview lastMessage;
  final int unreadCount;
  final bool muted;
  final bool archived;
  final UserSnapshot userSnapshot;

  UserChat({
    required this.roomId,
    required this.otherUserId,
    required this.lastMessage,
    this.unreadCount = 0,
    this.muted = false,
    this.archived = false,
    required this.userSnapshot,
  });

  factory UserChat.fromMap(Map<String, dynamic> map) {
    return UserChat(
      roomId: map['roomId'],
      otherUserId: map['otherUserId'],
      lastMessage: LastMessagePreview.fromMap(map['lastMessage']),
      unreadCount: map['unreadCount'] ?? 0,
      muted: map['muted'] ?? false,
      archived: map['archived'] ?? false,
      userSnapshot: UserSnapshot.fromMap(map['userSnapshot']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'otherUserId': otherUserId,
      'lastMessage': lastMessage.toMap(),
      'unreadCount': unreadCount,
      'muted': muted,
      'archived': archived,
      'userSnapshot': userSnapshot.toMap(),
    };
  }
}

class LastMessagePreview {
  final String text;
  final DateTime timestamp;

  LastMessagePreview({
    required this.text,
    required this.timestamp,
  });

  factory LastMessagePreview.fromMap(Map<String, dynamic> map) {
    return LastMessagePreview(
      text: map['text'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class UserSnapshot {
  final String name;
  final String? profileImage;
  final String role;

  UserSnapshot({
    required this.name,
    this.profileImage,
    required this.role,
  });

  factory UserSnapshot.fromMap(Map<String, dynamic> map) {
    return UserSnapshot(
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
