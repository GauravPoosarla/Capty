import 'dart:io';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
  File image;
  dynamic body;
  ResultScreen(this.image,this.body);
}
enum TtsState { playing, stopped, paused, continued }
class _ResultScreenState extends State<ResultScreen> {
  FlutterTts flutterTts = FlutterTts();
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  @override
  void initState() {
    super.initState();
    initializeTts();
  }
  initializeTts(){
      _getEngines();
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });
  }
  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Results!',
                            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xff29BCBC)),
                          ),
                          IconButton(icon: Icon(Icons.volume_down_outlined,color: Color(0xff29BCBC),size: 40,), onPressed: ()async{
                            var result = await flutterTts.speak(widget.body["res"].toString());
                            if (result == 1) setState(() => ttsState = TtsState.playing);
                          })
                        ],
                      ),
                      SizedBox(height: 20,),
                      Center(child: ClipRRect(borderRadius: BorderRadius.circular(32),child: Image.file(widget.image,width: width,fit: BoxFit.fitHeight,))),
                      SizedBox(height: 30,),
                      Card(
                        color: Color(0xff24BFBF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(widget.body["res"],textAlign: TextAlign.center,maxLines: 4,style: TextStyle(fontSize: 20,),),
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
