import 'package:chat_with_firebase/main.dart';
import 'package:chat_with_firebase/pages/settings_page.dart';
import 'package:chat_with_firebase/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int mainPage = 0;

  //get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //sign user out
  void signOut() async{
    try{
      setState(() {
        mainPage = 1;
      });
      //get the auth service
      final authservice = Provider.of<AuthService>(context,listen: false);
      await authservice.signOut();
      setState(() {
        mainPage = 0;
      });
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code))
      );
      setState(() {
        mainPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainPage == 0?
    Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: Column(
                children: [

                  //logo
                  Image.asset(
                    "lib/assets/astral_chat.png",
                    width: 70,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //divider
                  Divider(
                    thickness: 2,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //home
                  GestureDetector(
                    onTap: ()=> Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.home,),
                        const SizedBox(width: 20,),
                        Text("H O M E",style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //setting
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage()));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.settings,),
                        const SizedBox(width: 20,),
                        Text("S E T T I N G S",style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                  ),

                  Spacer(),

                  //LOGOUT
                  GestureDetector(
                    onTap: signOut,
                    child: Row(
                      children: [
                        Icon(Icons.logout,),
                        const SizedBox(width: 20,),
                        Text("L O G O U T",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("C O N T A C T S"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: _buildUserList(),
    )
    :Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.deepPurple.shade800,
          size: 100,
        ),
      ),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (cxt,snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: SpinKitWanderingCubes(
            color: Colors.deepPurple.shade800,
            size: 100,
          ),);
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  //build individual list item
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //display all user except for current user
    if(_firebaseAuth.currentUser!.email != data['email']){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(data['email']),
            onTap: (){
              //when clicked pass user UID to chat page
              Navigator.push(context, MaterialPageRoute(builder: (cxt)=>ChatPage(
                receviedUserEmail: data['email'],
                receivedUserID: data['uid'],
              )));
            },
          ),
        ),
      );
    }
    else{
      //return a blank container
      return Container();
    }
  }
}
