import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final receiveUserEmail;
  final receiveUserUD;

  const ChatPage(
      {super.key, required this.receiveUserEmail, required this.receiveUserUD});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserEmail),
      ),
    );
  }
}
