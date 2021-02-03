import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

class HomeScreen extends StatefulWidget {
  //  final user;
  //  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  // get usercontroller => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome Ho Gya",
              style: TextStyle(fontSize: 24),
            ),
            RaisedButton(
              child: Text("LogOut"),
              onPressed: () {
                _signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthFire()));
                });
              },
            ),
          ]),
    );
  }

  Future _signOut() async {
    await auth.signOut();
  }
}
