import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.blue),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16,color: Colors.white),
      ),
    );
  }
}
