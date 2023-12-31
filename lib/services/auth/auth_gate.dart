import 'package:chat_with_firebase/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (cxt,snapshot){
          //user is logged in
          if(snapshot.hasData){
            return const HomePage();
          }
          //user is NOT logged in
          else{
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
