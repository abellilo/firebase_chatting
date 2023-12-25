import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),),
    );
  }
}
