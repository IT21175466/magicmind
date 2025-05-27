import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LongCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget navigationWindow;
  final Color backgroundColor; // New parameter for background color

  const LongCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.navigationWindow,
    this.backgroundColor = const Color.fromARGB(
        255, 255, 254, 254), // Default color if not provided
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
      color: backgroundColor, // Use the passed background color
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xffFFFFFF), width: 2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        onTap: () => _navigate(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Color(0xffFFFFFF),
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.andika(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_outlined,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ],
          ),
        ),
      ),
    );
  }
}
