import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muloqot_smart_kids/components/chat_bubble.dart';
import 'package:muloqot_smart_kids/components/my_text_field.dart';
import 'package:muloqot_smart_kids/services/chat/chat_sevice.dart';

class ChatPage extends StatefulWidget {
  final receiveUserEmail;
  final receiveUserID;

  const ChatPage(
      {super.key, required this.receiveUserEmail, required this.receiveUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServce _chatServce = ChatServce();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatServce.sendMessage(
          widget.receiveUserID, _messageController.text);
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveUserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(child: _buildMessageList()),
          //user input
          _builMessageInput()
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServce.getMessage(
          widget.receiveUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList());
      },
    );
  }

//build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //align the message th the right if the sender is current user,otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 8,
            ),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

//build message input
  Widget _builMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          //textfild
          Expanded(
              child: MytextField(
                  controller: _messageController,
                  hintText: "Enter message",
                  obscureText: false)),
          // send Button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                size: 40,
              ))
        ],
      ),
    );
  }
}
