import 'package:capty/loginScreen.dart';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
      debugShowCheckedModeBanner: false,
      home: (auth.FirebaseAuth.instance.currentUser != null)
          ? GoalScreen()
          : LoginScreen()));
}
