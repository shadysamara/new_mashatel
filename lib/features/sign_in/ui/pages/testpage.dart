import 'package:flutter/material.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/repositories/registration_client.dart';

class TestPage extends StatelessWidget {
  String title;
  TestPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                RegistrationClient.registrationIntance.signOut();
              })
        ],
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
