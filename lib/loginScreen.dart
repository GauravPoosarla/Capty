import 'package:capty/homeScreen.dart';
import 'package:capty/imageInputScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_svg/flutter_svg.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String inputName;
  bool loading= false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffD9F1ED),
        body: Stack(
          children: [
            Positioned(child: SvgPicture.asset('assets/corner.svg',width: 350,height: 350,),left: 0,top: 0,),
            Positioned(child: SvgPicture.asset('assets/cornerBottom.svg',width: 350,height: 350,),bottom: 0,right: 0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Welcome to',
                    style: TextStyle(
                        color: Colors.black, fontSize: 30.0)),
                Text('Capty',
                    style: TextStyle(
                        color: Color(0xff29BCBC),
                        fontSize: 70.0,
                        fontWeight: FontWeight.w900,
                        )),
                SizedBox(
                  height: 30,
                ),
                Text('Enter your name to get started!',
                    style: TextStyle(
                        color: Color(0xff29BCBC),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide.none),
                      hintText: 'Ex. John poppins',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (String s) {
                      setState(() {
                        inputName = s;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Color(0xff24BFBF),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    auth.FirebaseAuth.instance.signInAnonymously().then((value) {
                      firestore.FirebaseFirestore.instance
                          .collection("user+" + value.user.uid)
                          .doc('UserData')
                          .set({"Name": inputName}).then((value) {
                            setState(() {
                              loading = false;
                            });
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => GoalScreen()));
                      });
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    child: (!loading)?Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ):CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}