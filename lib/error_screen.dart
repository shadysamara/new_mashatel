import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ErrorScreen extends StatelessWidget {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.signal_wifi_off),
          onPressed: () async {
            final productsRef = await firestore.collection('test');
            productsRef.get().then((value) {
              value.docs.forEach((element) {
                print(element.data());
              });
            });
          },
        ),
      ),
    );
  }
}
