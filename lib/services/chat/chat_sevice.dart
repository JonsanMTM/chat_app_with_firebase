import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:muloqot_smart_kids/model/message.dart';

class ChatServce extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// SEND MESSAGE
  Future<void> sendMessage(String reseiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        reseiverId: reseiverId,
        message: message,
        timestamp: timestamp);

    //construct chat room id from current user id and receive id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, reseiverId];
    ids.sort();
    String chatRoomId = ids.join(
        "_"); //combine the ids into a single string to use as a chatRoomID
    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

//GET MESSAGE
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    // constructor chat room id from user ids (sorted to ensure it matches the id used when sending message)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
