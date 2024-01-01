import 'package:chat_with_firebase/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  //sign up user
  void signUp() async{
    //check if confirm passwordand password are the same
    if(passwordController.text != confirmpasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match"))
      );
      return;
    }
    else{
      //get the auth service
      final authService = Provider.of<AuthService>(context,listen: false);

      try{
        //sign up with email and password
        await authService.signUpWithEmailandPassword(
            emailController.text, passwordController.text
        );
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //logo
                Image.asset(
                  "lib/assets/astral_chat.png",
                  width: 100,
                ),

                const SizedBox(
                  height: 50,
                ),

                //create account message
                const Text("Let's create an account for you",
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

                //confirm password textfield
                MyTextField(
                    controller: confirmpasswordController,
                    hintText: "Confirm Password",
                    obscureText: true
                ),

                const SizedBox(
                  height: 25,
                ),

                //sign in button
                MyButton(onTap: signUp, text: "Sign Up"),

                const SizedBox(
                  height: 50,
                ),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login now",style: TextStyle(
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
    );
  }
}
