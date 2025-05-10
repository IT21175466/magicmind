import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/auth/login_page.dart';
import 'package:magicmind_puzzle/services/shared_prefs_service.dart';
import 'package:magicmind_puzzle/widgets/custom_game_card.dart';
import '../../utils/function.dart';
import '../puzzle/puzzle_levels_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Magic Mind',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Andika',
                  ),
                ),
                Text(
                  'Kids mental helth provider.',
                  style: TextStyle(
                      fontFamily: 'Andika',
                      color: Colors.white70,
                      fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => logout(context),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 82, 3, 241),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/reg_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Home Banner
            SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                bool demo = await loadString("demo", "no") != "no";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) => PuzzleLevelsScreen(
                      demo: demo,
                    ),
                  ),
                );
              },
              child: CustomGameCard(
                title: "Puzzle Game",
                icon: Icons.dashboard,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
