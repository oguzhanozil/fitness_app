import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/local_storage_service.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/conversation_summary.dart';

class SharedPreferencesLocalStorageService implements LocalStorageService {
  static const String _conversationKey = 'conversation_summaries';
  static const String _messageKeyPrefix = 'conversation_messages_';

  SharedPreferences? _preferences;

  @override
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> clearMessages(String conversationId) async {
    await _prefs.remove(_messagesKey(conversationId));
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final summaries = await getConversationSummaries();
    summaries.removeWhere((summary) => summary.id == conversationId);
    await _prefs.setStringList(
      _conversationKey,
      summaries.map((summary) => jsonEncode(summary.toJson())).toList(growable: false),
    );
  }

  @override
  Future<List<ConversationSummary>> getConversationSummaries() async {
    final rawItems = _prefs.getStringList(_conversationKey) ?? <String>[];
    return rawItems
        .map((item) => ConversationSummary.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList(growable: true);
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final rawItems = _prefs.getStringList(_messagesKey(conversationId)) ?? <String>[];
    return rawItems
        .map((item) => ChatMessage.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList(growable: true);
  }

  @override
  Future<void> saveConversationSummary(ConversationSummary summary) async {
    final summaries = await getConversationSummaries();
    final index = summaries.indexWhere((item) => item.id == summary.id);

    if (index == -1) {
      summaries.add(summary);
    } else {
      summaries[index] = summary;
    }

    await _prefs.setStringList(
      _conversationKey,
      summaries.map((item) => jsonEncode(item.toJson())).toList(growable: false),
    );
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    final messages = await getMessages(message.conversationId);
    messages.add(message);
    await _prefs.setStringList(
      _messagesKey(message.conversationId),
      messages.map((item) => jsonEncode(item.toJson())).toList(growable: false),
    );
  }

  SharedPreferences get _prefs {
    final preferences = _preferences;
    if (preferences == null) {
      throw StateError('Local storage not initialized. Call init() first.');
    }
    return preferences;
  }

  String _messagesKey(String conversationId) => '$_messageKeyPrefix$conversationId';
}
