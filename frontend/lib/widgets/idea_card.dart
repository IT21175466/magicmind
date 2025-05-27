import 'package:flutter/material.dart';
import 'package:merged_app/constants/styles.dart';
 
class IdeaCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget navigationWindow;

  const IdeaCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.navigationWindow,
  }) : super(key: key);

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigationWindow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.white, // Changed to white border
          width: 1.0,         // Adjusted width to 1.0 for a small border
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _navigate(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Styles.fontLight, size: 30),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}