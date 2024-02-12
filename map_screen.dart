import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loginscreen/loginscreen.dart';
import 'utilis.dart';
import 'package:http/http.dart' as http;
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {



  FirebaseAuth _auth= FirebaseAuth.instance;



  final Completer<GoogleMapController> _controller= Completer();

  final distanceController= TextEditingController();






  final List<Marker> _marker=  <Marker>[
     const Marker(
        markerId: MarkerId('1'),
        position: LatLng(30.160760393105754, 72.66946287157693),
        infoWindow: InfoWindow(
          title:  'User Current Location Location',
        ),
    ),

    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(30.15151602533566, 72.66447933268533),
      infoWindow: InfoWindow(
        title:  'Given Location',
      ),
    ),

  ];




  Future<Position> getUserCurrentLocation()async{
    await Geolocator.requestPermission().then((value){

        Utilis().toastMessage('Location Access Granted');

    }).onError((error, stackTrace){
      Utilis().toastMessage(error.toString());
    });


    return await Geolocator.getCurrentPosition();
  }

  int? distance=0;
  double lati=0.0;
  double lngi=0.0;



  Future calculateDistance()async{
    Position currentPosition= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    distance= await Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, lati, lngi).toInt();





    if((distance!/1000)>range!){

      sendNotification();
      sendEmail();
      //sendMessage();
    }

    setState(() {
      destination= LatLng(lati, lngi);
      drawPolyline();
    });


    return (await distance)!/1000;
  }

   sendNotification(){
    int? limit=range;
    String? d= (distance!/1000)?.toDouble().toString();
     AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 10,
              channelKey: 'basic channel',
              title: 'Range Alert Notification',
              body: 'You Are Out of Range! (Max Limit: $limit Km). You are $d Km away from Pinned Location',
              color: Colors.deepPurpleAccent,
        )
    );
     setState(() {

     });
  }




  @override
  void initState(){


     AwesomeNotifications().isNotificationAllowed().then((isAllowed){
       if(!isAllowed){
         AwesomeNotifications().requestPermissionToSendNotifications();
       }
     });

     _getUserLocation();
     _getUserData();
     super.initState();


  }

   LatLng center = LatLng(30.151370385224233, 72.6648489091523);
   //double _radius=1000;

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        center = LatLng(position.latitude, position.longitude);
        source= center;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  LatLng source = LatLng(30.151370385224233, 72.6648489091523);
  LatLng destination = LatLng(30.149654080953095, 72.66152297007996);



    Set<Polyline> _polyline={};

    void drawPolyline(){
      _polyline.clear();
      _polyline.add(
        Polyline(
            polylineId: PolylineId('5'),
            points: [source,destination],
            width: 2,
            color: Colors.deepPurple,
            visible: true,
        )
      );
    }


  void sendEmail(){
    var
        Service_id='service_8j9i8nr',
        Template_id='template_m5p6ygf',
        User_id='Sc9ADOdpBGO_j10zM';
    var s=http.post(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'origin':'http:localhost',
          'Content-Type':'application/json'
        },
        body: jsonEncode({
          'service_id':Service_id,
          'user_id':User_id,
          'template_id':Template_id,
          'template_params':{
             'subject': 'Range Alert Notification',
             'message': 'You are out of range. Max limit is ${distanceController.text} KM. you are ${distance!/1000} KM away from Pinned Location.',
             'receiver_email': 'mjn7439@gmail.com',
             'receiver_name': 'Junaid',
             'from_name': 'Flutter Team',
          }
        })
    );

  }

  String phoneNumber = '+92 317-069-1864';


  sendMessage()async{
      await Telephony.backgroundInstance.sendSms(
          to: phoneNumber,
          message: 'You are out of range. Max limit is ${distanceController.text} KM. you are ${distance!/1000} KM away from Pinned Location.',
      );
  }

  String? _currentrange;
  int? range;

  double radius=1.0;

  Future <void> _getUserData()async{

    final DocumentSnapshot _userData= await FirebaseFirestore.instance.collection('Users').doc(_auth.currentUser!.email).get();
    setState(() {
      _currentrange= _userData.get('rangelimit').toString();
      range= int.parse(_currentrange!);
      radius= double.parse(_currentrange!);
      radius=radius*1000;
    });


  }

  List<LatLng> visitedLocations = [


  ];
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body:  Column(
        children: [



          const SizedBox(height: 5,),
            Row(
              children: [



                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text('Distance b/w Two Locations: ${(distance!/1000)!.toDouble()} Km',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                ),

                const Text('|    '),
                
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text('Current Range:               $_currentrange KM',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                  ),
                ),


              ],

            ),
          const SizedBox(height: 5,),





          Expanded(
            child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: LatLng(30.160760393105754, 72.66946287157693),
                    zoom: 15
                ),
                mapType: MapType.normal,
                markers: Set<Marker>.of(_marker),
                polylines: _polyline,
                onTap: (LatLng latlng){
                  lati= latlng.latitude;
                  lngi= latlng.longitude;
                  _marker.add(
                      Marker(
                          markerId: MarkerId('2'),
                          position: LatLng(lati,lngi),
                          infoWindow: const InfoWindow(
                            title: 'Given Location',
                          )
                      )
                  );
                  setState(() {

                    calculateDistance().then((value) {
                      Utilis().toastMessage('Distance between Current Location and Given Location: '+value.toString()+' Km');
                    });

                  });

                  setState(() {
                    visitedLocations.add(latlng);

                    // Convert the list of LatLng to List<Map<String, dynamic>>
                        List<Map<String, dynamic>> locationsData = visitedLocations
                        .map((latLng) => {'latitude': latLng.latitude, 'longitude': latLng.longitude})
                        .toList();



                    // Set the data in Firestore
                     FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).update({
                      'locations': locationsData,
                    }).then((value){
                      Utilis().toastMessage('Locations Saved Successfully!');
                     }).onError((error, stackTrace){
                       Utilis().toastMessage(error.toString());
                     });



                  });



            

                },



              circles: {

                Circle(
                  circleId: CircleId('circleId'),
                  center:  center,
                  fillColor: Colors.green.withOpacity(0.4),
                  radius: radius,
                  strokeWidth: 1,
                  strokeColor: Colors.red,
                )
              },

              //int.parse(distanceController.text).toDouble()*1000,





            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.center_focus_strong_outlined,color: Colors.white,),
          onPressed:()async{


              getUserCurrentLocation().then((value)async{

                  Utilis().toastMessage('Current Location fetched Successfully!');
                  Utilis().toastMessage('Tap To Add Second Location To Find Distance');


                _marker.add(
                    Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(value.latitude,value.longitude),
                        infoWindow: const InfoWindow(
                          title: 'User Current Location',
                        ),

                    )
                );

                final CameraPosition cameraposition= CameraPosition(
                  target: LatLng(value.latitude.toDouble(), value.longitude.toDouble()),
                  zoom: 15
                );

                final GoogleMapController controller= await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(cameraposition));




                setState(() {

                });


              }).onError((error, stackTrace){
                Utilis().toastMessage(error.toString());
              });

                 setState(() {
                   _getUserLocation();
                 });

          }),

    );
  }
}
