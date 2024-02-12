import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/MyProfile_Screen.dart';
import 'package:loginscreen/change_password_screen.dart';
import 'package:loginscreen/edit_profile_screen.dart';
import 'package:loginscreen/location_history_screen.dart';
import 'package:loginscreen/loginscreen.dart';
import 'package:loginscreen/map_screen.dart';
import 'package:loginscreen/set_range_screen.dart';
import 'package:loginscreen/utilis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore= FirebaseFirestore.instance.collection('Users');

  Future<void> _deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      //Utilis().toastMessage('Your account has been deleted successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account has been deleted successfully!'),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>  LoginScreen()));

    }
    catch (e) {
      Utilis().toastMessage(e.toString());
    }

  }


  String? _name;
  String? _email;
  String? _profileimgURL;

  @override
  void initState(){
    super.initState();
    _getUserData();
  }

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();

    setState(() {
      _name= _userData.get('name').toString();
      _email= _userData.get('email').toString();
      _profileimgURL= _userData.get('imgURL').toString();
    });

  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen',style: TextStyle(color: Colors.white),),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            actions: [

              InkWell(
                child: const Icon(Icons.location_on_outlined,color: Colors.white,),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> MapScreen()));
                },
              ),
              const SizedBox(width: 10,),
            ],
          ),
      drawer: Drawer(
        child: ListView(
          children:    [
            UserAccountsDrawerHeader(
             currentAccountPicture:  CircleAvatar(
               backgroundImage: NetworkImage('$_profileimgURL'),
             ),
               accountName: Text('$_name'),
               accountEmail: Text('$_email'),
           ),

             ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
               onTap:(){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyProfileScreen()));
               },
            ),


              ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
              },
            ),

             ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Set Range Limit'),
              onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SetRangeScreen()));


              },
            ),

              ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Location History'),
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LocationHistoryScreen()));
                    },
                  ),

             ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()));
              },
            ),

             ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
               onTap: (){
                   showDialog(
                       context: context,
                       builder: (BuildContext context){
                         return AlertDialog(
                           title: const Text('Confirmation !'),
                           content: const Text('Are you sure you want to delete your account?'),
                           actions: [
                             TextButton(
                                 onPressed: (){
                                      _deleteAccount();
                                      Navigator.pop(context);
                                 },
                                 child: const Text('DELETE'),
                             ),

                             TextButton(
                               onPressed: (){
                                 Navigator.pop(context);
                               },
                               child: const Text('NO'),
                             ),

                           ],
                         );
                       }
                   );
               },
            ),

             ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: (){
                _auth.signOut();
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> LoginScreen()));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account Logged out successfully!'),
                    backgroundColor: Colors.green,
                    showCloseIcon: true,
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                  ),
                );
              },
            ),

          ],
        ),

      ),




    );
  }
}
