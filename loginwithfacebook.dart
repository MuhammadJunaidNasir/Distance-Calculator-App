import 'package:flutter/material.dart';
import 'package:loginscreen/firebaseservices.dart';
class FacebookLogin extends StatefulWidget {
  const FacebookLogin({super.key});

  @override
  State<FacebookLogin> createState() => _FacebookLoginState();
}

class _FacebookLoginState extends State<FacebookLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Facebook',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.only(left:100.0,top: 10),
            child: InkWell(
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 5,),
                    Icon(Icons.login),
                    SizedBox(width: 10,),
                    Text('Login With Facebook',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)
                  ],
                ),
              ),
              onTap: (){
                      signInWithFacebook();
              },
            ),
          ),

        ],
      ),
    );
  }
}
