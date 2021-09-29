import 'package:flight_res_system/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flight_res_system/services/auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  String userEmail = "";
  Map<String, dynamic> _userData = {
    'firstName': "",
    'lastName': "",
    'email': "",
    'password': ""
  };

  // final emailFeild = TextFormField(
  //   key :
  // );

  Widget textFormFeild(controller, icon, feildName, obscureText) {
    return TextFormField(
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'please Enter $feildName';
        else
          return null;
      },
      onChanged: (value) {
        _userData['$feildName'] = value;
      },
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: 'Enter Your $feildName',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFE2E2E), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFE2E2E), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  addUser() async {
    await FirebaseFirestore.instance.collection('userData').add({
      'email': _userData["email"],
      'firstName': _userData["firstName"],
      'lastName': _userData["lastName"]
    });
    setState(() {
      showSpinner = false;
    });
    Navigator.pushNamed(context, "/second");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(
          'Flight Res',
          style: TextStyle(fontFamily: 'Scheherazade New'),
        ),
      )),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.planeDeparture, size: 30.0),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Flight Res',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Scheherazade New'),
                        ),
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Resgistration Form',
                    style: TextStyle(
                        fontSize: 15.0, fontFamily: 'Scheherazade New'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textFormFeild(firstNameController, Icons.email,
                            'firstName', false),
                        SizedBox(
                          height: 20,
                        ),
                        textFormFeild(lastNameController, Icons.person,
                            'lastName', false),
                        SizedBox(
                          height: 20,
                        ),
                        textFormFeild(
                            emailController, Icons.email, 'email', false),
                        SizedBox(height: 20),
                        textFormFeild(
                            passwordController, Icons.lock, 'password', true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      emailController.text = '';
                      firstNameController.text = '';
                      lastNameController.text = '';
                      passwordController.text = '';
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: _userData["email"],
                                password: _userData["password"]);

                        addUser();
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text('Sign Up'),
                )),
          ]),
        ),
      ),
    );
  }
}
