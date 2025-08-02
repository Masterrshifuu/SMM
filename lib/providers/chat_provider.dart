import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:smm/models/chat_message.dart';
import 'package:smm/services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> sendMessage(String messageText) async {
    final String userId = const Uuid().v4();
    final userMessage = ChatMessage(
      id: userId,
      sender: 'user',
      content: messageText,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    try {
      final geminiService = GeminiService();
      final response = await geminiService.generateResponse(messageText);
      final String geminiId = const Uuid().v4();
      final aiMessage = ChatMessage(
        id: geminiId,
        sender: 'gemini',
        content: response,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMessage);
      notifyListeners();
    } catch (e) {
      final String errorId = const Uuid().v4();
      final errorMessage = ChatMessage(
        id: errorId,
        sender: 'gemini',
        content: 'Error: ${e.toString()}',
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
      notifyListeners();
    }
  }
}
