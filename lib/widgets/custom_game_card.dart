import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/utils/app_styles.dart';

class CustomGameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomGameCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Styles.fontDark,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Styles.secondaryAccent.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Styles.fontHighlight2, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Color(0xFF94B7B1)),
          ],
        ),
      ),
    );
  }
}