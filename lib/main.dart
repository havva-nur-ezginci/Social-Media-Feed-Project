import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_media_feed/screens/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor('#6B8E23'), // Ana renk: Yeşil
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightGreen,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 132, 184, 72), // App bar background color
          elevation: 0, // App bar shadow effect
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold), // App bar icon color
        ),
      ),
      home: const FeedPage(),
    );
  }
}
