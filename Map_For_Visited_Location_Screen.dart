

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:latlng/latlng.dart';


class MapForVisitedLocationScreen extends StatefulWidget {

  final double latitude;
  final double longitude;

   const MapForVisitedLocationScreen({super.key,  required this.latitude, required this.longitude});





  @override
  State<MapForVisitedLocationScreen> createState() => _MapForVisitedLocationScreenState();
}

class _MapForVisitedLocationScreenState extends State<MapForVisitedLocationScreen> {



  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    LatLng initialLocation = LatLng(widget.latitude, widget.longitude);
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Places You Have Visited',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body:  GoogleMap(
        initialCameraPosition: CameraPosition(
            target: initialLocation,
            zoom: 15,
        ),
        mapType: MapType.hybrid,
        //markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: {

          Marker(
            markerId: const MarkerId('Visited Location'),
            position: initialLocation,   
            visible: true,
            infoWindow:   const InfoWindow(
                title: 'Visited Location',
                snippet: 'This place has been visited',
                anchor:  Offset(0.5, 0.0),

            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),


          ),

        },




      ),
    );
  }
}
