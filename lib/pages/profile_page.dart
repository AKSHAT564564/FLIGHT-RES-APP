import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static String id = "profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  String firstName = "", lastName = "", userEmail = "";

  @override
  void initState() {
    super.initState();
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userEmail = user.email!;
        getUserDetail();
      }
    } catch (e) {
      print(e);
    }
  }

  getUserDetail() async {
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection('userData')
        .where('email', isEqualTo: userEmail)
        .get();

    firstName = "${query.docs[0]["firstName"]}";
    lastName = "${query.docs[0]["lastName"]}";

    firstName = firstName.toUpperCase();
    lastName = lastName.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Res'),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            SizedBox(height: 160),
            Icon(
              FontAwesomeIcons.user,
              size: 60,
            ),
            SizedBox(height: 30),
            Text('$firstName $lastName',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Scheherazade New')),
            SizedBox(
              height: 15,
            ),
            Text(
              "$userEmail",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Scheherazade New'),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut().then((value) {
                  Navigator.pushReplacementNamed(context, "/");
                });
              },
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
            )
          ],
        ),
      ),
    );
  }
}
