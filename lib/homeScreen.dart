import 'package:capty/imageInputScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //@override
  // void initState() {
  //   auth.FirebaseAuth.instance.signInAnonymously().then((value) {});
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffD9F1ED),
        body: Stack(
          children: [
            Positioned(child: SvgPicture.asset('assets/corner.svg',width: 350,height: 350,),left: 0,top: 0,),
            Positioned(child: SvgPicture.asset('assets/cornerBottom.svg',width: 350,height: 350,),bottom: 0,right: 0,),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.
                spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset("assets/blind.svg",fit: BoxFit.contain,width: 400,height: 150,),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff24BFBF)),
                            shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ImageInputScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 15),
                          child: Text('Try it now!',
                              style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset("assets/thinking.svg",fit: BoxFit.contain,height: 150,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
