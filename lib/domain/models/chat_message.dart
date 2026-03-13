import 'package:equatable/equatable.dart';

enum MessageRole { user, model }

class ChatMessage extends Equatable {
  final String id;
  final String conversationId;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'content': content,
        'role': role.name,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        content: json['content'] as String,
        role: MessageRole.values.byName(json['role'] as String),
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      );

  @override
  List<Object?> get props => [id, conversationId, content, role, timestamp];
}
