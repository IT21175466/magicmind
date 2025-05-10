import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicmind_puzzle/screens/auth/login_page.dart';
import 'package:magicmind_puzzle/screens/puzzle/puzzle_levels_screen.dart';
import 'package:magicmind_puzzle/services/auth_service.dart';
import 'package:magicmind_puzzle/services/shared_prefs_service.dart';
import 'package:magicmind_puzzle/utils/function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> logout(BuildContext context) async {
    await SharedPrefs.clear();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginPage()), (predicate) => false);
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Andika',
          ),
        ),
      ),
    );
  }

  Future<void> loadUserName() async {
    final userId = await SharedPrefs.getUserId();
    if (userId != null) {
      final name = await MongoService.getUserName(userId);
      setState(() {
        userName = name ?? 'Friend';
      });
    }
  }

  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/reg_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Home Banner
            Container(
              height: 125,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "👋 Hello, ${userName ?? 'Friend'}",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Ready to play and learn?",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          logout(context);
                        },
                        icon: Icon(Icons.exit_to_app,
                            size: 30, color: Colors.white),
                        tooltip: "Logout",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Spacer(),
            buildButton("🧩   Puzzle Game", Colors.purple, () async {
              bool demo = await loadString("demo", "no") != "no";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contex) => PuzzleLevelsScreen(
                    demo: demo,
                  ),
                ),
              );
            }),
            buildButton("🎤   Presentation Game", Colors.brown, () {}),
            buildButton("📝  Quiz Time", Colors.orange, () {}),
            buildButton("🌍   Explore World", Colors.teal, () {}),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
