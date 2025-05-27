import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merged_app/constants/env.dart';
import 'package:merged_app/constants/styles.dart';
import 'package:merged_app/models/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInWindow extends StatefulWidget {
  @override
  _SignInWindowState createState() => _SignInWindowState();
}

class _SignInWindowState extends State<SignInWindow> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${ENVConfig.serverUrl}/token');
    final signInData = {
      "guardian_email": _usernameController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(signInData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['access_token']);
        final user = data['user'];

        Provider.of<SessionProvider>(context, listen: false).updateSession(
          accessToken: data['access_token'],
          refreshToken: "refreshToken",
          userRole: data['token_type'],
          authEmployeeID: user['_id'] ?? '0',
          complications: user['complications'] != null
              ? List<String>.from(user['complications'])
              : [],
          contactNumber: user['contact_number'] ?? '',
          createdAt: DateTime.now(),
          email: user['email'] ?? '',
          fullName: user['full_name'] ?? '',
          userId: user['_id'] ?? '',
          username: user['username'] ?? '',
        );

        await _storeSessionInSharedPreferences(
          data['access_token'],
          "ref",
          "Patient",
          user['_id'] ?? '',
          user['email'] ?? '',
          user['full_name'] ?? '',
          user['vocabulary'] ?? 1,
          user['identify_difference'] ?? 1,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in successful!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in')),
        );
      }
    } catch (error, stackTrace) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Future<void> _storeSessionInSharedPreferences(
    String accessToken,
    String refreshToken,
    String userRole,
    String authEmployeeID,
    String email,
    String full_name,
    int vocab,
    int ident,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', accessToken);
      prefs.setString('refreshToken', refreshToken);
      prefs.setString('userRole', userRole);
      prefs.setString('authEmployeeID', authEmployeeID);
      prefs.setString('email', email);
      prefs.setString('full_name', full_name);
      prefs.setInt('difference_difficulty', ident);
      prefs.setInt('vocabulary_difficulty', vocab);
    } catch (e) {
      print('Error storing session data in shared preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/reg_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SafeArea(
          minimum: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🌟 Let’s Sign You In!",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 80),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black),
                  decoration: _buildInputDecoration('Your Username', Icons.person),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: _buildInputDecoration('Your Password', Icons.lock_outline),
                ),
                SizedBox(height: 30),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Andika',
                            color: Colors.white,
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/sign-up');
                  },
                  child: Text(
                    "📝 Haven't got an Account?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Andika',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}