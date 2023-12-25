import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderEmail;
  final String senderId;
  final receiverId;
  final String message;
  final Timestamp timestamp;

  Message({required this.senderEmail, required this.senderId,
  required this.receiverId, required this.message, required this.timestamp});

  //convert to map
  Map<String, dynamic> toMap(){
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp
    };
  }
}