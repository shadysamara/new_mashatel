import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';

class MarkertLocationCollecter extends StatefulWidget {
  static String routeName = 'LocationCollecter';
  @override
  State<StatefulWidget> createState() {
    return LocationCollecterState();
  }
}

class LocationCollecterState extends State<MarkertLocationCollecter> {
  final SignInGetx signInGetx = Get.put(SignInGetx());
  GoogleMapController mapController;
  GlobalKey<ScaffoldState> scaffolState = GlobalKey();
  String label = '';
  final LatLng _center = const LatLng(24.4539, 54.3773);
  Future<Position> getCurrentLocation() async {
    Position position = await signInGetx.setCurrentLocation();
    signInGetx.positionIsMarkes.value = true;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15)));
    return position;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getCurrentLocation().then((position) {
      markerPosition = position;
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId('userSelection'),
          position: LatLng(position.latitude, position.longitude)));
      setState(() {});
    });
  }

  Set<Marker> _markers = {};
  Position markerPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolState,
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomControlsEnabled: false,
            markers: _markers,
            onTap: (piclerLocation) {
              _markers.clear();
              _markers.add(Marker(
                  markerId: MarkerId('userSelection'),
                  position: LatLng(
                      piclerLocation.latitude, piclerLocation.longitude)));
              setState(() {});
              markerPosition = Position(
                  latitude: piclerLocation.latitude,
                  longitude: piclerLocation.longitude);
              signInGetx.setPositionValue(markerPosition);
              signInGetx.positionIsMarkes.value = true;
            },
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 5.0,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: FlatButton(
                onPressed: () async {
                  Position position = await signInGetx.setCurrentLocation();
                  signInGetx.positionIsMarkes.value = true;
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 15),
                  ));
                  _markers.clear();
                  _markers.add(Marker(
                      markerId: MarkerId('currentLocation'),
                      position: LatLng(position.latitude, position.longitude)));
                  setState(() {});
                  markerPosition = position;
                },
                child: Icon(Icons.my_location)),
          )
        ],
      ),
    );
  }
}
