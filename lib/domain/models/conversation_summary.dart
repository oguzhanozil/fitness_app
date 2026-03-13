import 'package:equatable/equatable.dart';

class ConversationSummary extends Equatable {
  final String id;
  final String coachId;
  final String coachName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int messageCount;

  const ConversationSummary({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.messageCount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'coachId': coachId,
        'coachName': coachName,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt.millisecondsSinceEpoch,
        'messageCount': messageCount,
      };

  factory ConversationSummary.fromJson(Map<String, dynamic> json) => ConversationSummary(
        id: json['id'] as String,
        coachId: json['coachId'] as String,
        coachName: json['coachName'] as String,
        lastMessage: json['lastMessage'] as String,
        lastMessageAt:
            DateTime.fromMillisecondsSinceEpoch(json['lastMessageAt'] as int),
        messageCount: json['messageCount'] as int,
      );

  @override
  List<Object?> get props => [id, coachId, coachName, lastMessage, lastMessageAt, messageCount];
}
