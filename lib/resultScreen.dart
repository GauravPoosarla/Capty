import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
  File image;
  SplashScreen(this.image);
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width*0.7;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffD9F1ED),
        body: Stack(
          children: [
            Positioned(child: SvgPicture.asset('assets/corner.svg',width: 350,height: 350,),left: 0,top: 0,),
            Positioned(child: SvgPicture.asset('assets/cornerBottom.svg',width: 350,height: 350,),bottom: 0,right: 0,),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Results!',
                        style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff29BCBC)),
                      ),
                      SizedBox(height: 20,),
                      Center(child: ClipRRect(borderRadius: BorderRadius.circular(32),child: Image.file(widget.image,width: width,fit: BoxFit.fitHeight,))),
                      SizedBox(height: 30,),
                      Card(
                        color: Color(0xff24BFBF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('A Yellow Paperboat.',style: TextStyle(fontSize: 20,),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text('Liked this magic tool?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff29BCBC),
                              fontFamily: 'Poppins')),
                      Text(' Rate us on Playstore!',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black, fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
