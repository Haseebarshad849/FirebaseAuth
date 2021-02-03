import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_and_auth/screens/Login.dart';
import 'package:sign_in_and_auth/screens/home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController passcontroller = TextEditingController();
  TextEditingController rpasscontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  // ignore: unused_field
  String _email, _name, _password;
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(13.0),
        child: Form(
          key: _formkey,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _name = value;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    errorStyle: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Enter Your Full Name'),
              ),
              // For Spacing
              Container(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'Please a valid Email';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _email = value.trim();
                },
                // onChanged: (value) {
                //   _email = value;
                // },
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    errorStyle: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'someone@email.com'),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    errorStyle: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Enter Password'),
                controller: passcontroller,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                obscureText: true,
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                controller: rpasscontroller,
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (passcontroller.text != rpasscontroller.text) {
                    return "Password not matched";
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Repeat Password',
                    errorStyle: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Please Repeat Your Password'),
                obscureText: true,
                maxLength: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              //BUTTON
              SizedBox(
                width: 20.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  color: Colors.blue[600],
                  textColor: Colors.white,
                  splashColor: Colors.redAccent,
                  elevation: 6.0,
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {}
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _email, password: passcontroller.text)
                        .then((signedInUser) {
                      _store.collection('users').add({
                        'email': _email,
                        'pass': passcontroller.text,
                        'name': _name
                      }).then((value) {
                        if (signedInUser != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        }
                      }).catchError((e) {
                        print(e);
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Already have an account",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthFire(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueAccent),
                      ),
                      splashColor: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
