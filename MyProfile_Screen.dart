import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {


  String? _name;
  String? _email;
  String? _phoneNo;
  String? _age;
  String? _range;
  String? _profileimgURL;



  @override
  void initState(){
    super.initState();
    _getUserData();
  }

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).get();
    setState(() {
      _name= _userData.get('name').toString();
      _email= _userData.get('email').toString();
      _phoneNo= _userData.get('contact').toString();
      _age= _userData.get('age').toString();
      _range= _userData.get('rangelimit').toString();
      _profileimgURL= _userData.get('imgURL').toString();
    });


  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(' My Profile',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:    Center(
        child: Column(

          children: [

            const SizedBox(height: 50,),

            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  backgroundImage: NetworkImage('$_profileimgURL'),
                  radius: 50,

                ),


              ],
            ),


            const SizedBox(height: 10,),

            Text('$_name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

            const SizedBox(height: 10,),

            const Divider(
              color: Colors.black, // Change color as needed
              thickness: 1, // Change thickness as needed
              height: 20, // Change height as needed
            ),

            const SizedBox(height: 10,),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name',style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle:  Text('$_name'),

            ),


            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email',style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text('${FirebaseAuth.instance.currentUser!.email}'),

            ),


            const SizedBox(height: 10,),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact No',style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text('$_phoneNo'),

            ),


            const SizedBox(height: 10,),

            ListTile(
              leading: Icon(Icons.accessibility),
              title: Text('Age',style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text('$_age'),
            ),
            const SizedBox(height: 10,),

            ListTile(
              leading: Icon(Icons.directions),
              title: Text('Range Limit',style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text('$_range KM'),
            ),
            const SizedBox(height: 10,),





          ],
        ),
      ),
    );
  }
}
