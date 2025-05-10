import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/auth/login_page.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';
import 'package:magicmind_puzzle/services/http_client.dart';
import 'package:magicmind_puzzle/services/mongodb.dart';
import 'package:magicmind_puzzle/services/shared_prefs_service.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _startScreen() async {
    final id = await SharedPrefs.getUserId();
    return id == null ? LoginPage() : HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magic Mind Puzzle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _startScreen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data!;
            }
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }),
    );
  }
}
