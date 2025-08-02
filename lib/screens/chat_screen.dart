import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smm/providers/chat_provider.dart';
import 'package:smm/widgets/chat_message_bubble.dart';
import 'package:smm/widgets/chat_input.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final msg = chatProvider.messages[index];
                return ChatMessageBubble(message: msg);
              },
            ),
          ),
          ChatInput(
            onSend: (msg) => chatProvider.sendMessage(msg),
          ),
        ],
      ),
    );
  }
}
