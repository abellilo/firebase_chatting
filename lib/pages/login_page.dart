import 'package:chat_with_firebase/components/my_button.dart';
import 'package:chat_with_firebase/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int mainPage = 0;
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign In user
  void signIn() async{
    setState(() {
      mainPage = 1;
    });
    //get the auth service
    final authservice = Provider.of<AuthService>(context,listen: false);
    try{
      await authservice.signInWithEmailandPassword(emailController.text, passwordController.text);
      setState(() {
        mainPage = 0;
      });
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
      setState(() {
        mainPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainPage == 0 ?
    Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //logo
                  Image.asset(
                    "lib/assets/chat_logo.png",
                    width: 100,
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  //welcome back message
                 const Text("Welcome back you've been missed",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),

                  const SizedBox(
                    height: 25,
                  ),

                  //email textfield
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //password textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot Password?",style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //sign in button
                  MyButton(onTap: signIn, text: "Sign In"),

                  const SizedBox(
                    height: 50,
                  ),

                  //not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Register now",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800]
                        ),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    )
    :Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.deepPurple.shade800,
          size: 100,
        ),
      ),
    );
  }
}
