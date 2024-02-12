import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:loginscreen/Map_For_Visited_Location_Screen.dart';
import 'package:loginscreen/utilis.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {


  List<LatLng> locations = [];

  @override
  void initState() {
    super.initState();
    // Retrieve locations from Firestore
    retrieveLocations();
  }


  Future<void> retrieveLocations() async {
    try {

      // Retrieve data from Firestore
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).get();

      // Parse the retrieved data into a list of LatLng objects
      List<dynamic> locationsData = documentSnapshot.data()?['locations'] ?? [];
      List<LatLng> parsedLocations = locationsData
          .map((location) => LatLng(location['latitude'], location['longitude']))
          .toList();

      // Update the state with the retrieved locations
      setState(() {
        locations = parsedLocations;
      });


    }
    catch (error) {

    }
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Location History',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Location ${index+1}',style: const TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
            subtitle: Text('Latitude: ${locations[index].latitude}, Longitude: ${locations[index].longitude}'),
            leading: const Icon(Icons.location_on_outlined,color: Colors.deepPurple,),
            trailing: InkWell(child: const Icon(Icons.visibility,color: Colors.deepPurple,),
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> MapForVisitedLocationScreen(latitude: locations[index].latitude, longitude: locations[index].longitude,)));},
            ),

          );
        },
      ),
    );
  }
}
