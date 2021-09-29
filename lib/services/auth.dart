import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flight_res_system/pages/home_page.dart';
import 'package:flutter/material.dart';

class UserAuth {
  final _auth = FirebaseAuth.instance;

  checkCurrentUser() {
    User? user = _auth.currentUser;
    try {
      if (user != null)
        return user;
      else
        return null;
    } catch (e) {
      print(e);
    }
  }

  Future registerUser(
      String email, String password, String firstName, String lastName) async {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance.collection("userData").add({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
      });
      return true;
    } catch (e) {
      print(e);
    }
  }

  Future loginUser(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
