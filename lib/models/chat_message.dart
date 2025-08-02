class ChatMessage {
  final String id;
  final String sender; // 'user' or 'gemini'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}
