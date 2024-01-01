import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color containerColor;
  final Color textColor;

  ChatBubble(
      {Key? key,
      required this.message,
      required this.containerColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: containerColor,
      ),
      child: Text(
        message,
        style: TextStyle(color: textColor, fontSize: 15),
      ),
    );
  }
}
