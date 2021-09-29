import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flight_res_system/pages/home_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = "login_scrren";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  Map<String, dynamic> _userData = {
    'firstName': "",
    'lastName': "",
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
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
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Log In',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Scheherazade New',
                          color: Color(0xffFE2E2E)),
                    ),
                  ],
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFormFeild(
                          emailController, Icons.email, 'email', false),
                      SizedBox(
                        height: 20.0,
                      ),
                      textFormFeild(
                          passwordController, Icons.lock, 'password', true)
                    ],
                  )),
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
                        final user = await _auth.signInWithEmailAndPassword(
                            email: _userData["email"],
                            password: _userData["password"]);
                        try {
                          if (user != null) {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(context, "/second");
                          }
                        } catch (e) {
                          print(e);
                        }
                        emailController.text = '';
                        passwordController.text = '';
                      }
                    },
                    child: Text('Log In'),
                  )),
              Container(
                  child: Row(
                children: <Widget>[
                  Text('Does not have account?'),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Color(0xffFE2E2E), // foreground
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/first");
                    },
                    child: Text('Sign Up'),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ))
              // Container(
              //   alignment: Alignment.center,
              //   padding: EdgeInsets.all(10.0),
              //   child: Text,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
