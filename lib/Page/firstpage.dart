import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runner/Page/dashboard.dart';
import 'loginpage.dart';

// Execute future inside of () due to onPressed accepts only void

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("State is done?");
              return Container(
                child: CircularProgressIndicator(
                  // TODO: Not Working
                  color: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            } else if (snapshot.hasData)
              return DashboardPage();
            else if (snapshot.hasError) {
              return Center(
                child: Text("Unsuccessful Login Attempt!"),
              );
            } else
              return LoginPage();
          },
        ),
      );
}
