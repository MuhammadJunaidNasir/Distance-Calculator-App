import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/loginscreen.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {


  final _emailController= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Your Password',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [


          const SizedBox(height: 250,),



          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: _emailController,
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

          const SizedBox(height: 50,),


         ElevatedButton(

             onPressed:(){
                   FirebaseAuth.instance.sendPasswordResetEmail(
                       email: _emailController.text.toString(),
                   ).then((value){
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         content: Text('Password Reset Link Has Been Sent Via Email'),
                         backgroundColor: Colors.green,
                         showCloseIcon: true,
                         duration: Duration(seconds: 3),
                         behavior: SnackBarBehavior.floating,
                         dismissDirection: DismissDirection.horizontal,
                       ),
                     );
                     
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                     
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
             child: Text('Send Link',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),

         )










        ],
      ),
    );
  }
}
