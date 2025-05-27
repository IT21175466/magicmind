import 'dart:io';
 
 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merged_app/constants/styles.dart';
import 'package:merged_app/models/session_provider.dart';
import 'package:merged_app/navigations/home_screen.dart';
import 'package:merged_app/navigations/landing_screen.dart';
import 'package:merged_app/navigations/signin_window.dart';
import 'package:merged_app/navigations/signup_window.dart';
import 'package:merged_app/screens/auth/login_page.dart';
import 'package:merged_app/services/mongodb.dart';
import 'package:merged_app/services/shared_prefs_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await MongoDatabase.connect();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Merged App', // Update as needed
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(137, 217, 242, 1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(fontSize: 15),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              shadowColor: Styles.shadowColor,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
          future: checkSharedPreferences(context, prefs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return snapshot.data == true ? HomeScreen() : LandingPage();
          },
        ),
        routes: {
          '/home': (context) => HomeScreen(),
          '/landing': (context) => LandingPage(),
          '/sign-up': (context) => SignUpWindow(),
          '/sign-in': (context) => SignInWindow(),
          '/login': (context) => LoginPage(), // From Magic Mind Puzzle
        },
      ),
    );
  }

  Future<bool> checkSharedPreferences(BuildContext context, SharedPreferences prefs) async {
    String? authEmployeeID = prefs.getString('authEmployeeID');
    String? userId = await SharedPrefs.getUserId(); // From Magic Mind Puzzle
    if (authEmployeeID != null || userId != null) {
      Provider.of<SessionProvider>(context, listen: false).updateSession(
        accessToken: prefs.getString('accessToken') ?? '',
        refreshToken: prefs.getString('refreshToken') ?? '',
        userRole: prefs.getString('userRole') ?? '',
        username: authEmployeeID ?? userId ?? '',
        complications: [],
        contactNumber: '',
        createdAt: DateTime.parse('2022-04-05'),
        email: '',
        fullName: '',
        userId: userId ?? '',
        authEmployeeID: authEmployeeID ?? '',
      );
      return true;
    }
    return false;
  }
}