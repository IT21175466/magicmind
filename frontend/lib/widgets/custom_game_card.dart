import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/utils/app_styles.dart';

class CustomGameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const CustomGameCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 100,
      width: screenWidth,
      margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Styles.bgColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Andika',
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black, size: 30),
          ],
        ),
      ),
    );
  }
}
