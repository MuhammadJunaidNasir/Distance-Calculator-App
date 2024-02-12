import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/home_screen.dart';
import 'package:loginscreen/utilis.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

   final pwdController= TextEditingController();
    FirebaseAuth _auth= FirebaseAuth.instance;
   User? currentUser;
    String email= '';
   bool _isVisible=true;

   final fireStore= FirebaseFirestore.instance.collection('Users');


    void initState(){
      super.initState();

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Your Password',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [


          SizedBox(height: 250,),

              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8),
                child: TextFormField(
                  controller: pwdController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isVisible,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
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
                    hintText: 'Enter Updated Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                ),
              ),


          SizedBox(height: 50,),



          ElevatedButton(

            onPressed:(){

              FirebaseAuth.instance.currentUser!.updatePassword(pwdController.text.toString()).then((value){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password Changed Successfully!'),
                    backgroundColor: Colors.green,
                    showCloseIcon: true,
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );

                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
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
            child: Text('Update',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),

          )




        ],
      ),
    );
  }
}
