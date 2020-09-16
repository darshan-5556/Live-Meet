import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:livemeet/HomePage.dart';
import 'package:livemeet/user.dart';
import 'package:flutter/Material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final DateTime timestamp = DateTime.now();
final GoogleSignIn gSignIn = GoogleSignIn();
final usersRefrance = Firestore.instance.collection("Users");

User currentUser;
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool LoaderOn = false;
  bool isSignin = false;
  String channelId;
  Random _rnd = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoaderOn = true;
    getLoader();
    channelId = getRandomString(8);
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gerror) {
      print("Error by me" + gerror);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gEROR) {
      print("Error by me" + gEROR);
    });
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getLoader() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        LoaderOn = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  controllSignIn(GoogleSignInAccount SignInAccount) async {
    if (SignInAccount != null) {
      await SaveUserInfoToFirestore();
      setState(() {
        isSignin = true;
      });
    } else {
      setState(() {
        isSignin = false;
      });
    }
  }

  SaveUserInfoToFirestore() async {
    // Prefrances = await SharedPreferences.getInstance();

    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersRefrance.document(gCurrentUser.id).get();
    if (!documentSnapshot.exists) {
      usersRefrance.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "timestamp": timestamp,
        "isRequestToJoin": false,
        "channelId": channelId,
      });
      documentSnapshot = await usersRefrance.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  UserLogin() {
    gSignIn.signIn();
  }

  Scaffold LoginScreen() {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: UserLogin(),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Logged You In..",
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
          ),
          Container(
            height: 10.0,
          ),
          Container(
            child: LoaderOn ? CircularProgressIndicator() : Container(),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignin) {
      return HomePage();
    } else {
      return LoginScreen();
    }
  }
}
