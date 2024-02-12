import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/utilis.dart';

import 'home_screen.dart';
class SetRangeScreen extends StatefulWidget {
  const SetRangeScreen({super.key});

  @override
  State<SetRangeScreen> createState() => _SetRangeScreenState();
}

class _SetRangeScreenState extends State<SetRangeScreen> {


  final rangeController= TextEditingController();
  final FirebaseAuth _auth= FirebaseAuth.instance;



  String? _currentrange;

  @override
  void initState(){
    super.initState();
    _getUserData();
  }

   Future <void> _getUserData()async{

     final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();
     setState(() {
       _currentrange= _userData.get('rangelimit').toString();
     });


   }













  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Distance Range (KM) ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [

          const SizedBox(height: 200,),

          Text('Your Current Range:  $_currentrange KM',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontSize: 18),),

          const SizedBox(height: 50,),



          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: TextFormField(
              controller: rangeController,
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.directions,color: Colors.green,),
                  labelText: 'Distance Range (kM)',
                  hintText: 'Enter Your Distance Range (KM)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )
              ),
            ),
          ),


          SizedBox(height: 50,),




          ElevatedButton(

            onPressed:(){

              FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).update({
                'rangelimit': rangeController.text.toString(),
              }).then((value){


                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Range Set To ${rangeController.text.toString()} KM'),
                    backgroundColor: Colors.green,
                    showCloseIcon: true,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );


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

              setState(() {
                _getUserData();
              });

            },
            child: Text('SAVE',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),

          )





        ],
      ),
    );
  }
}
