import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loginscreen/home_screen.dart';
import 'package:loginscreen/map_screen.dart';
import 'package:loginscreen/loginwithfacebook.dart';
import 'package:loginscreen/reset_pwd_scren.dart';
import 'package:loginscreen/signupscreen.dart';
import 'package:loginscreen/utilis.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'firebaseservices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController= TextEditingController();
  final pwdController=TextEditingController();
  FirebaseAuth _auth= FirebaseAuth.instance;
  bool _isVisible=true;




  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
      Utilis().toastMessage('Signed In With Google');
    }
    on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }





  @override
  void Dispose(){
    super.dispose();
    emailController.dispose();
    pwdController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:   SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 100,),
        
               const Padding(
                 padding: EdgeInsets.only(left: 28),
                 child: Text('Login To Your Account',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple,fontSize: 25),),
               ),
            
            const SizedBox(height: 50,),
            
            Form(
                child: Column(
                  children: [
        
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined,color: Colors.deepPurpleAccent,),
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (String value){
        
                        },
                        validator: (value){
                          return value!.isEmpty? 'Please enter email': null;
                        },
                      ),
                    ),
        
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: pwdController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isVisible,
                        obscuringCharacter: '*',
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.lock,color: Colors.deepPurpleAccent,),
                          suffixIcon: _isVisible==true?
                          InkWell(child: Icon(Icons.visibility_off,color: Colors.green,),
                            onTap: (){

                              setState(() {
                                _isVisible=false;
                              });
                            },
                          )
                              :
                          InkWell(child: Icon(Icons.visibility,color: Colors.red,),
                            onTap: (){

                              setState(() {
                                _isVisible=true;
                              });
                            },
                          ),
                          labelText: 'Password',
                          hintText: 'Enter Your Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (String value){
        
                        },
        
                      ),
                    ),
                    
                    const SizedBox(height: 5,),

                    InkWell(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 250.0),
                        child: Text('Forgot Password?',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,decoration: TextDecoration.underline),),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResetPasswordScreen()));
                      },
                    ),
                    
                    const SizedBox(height: 10,),

                   
                   ElevatedButton(
                       onPressed: (){

                         _auth.signInWithEmailAndPassword(
                             email: emailController.text.toString(),
                             password: pwdController.text.toString()).then((value){
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                               content: Text('Logged In Successfully!'),
                               backgroundColor: Colors.green,
                               showCloseIcon: true,
                               duration: Duration(seconds: 3),
                               behavior: SnackBarBehavior.floating,
                               dismissDirection: DismissDirection.horizontal,
                             ),
                           );
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context)=> const HomeScreen()));
                         }).onError((error, stackTrace){
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text(error.toString()),
                               backgroundColor: Colors.red,
                               showCloseIcon: true,
                               duration: const Duration(seconds: 3),
                               behavior: SnackBarBehavior.floating,
                               dismissDirection: DismissDirection.horizontal,
                             ),
                           );
                         });

                       },
                       child: Text('   LogIn   ')
                   ),

                    const SizedBox(height: 20,),


        
        
                    const SizedBox(height: 100,),
        
                     InkWell(
                       child: const Padding(
                         padding:  EdgeInsets.only(left: 200.0),
                         child: Text('Create Account',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,fontSize: 20),),
                       ),
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
                       },
                     ),


                      const SizedBox(height: 10,),


                     Padding(
                       padding: const EdgeInsets.only(left: 60,right: 60),
                       child: ElevatedButton(
                           onPressed: (){
                             signInWithFacebook();
                           },
                           child: const Row(
                             children: [
                               Icon(Icons.facebook),
                               Text(' Login With Facebook'),
                             ],
                           ),
                       ),
                     ),



                    Padding(
                      padding: const EdgeInsets.only(left: 60.0,right: 60),
                      child: ElevatedButton(
                          onPressed: (){
                             signInwithGoogle(context);
                          },
                          child: const Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/10/23/06/04/google-1762248_640.png'),
                                radius: 12,
                              ),
                              Text(' Login With Google'),
                            ],
                          ),
                      ),
                    ),



        
        
        
        
                  ],
                )
        
            ),
            
            
            
            
            
            
            
        
        
        
        
        
        
        
        
        
        
        
        
          ],
        ),
      ),
    );
  }
}
