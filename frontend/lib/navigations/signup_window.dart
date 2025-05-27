import 'dart:convert';
import 'dart:io';
 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
 
import 'package:merged_app/constants/env.dart';
import 'package:merged_app/constants/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpWindow extends StatefulWidget {
  @override
  _SignUpWindowState createState() => _SignUpWindowState();
}

class _SignUpWindowState extends State<SignUpWindow> {
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianEmailController = TextEditingController();
  final TextEditingController _guardianContactController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childAgeController = TextEditingController();
  final TextEditingController _childGenderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _complicationController = TextEditingController();

  File? _avatarImage;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  int _childAge = 4;
  String? _childGender;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _avatarImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // API URL
    final url = Uri.parse('${ENVConfig.serverUrl}/signup');

    print(_childGender);
    print(_childAge);

    // Prepare sign-up data
    final signupData = {
      "guardian_name": _guardianNameController.text,
      "guardian_email": _guardianEmailController.text,
      "guardian_contact": _guardianContactController.text,
      "child_name": _childNameController.text,
      "child_age": _childAge,
      "child_gender": _childGender,
      "password": _passwordController.text,
      "avatar": "example.jpg", // Static example value; handle actual file upload if needed
    };

    try {
      // Make POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(signupData),
      );

      // Handle response
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacementNamed(context, '/sign-in'); // Navigate to Sign-In page
      } else {
        final errorMessage = jsonDecode(response.body)['detail'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }


  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Styles.secondaryAccent),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Styles.secondaryAccent),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Styles.secondaryAccent),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Styles.secondaryAccent),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      // Set typed text color to white
      hintStyle: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/backgrounds/1737431584894.png_image.png'), // Replace with your background image
          //     fit: BoxFit.cover, // Ensure the image covers the entire screen
          //   ),
          // ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: AppBar(
                  backgroundColor: Colors.transparent, // Transparent background
                  elevation: 0, // Remove shadow
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20, // Main title font size
                          color: Colors.white, // Text color
                        ),
                      ),
                      SizedBox(height: 4), // Space between title and subtitle
                      Text(
                        'Fill details to create account',
                        style: TextStyle(
                          fontSize: 14, // Subtitle font size
                          fontWeight: FontWeight.normal,
                          color: Colors.white70, // Text color
                        ),
                      ),
                    ],
                  ),
                  titleSpacing: 0,
                  leading: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff80ca84), // Background color for the circle
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.6), // Glow effect
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon
                      onPressed: () {
                        Navigator.pop(context); // Navigate back
                      },
                    ),
                  ),
                  actions: [

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Guardian Details", style: TextStyle(color: Styles.fontLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    TextField(controller: _guardianNameController, style: TextStyle(color: Styles.fontLight), decoration: _buildInputDecoration('Guardian Name')),
                    SizedBox(height: 10.0),
                    TextField(controller: _guardianEmailController, style: TextStyle(color: Styles.fontLight), decoration: _buildInputDecoration('Email')),
                    SizedBox(height: 10.0),
                    TextField(controller: _guardianContactController, style: TextStyle(color: Styles.fontLight), decoration: _buildInputDecoration('Contact Number')),
                    SizedBox(height: 10.0),
                    Divider(color: Styles.secondaryAccent),
                    SizedBox(height: 12.0),
                    Text("Child Details", style: TextStyle(color: Styles.fontLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    TextField(controller: _childNameController, style: TextStyle(color: Styles.fontLight), decoration: _buildInputDecoration('Child Name')),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age', style: TextStyle(color: Styles.secondaryAccent, fontSize: 16)),
                        Slider(
                          value: _childAge.toDouble(),
                          min: 4,
                          max: 20,
                          inactiveColor: Styles.secondaryAccent,
                          divisions: 16,
                          label: _childAge.toString(),
                          onChanged: (value) {
                            setState(() {
                              _childAge = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Gender', style: TextStyle(color: Styles.fontLight, fontSize: 16)),
                        Container(
                          width: double.infinity, // Ensures full width
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            // color: Styles.primaryAccent,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Styles.secondaryAccent), // Optional border styling
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _childGender,
                              hint: Text(
                                'Select Gender',
                                style: TextStyle(color: Styles.fontLight), // White text for hint
                              ),
                              dropdownColor: Styles.fontHighlight, // Background color for dropdown menu
                              items: _genderOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.white), // White text for dropdown options
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _childGender = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.0),
                    Text("Child Avatar", style: TextStyle(color: Styles.fontLight, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    Center(
                      child: GestureDetector(
                        onTap: _pickAvatar,
                        child: Container(
                          width: 100, // Set square dimensions
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            image: _avatarImage != null
                                ? DecorationImage(image: FileImage(_avatarImage!), fit: BoxFit.cover)
                                : DecorationImage(image: AssetImage('assets/icons/profile.gif'), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(color: Styles.fontLight),
                      decoration: _buildInputDecoration('Password'),
                    ),

                    SizedBox(height: 20.0),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.dangerColor,
                      ),
                      child: Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/sign-in');
                      },
                      child: Text('Already have an account? Sign In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _guardianNameController.dispose();
    _guardianEmailController.dispose();
    _guardianContactController.dispose();
    _childNameController.dispose();
    _childAgeController.dispose();
    _childGenderController.dispose();
    _passwordController.dispose();
    _complicationController.dispose();
    super.dispose();
  }
}
