//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_and_auth/screens/SignUp.dart';
import 'package:sign_in_and_auth/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFire extends StatefulWidget {
  @override
  _AuthFireState createState() => _AuthFireState();
}

class _AuthFireState extends State<AuthFire> {
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _obscureText = true;
  String email, password, name;
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  User user;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  var _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Login Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset('lib/images/uavat.png'),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  //color: Colors.blue,
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                controller: usercontroller,
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
                onChanged: (value) {
                  setState(() {
                    email = value.trim();
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Username',
                    errorStyle: TextStyle(
                      color: Colors.green[700],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'someone@example.com'),
                // maxLength: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                controller: passcontroller,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Invalid Password';
                  } else if (value.length < 6) {
                    return 'Incorrect Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value.trim();
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorStyle: TextStyle(
                      color: Colors.green[700],
                      fontSize: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: '**********'),
                obscureText: _obscureText,
                //a1 maxLength: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                // width: 20.0,
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
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        // ignore: non_constant_identifier_names
                        .then((FirebaseUser) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
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
                      "Dont have an account",
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
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: Text(
                        'Sign Up',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueAccent),
                      ),
                      splashColor: Colors.black,
                    ),
                  ),
                ],
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () async {
                  try {
                    await handleSignIn().then((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                    });
                  } catch (e) {
                    print(e.toString());
                  }

                  // handleSignIn().then((onValue) {
                  //   store.collection('users').doc('auth').collection('guser').add({'email':email,'name':name,'image':imageURL})
                  // }).catchError((e) {
                  //   print(e);
                  // });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleSignIn() async {
    String email, name, imageUrl;

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    // ignore: deprecated_member_use
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = (await auth.signInWithCredential(credential));
    user = result.user;
    //user1 = firebase.auth().currentUser;

    // assert(user.displayName != null);
    // assert(email != null);
    // assert(user.photoURL != null);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;

    User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    await store
        .collection('users')
        .doc('auth')
        .collection('guser')
        .add({'email': email, 'name': name, 'image': imageUrl});

    try {
      String value;
      if (value != null) {}
    } catch (e) {}
  }
}
