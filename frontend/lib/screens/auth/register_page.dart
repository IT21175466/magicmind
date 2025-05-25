import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';
import 'package:magicmind_puzzle/services/auth_service.dart';
import 'package:magicmind_puzzle/services/shared_prefs_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> register(BuildContext context) async {
    final id = await MongoService.register(
        emailCtrl.text, passwordCtrl.text, nameCtrl.text);
    if (id != null) {
      await SharedPrefs.saveUserId(id.toHexString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("That email is taken 😯")));
    }
  }

  void backToLogin(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/reg_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text("🌈 Let’s Create Your Account!",
                  style: GoogleFonts.poppins(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 80),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 30),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (emailCtrl.text.isNotEmpty &&
                            passwordCtrl.text.isNotEmpty) {
                          await register(context);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all fields")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        "Done!",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Andika',
                          color: Colors.white,
                        ),
                      ),
                    ),
              TextButton(
                onPressed: () => backToLogin(context),
                child: Text("👋 Already have an account? Log in",
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Andika',
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
