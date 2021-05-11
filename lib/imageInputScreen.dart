import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:capty/resultScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io' ;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as store;
import 'package:cloud_firestore/cloud_firestore.dart' as fbStore;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:random_string/random_string.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ImageInputScreen extends StatefulWidget {
    @override
    _ImageInputScreenState createState() => _ImageInputScreenState();
}

class _ImageInputScreenState extends State<ImageInputScreen> {
    Future<void> getImage() async {
        final ImagePicker _picker = ImagePicker();
        PickedFile image = await _picker.getImage(source: ImageSource.gallery);
        File imageFile = File(image.path);
        String imgId = randomAlphaNumeric(7);
        fbStore.FirebaseFirestore.instance.collection('path').doc('urlPath').get().then((value) async {
          Uri url = Uri.parse(value.data()['url'].toString());
          await store.FirebaseStorage.instance.ref().child('${auth.FirebaseAuth.instance.currentUser.uid}/$imgId.jpg/')
              .putFile(imageFile).whenComplete(() async {
            http.post(url,body: {
              "uid": auth.FirebaseAuth.instance.currentUser.uid,
              "imgId": imgId+'.jpg'
            }).then((res) {
              final body = json.decode(res.body);
              print(body);
              Navigator.push(context, MaterialPageRoute(builder: ((context){
                return ResultScreen(imageFile,body);
              })));
            });
          });
        });
    }

    Future<void> getCameraImage() async {
      final ImagePicker _picker = ImagePicker();
      PickedFile image = await _picker.getImage(source: ImageSource.camera);
      File imageFile = File(image.path);
      String imgId = randomAlphaNumeric(7);
      fbStore.FirebaseFirestore.instance.collection('path').doc('urlPath').get().then((value) async {
        Uri url = Uri.parse(value.data()['url'].toString());
        await store.FirebaseStorage.instance.ref().child('${auth.FirebaseAuth.instance.currentUser.uid}/$imgId.jpg/')
            .putFile(imageFile).whenComplete(() async {
          http.post(url,body: {
            "uid": auth.FirebaseAuth.instance.currentUser.uid,
            "imgId": imgId+'.jpg'
          }).then((res) {
            final body = json.decode(res.body);
            print(body);
            Navigator.push(context, MaterialPageRoute(builder: ((context){
              return ResultScreen(imageFile,body);
            })));
          });
        });
      });
    }

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
                          Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  'Capty uses AI and lets you know more about the image!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff29BCBC),
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 4,
                              ),
                          ),
                          SizedBox(height: 32,),
                          Text(
                              'Upload an image or take a photo',
                              style: TextStyle(
                                  color: Color(0xff187872),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                              ),
                          ),
                          SizedBox(height: 32,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 80,
                                          height: 80,
                                        child: ElevatedButton(
                                            onPressed: getImage, child: Icon(Icons.photo_library,color: Colors.black,size: 50,),
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff24BFBF))),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text('Gallery',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xff187872)))
                                    ],
                                  ),
                                  SizedBox(width: 20.0),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 80,
                                        height: 80,
                                        child: ElevatedButton(
                                            onPressed: getCameraImage, child: Icon(Icons.photo_camera_sharp,color: Colors.black,size: 50),
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xff24BFBF))),
                                        ),
                                      ),
                                        SizedBox(height: 10,),
                                        Text('Camera',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xff187872)))
                                    ],
                                  ),
                              ],
                          ),
                      ],
                  ),
                ],
              ),
          ),
        );
    }
}