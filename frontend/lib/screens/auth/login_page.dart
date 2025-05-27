import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merged_app/navigations/home_screen.dart';
import 'package:merged_app/screens/auth/register_page.dart';
import 'package:merged_app/services/auth_service.dart';
import 'package:merged_app/services/shared_prefs_service.dart';
 

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();

  final passwordCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    final user = await MongoService.login(emailCtrl.text, passwordCtrl.text);
    if (user != null) {
      await SharedPrefs.saveUserId(user['_id'].toHexString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (predicate) => false,
      );
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Oops! Try again 😕")));
    }
  }

  void goToRegister(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🎉 Welcome Back!",
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
                      if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please fill all fields")));
                      } else {
                        await login(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      "Let’s Start!",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Andika',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            TextButton(
              onPressed: () => goToRegister(context),
              child: Text("👶 New here? Create your account",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Andika',
                    fontSize: 16,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
