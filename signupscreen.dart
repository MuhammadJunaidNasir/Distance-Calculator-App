import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginscreen/loginscreen.dart';
import 'utilis.dart';
    
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController= TextEditingController();
  final pwdController=TextEditingController();
  FirebaseAuth _auth= FirebaseAuth.instance;

  final fireStore= FirebaseFirestore.instance.collection('Users');
  bool _isVisible=true;



  @override
  void Dispose(){
    super.dispose();
    emailController.dispose();
    pwdController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            const SizedBox(height: 100,),
        
            const Padding(
              padding: EdgeInsets.only(left: 28),
              child: Text('Create Your Account',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple,fontSize: 25),),
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
                      padding:  EdgeInsets.all(12.0),
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

                      ),
                    ),


        
                    const SizedBox(height: 50,),
        
                    ElevatedButton(
                        onPressed: (){
                          _auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: pwdController.text.toString()).then((value){

                            fireStore.doc(emailController.text.toString()).set({
                              'email': emailController.text.toString(),
                              'contact': '',
                              'age': '',
                              'name':'',
                              'rangelimit': '',
                              'imgURL': '',
                              'locations': '',
                            }).then((value){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Account Created Successfully!'),
                                  backgroundColor: Colors.green,
                                  showCloseIcon: true,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.horizontal,
                                ),
                              );
                              emailController.dispose();
                              pwdController.dispose();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
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





                          }).onError((error, stackTrace){

                          });
                        },
                        child: Text('   Sign Up   ')
                    ),
        
                    const SizedBox(height: 100,),
        
                    InkWell(
                      child: const Padding(
                        padding:  EdgeInsets.only(left: 200.0),
                        child: Text('Login Account',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,fontSize: 20),),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                      },
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
    