import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginscreen/utilis.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {


     final _emailController= TextEditingController();
     final _phonenoController= TextEditingController();
     final _ageController= TextEditingController();
     final _nameController= TextEditingController();

     File? _imageFile;
     String? _imageUrl;

     final picker = ImagePicker();

     // Function to select an image from the gallery
     Future<void> getImageFromGallery() async {

       final pickedFile = await picker.pickImage(source: ImageSource.gallery);

       setState(() {
         if (pickedFile != null) {
           _imageFile = File(pickedFile.path);
         } else {
           print('No image selected.');
         }
       });
     }

     // Function to upload image to Firebase Storage
     Future<String> uploadImageToFirebase() async {

       try {
         // Upload image to Firebase Storage
         Reference storageReference = FirebaseStorage.instance
             .ref()
             .child('images/${DateTime.now().millisecondsSinceEpoch}');
         UploadTask uploadTask = storageReference.putFile(_imageFile!);
         await uploadTask.whenComplete(() {});

         // Get download URL
         String downloadUrl = await storageReference.getDownloadURL();
         return downloadUrl;
       }
       catch (e) {
         print('Error uploading image: $e');
         return 'emptylink';
       }
     }

     // Function to upload image URL to Firestore
     Future<void> uploadImageUrlToFirestore(String imageUrl) async {
       try {
         await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).update({
           'imgURL': imageUrl,
         });

         setState(() {
           _imageUrl = imageUrl;
         });

         print('Image URL uploaded successfully.');
       } catch (e) {
         print('Error uploading image URL: $e');
       }
     }






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
        title: const Text('Edit Your Profile',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:   Center(
        child: SingleChildScrollView(
          child: Column(
          
            children: [
          

          
                       Stack(
                         children: [
                            CircleAvatar(
                             backgroundColor: Colors.deepOrange,
                             backgroundImage: NetworkImage('$_profileimgURL'),
                             radius: 50,
          
                           ),
          
                           Positioned(
                               bottom: -15,
                               left: 55,
          
                               child: IconButton(
                                 color: Colors.deepPurple,
                                 iconSize: 25,
                                 onPressed:()async{

                                     getImageFromGallery().then((value) async {
                                       String imageUrl = await uploadImageToFirebase();

                                       uploadImageUrlToFirestore(imageUrl);
                                       setState(() {
                                         _getUserData();
                                         Utilis().toastMessage('Profile Picture Updated!');
                                       });

                                     });




                                 },
                                 icon: const Icon(Icons.camera_alt),
                               )
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
                  trailing: InkWell(child: Icon(Icons.edit),
                  onTap:(){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Edit Your Name !'),
                            content: TextField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed:(){

                                    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).update({
                                      'name': _nameController.text.toString(),
                                    }).then((value){
                                      setState(() {
                                        _getUserData();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Name Has Been Updated Successfully!'),
                                          backgroundColor: Colors.green,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          backgroundColor: Colors.red,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    });


                                  },
                                  child: const Text('UPDATE')
                              )


                            ],
                          );
                        }
                    );
                  },
                  ),
                ),
          
          
               ListTile(
                leading: Icon(Icons.email),
                title: Text('Email',style: TextStyle(fontWeight: FontWeight.bold,),),
                subtitle: Text('${FirebaseAuth.instance.currentUser!.email}'),
                trailing: InkWell(
                    child: Icon(Icons.edit),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Edit Your Email !'),
                            content: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your New Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed:(){

                                    FirebaseAuth.instance.currentUser!.updateEmail(_emailController.text.toString()).then((value){
                                      setState(() {
                                        _getUserData();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Email Has Been Updated Successfully!'),
                                          backgroundColor: Colors.green,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                          content: Text(error.toString()),
                                          backgroundColor: Colors.red,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);

                                    });
          
                                  },
                                  child: const Text('UPDATE')
                              )
          
          
                            ],
                          );
                        }
                    );
                  },
                ),
              ),
          
          
              const SizedBox(height: 10,),
          
               ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact No',style: TextStyle(fontWeight: FontWeight.bold,),),
                subtitle: Text('$_phoneNo'),
                trailing: InkWell(child: Icon(Icons.edit),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Edit Your Contact No !'),
                            content: TextField(
                              controller: _phonenoController,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your Phone No',
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed:(){

                                    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).update({
                                     'contact': _phonenoController.text.toString(),
                                    }).then((value){
                                      setState(() {
                                        _getUserData();
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Phone No. Has Been Updated Successfully!'),
                                          backgroundColor: Colors.green,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          backgroundColor: Colors.red,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    });

                                  },
                                  child: const Text('UPDATE')
                              )


                            ],
                          );
                        }
                    );
                  },
                ),
              ),


              const SizedBox(height: 10,),
          
               ListTile(
                leading: Icon(Icons.accessibility),
                title: Text('Age',style: TextStyle(fontWeight: FontWeight.bold,),),
                subtitle: Text('$_age'),
                trailing: InkWell(child: Icon(Icons.edit),
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text('Update Your Age !'),
                            content: TextField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'Enter Your Updated Age',
                                prefixIcon: Icon(Icons.accessibility),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed:(){

                                    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).update({
                                      'age': _ageController.text.toString(),
                                    }).then((value){
                                      setState(() {
                                        _getUserData();
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Age Has Been Updated Successfully!'),
                                          backgroundColor: Colors.green,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          backgroundColor: Colors.red,
                                          showCloseIcon: true,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    });

                                  },
                                  child: const Text('UPDATE')
                              )


                            ],
                          );
                        }
                    );
                  },
                ),
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
      ),
    );
  }
}
