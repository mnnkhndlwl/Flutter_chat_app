import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import './screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(builder: (context, userSnapshot) {
        if(userSnapshot.hasData) {
          return ChatScreen();
        }
        return AuthScreen();
      } ,stream: FirebaseAuth.instance.onAuthStateChanged,),
    );
  }
}
