import 'package:chat_with_firebase/components/chat_bubble.dart';
import 'package:chat_with_firebase/components/my_textfield.dart';
import 'package:chat_with_firebase/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receviedUserEmail;
  final String receivedUserID;

  ChatPage(
      {Key? key, required this.receivedUserID, required this.receviedUserEmail})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  //creat instance of chat service
  final _chatService = ChatService();

  //create instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //send message
  void sendMessage() async {
    //ony send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receivedUserID, _messageController.text);
      //clear controller after sending a messgae
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(widget.receviedUserEmail,style: TextStyle(
          fontSize: 17
        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,),
        ),
      ),
      body: Column(
        children: [
          //message
          Expanded(child: _buildMessageList()),

          //user input
          _buildMessageInput(),

          const SizedBox(height: 10,)
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessage(
            widget.receivedUserID, _firebaseAuth.currentUser!.uid),
        builder: (cxt, snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading");
          }

          return ListView(
            children:
                snapshot.data!.docs.map((e) => _buildMessageItem(e)).toList(),
          );
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot documents) {
    Map<String, dynamic> data = documents.data() as Map<String, dynamic>;

    //align the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    //color for container  chat bubble
    var containerColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.green
        : Colors.white;

    //color for text  chat bubble
    var textColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.white
        : Colors.black;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ?CrossAxisAlignment.end
          :CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ?MainAxisAlignment.end
              :MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
              message: data['message'],
              containerColor: containerColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //textfield
          Expanded(
              child: MyMessageTextField(
            controller: _messageController,
            obscureText: false,
            hintText: "Enter message",
          )),

          const SizedBox(width: 5,),

          //send button
          GestureDetector(
            onTap: sendMessage,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.arrow_upward,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }
}
