import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merged_app/models/session_provider.dart';
import 'package:merged_app/navigations/control_panel_screen.dart';
import 'package:merged_app/navigations/difference_levels_screen.dart';
import 'package:merged_app/navigations/profile_screen.dart';
import 'package:merged_app/preposition_feature/preposition_main.dart';
import 'package:merged_app/screens/auth/login_page.dart';
import 'package:merged_app/screens/puzzle/puzzle_levels_screen.dart';
import 'package:merged_app/services/auth_service.dart';
import 'package:merged_app/services/shared_prefs_service.dart';
import 'package:merged_app/utils/function.dart';
import 'package:merged_app/widgets/custom_card.dart';
import 'package:merged_app/widgets/idea_card.dart';
import 'package:merged_app/widgets/long_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  double _imagePositionX = -30; // Initial position for animated image
  late Timer _inactivityTimer; // Timer for automatic logout
  final int _timeoutDuration = 20 * 60; // 20 minutes in seconds
  late int _remainingTime; // Remaining time for logout
  late String _timeDisplay; // Display for countdown
  late AudioPlayer _audioPlayer; // For background music
  String? userName; // User name from MongoDB
  bool isLoadingName = true; // Loading state for user name
  bool _isMuted = false; // Track mute state

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _getRemainingTimeFromPrefs(); // Initialize timer from SharedPreferences
    _loadMuteState(); // Load mute state from SharedPreferences
    _playBackgroundMusic(); // Play background music
    _startInactivityTimer(); // Start inactivity timer
    loadUserName(); // Load user name from MongoDB
    Future.delayed(Duration(seconds: 1), _animateImage); // Animate image
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to RouteObserver to detect navigation events
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        routeObserver.subscribe(this, route as PageRoute);
      });
    }
  }

  // Called when this route is re-entered after another route is popped
  @override
  void didPopNext() {
    _playBackgroundMusic(); // Restart music when returning to HomeScreen
    super.didPopNext();
  }

  // Load mute state from SharedPreferences
  Future<void> _loadMuteState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMuted = prefs.getBool('isMuted') ?? false;
      if (_isMuted) {
        _audioPlayer.setVolume(0.0);
      }
    });
  }

  // Save mute state to SharedPreferences
  Future<void> _saveMuteState(bool muted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMuted', muted);
  }

  // Play background music
  void _playBackgroundMusic() async {
    if (_isMuted) return;
    try {
      await _audioPlayer.stop(); // Ensure any existing playback is stopped
      await _audioPlayer.play(AssetSource('audios/bgmusic.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop music
      print("Music started playing");
    } catch (e) {
      print("Error playing music: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to play background music")),
      );
    }
  }

  // Toggle mute state
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
      _saveMuteState(_isMuted);
    });
  }

  // Animate image horizontally
  void _animateImage() {
    setState(() {
      _imagePositionX = 400; // Move image to the right
    });
  }

  // Start inactivity timer
  void _startInactivityTimer() {
    _inactivityTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
          _timeDisplay = _formatTime(_remainingTime);
        });
        _saveRemainingTimeToPrefs();
      } else {
        _logout();
        _inactivityTimer.cancel();
      }
    });
  }

  // Reset inactivity timer on user interaction
  void _resetInactivityTimer() {
    if (_inactivityTimer.isActive) {
      _inactivityTimer.cancel();
    }
    setState(() {
      _remainingTime = _timeoutDuration;
      _timeDisplay = _formatTime(_remainingTime);
    });
    _saveRemainingTimeToPrefs();
    _startInactivityTimer();
  }

  // Logout function
  Future<void> _logout() async {
    await _audioPlayer.stop(); // Stop music
    // Clear SharedPrefs (Magic Mind Puzzle)
    await SharedPrefs.clear();
    // Clear SessionProvider and SharedPreferences (NVD App)
    Provider.of<SessionProvider>(context, listen: false).clearSession();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('accessTokenExpireDate');
    await prefs.remove('refreshTokenExpireDate');
    await prefs.remove('userRole');
    await prefs.remove('authEmployeeID');
    await prefs.remove('vocabulary_difficulty');
    await prefs.remove('difference_difficulty');
    await prefs.remove('remainingTime');
    // Navigate to LoginPage
      Navigator.pushReplacementNamed(context, '/landing');
  }

  // Format time in mm:ss
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Save remaining time to SharedPreferences
  void _saveRemainingTimeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remainingTime', _remainingTime);
  }

  // Get remaining time from SharedPreferences
  void _getRemainingTimeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedTime = prefs.getInt('remainingTime');
    setState(() {
      _remainingTime = storedTime ?? _timeoutDuration;
      _timeDisplay = _formatTime(_remainingTime);
    });
  }

  // Load user name from MongoDB
  Future<void> loadUserName() async {
    final userId = await SharedPrefs.getUserId();
    if (userId != null) {
      final name = await MongoService.getUserName(userId);
      setState(() {
        userName = name ?? 'Friend';
        isLoadingName = false;
      });
    } else {
      setState(() {
        userName = 'Friend';
        isLoadingName = false;
      });
    }
  }

  // Build button for activities (Magic Mind Puzzle style)
  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton.icon(
        onPressed: () {
          _audioPlayer.stop(); // Stop music before navigation
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Andika',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _inactivityTimer.cancel();
    _audioPlayer.stop(); // Stop music
    _audioPlayer.dispose(); // Release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _resetInactivityTimer,
      child: Scaffold(
        body: SafeArea(
          child: isLoadingName
              ? Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/reg_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Loading....",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/reg_bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Header with user greeting, mute, and logout
                          Container(
                            height: 125,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            _isMuted ? Icons.volume_off : Icons.volume_up,
                                            color: Colors.white,
                                          ),
                                          onPressed: _toggleMute,
                                          tooltip: _isMuted ? "Unmute" : "Mute",
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "👋 Hello, ${userName ?? 'Friend'}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Ready to play and learn?",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: _logout,
                                      icon: Icon(Icons.exit_to_app, size: 30, color: Colors.white),
                                      tooltip: "Logout",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // CustomCard from NVD App
                          CustomCard(),
                          SizedBox(height: 20),
                          // Profile and Settings (NVD App)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: IdeaCard(
                                  title: "Profile",
                                  icon: Icons.house,
                                  navigationWindow: ProfileScreen(),
                                ),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: IdeaCard(
                                  title: "Settings",
                                  icon: Icons.verified_user_rounded,
                                  navigationWindow: ControlPanelScreen(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Activities section
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "ACTIVITIES",
                              style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          // Identify Differences (NVD App)
                          buildButton("💡  Identify Differences", Colors.pink, () async {
                            bool demo = await loadString("demo", "no") != "no";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DifferenceRecognitionLevelsScreen(),
                              ),
                            );
                          }),
                          // Puzzle Game (Magic Mind Puzzle)
                          buildButton("🧩   Puzzle Game", Colors.purple, () async {
                            bool demo = await loadString("demo", "no") != "no";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PuzzleLevelsScreen(demo: demo),
                              ),
                            );
                          }),
                          // Preposition Game (Magic Mind Puzzle)
                          buildButton("🎤   Preposition Game", Colors.brown, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrepositionHome(),
                              ),
                            );
                          }),
                          // Quiz Time (Placeholder)
                          buildButton("📝  Quiz Time", Colors.orange, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Quiz Time coming soon!")),
                            );
                          }),
                          // Explore World (Placeholder)
                          buildButton("🌍   Explore World", Colors.teal, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Explore World coming soon!")),
                            );
                          }),
                          SizedBox(height: 20),
                        ],
                      ),
                      // Animated image (NVD App)
                      AnimatedPositioned(
                        bottom: -80,
                        left: _imagePositionX,
                        duration: Duration(seconds: 20),
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          'assets/icons/toys.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Timer and logout button (NVD App)
                      Positioned(
                        bottom: 20,
                        left: 150,
                        right: 10,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 155, 71, 71).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromARGB(255, 248, 247, 247).withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Time remaining: ',
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _timeDisplay,
                                    style: GoogleFonts.aBeeZee(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 2, 173, 10),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.logout, color: Colors.white),
                                onPressed: _logout,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// RouteObserver to track navigation
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();