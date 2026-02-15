// ======================================================================
//                   SINGLE FILE - HEARUS APP (Combined)
// ======================================================================

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

// ======================================================================
//  DEPENDENCIES - add to pubspec.yaml
// ======================================================================
/*

99
dependencies:
  flutter:
    sdk: flutter
  speech_to_text: ^6.6.0
  flutter_tts: ^4.0.2
  translator: ^1.0.0   # or latest version

*/

// ======================================================================
//  COLORS
// ======================================================================
const Color bgBlack = Colors.black;
const Color textWhite = Colors.white;
const Color maroon = Color.fromARGB(255, 48, 122, 182);

// ======================================================================
//  MAIN
// ======================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HearUsApp());
}

class HearUsApp extends StatelessWidget {
  const HearUsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgBlack),
      home: const SplashWrapper(),
    );
  }
}

// ======================================================================
//  SPLASH → LANDING
// ======================================================================
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Timer(const Duration(seconds: 2), () {
        setState(() => showSplash = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: showSplash ? const SplashScreen() : const LandingPage(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgBlack,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hearing, size: 48, color: maroon),
            SizedBox(width: 10),
            Icon(Icons.back_hand, size: 40, color: maroon),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: maroon, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.hearing, color: maroon),
                        Icon(Icons.back_hand, color: maroon),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "HearUs",
                    style: TextStyle(
                      color: maroon,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Hero
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Bridging ",
                          style: TextStyle(color: textWhite),
                        ),
                        TextSpan(
                          text: "COMMUNICATION\n",
                          style: TextStyle(color: maroon),
                        ),
                        TextSpan(
                          text: "Barriers",
                          style: TextStyle(color: textWhite),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Empowering deaf and hard-of-hearing individuals with real-time speech and sign language translation",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: textWhite),
                    ),
                  ),
                ],
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "Get Started →",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Sign in",
                      style: TextStyle(color: textWhite),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
//  SIGNUP + LOGIN (placeholders — you can add Firebase later)
// ======================================================================
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgBlack,
        title: const Text(
          "Create Account",
          style: TextStyle(color: Color.fromARGB(255, 251, 251, 251)),
        ),
        iconTheme: const IconThemeData(color: maroon),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              field("Name", nameCtrl),
              field("Age", ageCtrl, number: true),
              field("Email", emailCtrl),
              field("Password", passwordCtrl),
              genderField(),
              field("Mobile Number", phoneCtrl, number: true),
              field("State", stateCtrl),
              field("Address (Optional)", addressCtrl, required: false),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: maroon),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final cred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: emailCtrl.text.trim(),
                              password: passwordCtrl.text.trim(),
                            );

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(cred.user!.uid)
                            .set({
                              "name": nameCtrl.text.trim(),
                              "age": ageCtrl.text.trim(),
                              "email": emailCtrl.text.trim(),
                              "phone": phoneCtrl.text.trim(),
                              "gender": gender,
                              "state": stateCtrl.text.trim(),
                              "address": addressCtrl.text.trim(),
                              "createdAt": FieldValue.serverTimestamp(),
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account created successfully."),
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 1));

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "Signup failed";

                        if (e.code == 'email-already-in-use') {
                          msg = "Email already registered";
                        } else if (e.code == 'invalid-email')
                          msg = "Invalid email format";
                        else if (e.code == 'weak-password')
                          msg = "Password too weak (min 6 chars)";
                        else if (e.code == 'network-request-failed')
                          msg = "Network error";
                        else
                          msg = e.message ?? msg;

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    }
                  },
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: textWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field(
    String label,
    TextEditingController c, {
    bool number = false,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        style: const TextStyle(color: textWhite),
        keyboardType: number ? TextInputType.number : TextInputType.text,
        validator: required ? (v) => v!.isEmpty ? "Enter $label" : null : null,
        decoration: inputStyle(label),
      ),
    );
  }

  Widget genderField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        dropdownColor: bgBlack,
        initialValue: gender,
        style: const TextStyle(color: textWhite),
        items: const [
          DropdownMenuItem(value: "Male", child: Text("Male")),
          DropdownMenuItem(value: "Female", child: Text("Female")),
          DropdownMenuItem(value: "Other", child: Text("Other")),
        ],
        onChanged: (v) => setState(() => gender = v!),
        decoration: inputStyle("Gender"),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgBlack,
        title: const Text("Sign In", style: TextStyle(color: maroon)),
        iconTheme: const IconThemeData(color: maroon),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                style: const TextStyle(color: textWhite),
                decoration: inputStyle("Email"),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                style: const TextStyle(color: textWhite),
                decoration: inputStyle("Password"),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: maroon),
                  onPressed: () async {
                    if (isLoading) return;
                    setState(() => isLoading = true);

                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailCtrl.text.trim(),
                        password: passwordCtrl.text.trim(),
                      );

                      final profile = await fetchUserProfile();
                      print("USER PROFILE DATA: $profile");

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                            "lastLoginAt": FieldValue.serverTimestamp(),
                            "lastLoginDevice": "flutter-app",
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login successful."),
                          backgroundColor: Color.fromARGB(255, 236, 238, 237),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 1));

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } on FirebaseAuthException catch (e) {
                      String msg = "Login failed";

                      if (e.code == 'user-not-found') msg = "No user found";
                      if (e.code == 'wrong-password') msg = "Wrong password";
                      if (e.code == 'invalid-email') msg = "Invalid email";

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(msg)));
                    } finally {
                      if (mounted) setState(() => isLoading = false);
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: textWhite)
                      : const Text("Login", style: TextStyle(color: textWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration inputStyle(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: textWhite),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: maroon),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: maroon, width: 2),
    ),
  );
}

// ======================================================================
//  HOME PAGE
// ======================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
          (_) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HearUs", style: TextStyle(color: maroon)),
        backgroundColor: bgBlack,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: maroon),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Feature",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textWhite,
              ),
            ),
            const SizedBox(height: 60),

            _featureButton(
              context,
              icon: Icons.volume_up_rounded,
              title: "Gesture Translator",
              subtitle: "Text → Speech (Multilingual)",
              page: const TTSGlassUI(),
            ),

            const SizedBox(height: 40),

            _featureButton(
              context,
              icon: Icons.mic_rounded,
              title: "Speech Recognition",
              subtitle: "Speech → Text (Multilingual)",
              page: const AISpeechHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: maroon.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: maroon.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 48, color: maroon),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: textWhite.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: maroon),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
//  SPEECH → TEXT PAGE (your original code)
// ======================================================================
class AISpeechHome extends StatefulWidget {
  const AISpeechHome({super.key});

  @override
  State<AISpeechHome> createState() => _AISpeechHomeState();
}

class _AISpeechHomeState extends State<AISpeechHome>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Tap to start speaking";
  String _selectedLanguage = 'en_IN';

  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _speech.stop();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "done") setState(() => _isListening = false);
        },
        onError: (error) {
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: _selectedLanguage,
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Widget _langChip(String label, String code) {
    bool active = _selectedLanguage == code;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = code),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Speech Recognition",
          style: TextStyle(color: maroon),
        ),
        backgroundColor: bgBlack,
      ),
      body: Stack(
        children: [
          const ParticleBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ISL AI Voice",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Real-Time Speech Recognition",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _langChip("EN", "en_IN"),
                    _langChip("தமிழ்", "ta_IN"),
                    _langChip("हिन्दी", "hi_IN"),
                  ],
                ),
                const SizedBox(height: 35),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      height: 220,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              _text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _isListening
                                  ? "Listening..."
                                  : "Tap mic to start",
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Fake waveform
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: _isListening ? 20 + (i * 6) : 8,
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.redAccent : Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    return GestureDetector(
                      onTap: _listen,
                      child: Container(
                        width: 85 + (_pulse.value * 10),
                        height: 85 + (_pulse.value * 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening ? Colors.red : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: _isListening
                                  ? Colors.redAccent
                                  : Colors.white24,
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: Colors.black,
                          size: 34,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
//  TEXT → SPEECH PAGE (your original code)
// ======================================================================
class TTSGlassUI extends StatefulWidget {
  const TTSGlassUI({super.key});

  @override
  State<TTSGlassUI> createState() => _TTSGlassUIState();
}

class _TTSGlassUIState extends State<TTSGlassUI>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();
  final TextEditingController controller = TextEditingController();

  BluetoothDevice? glove;
  BluetoothCharacteristic? gestureChar;

  String selectedLang = "en-US";
  List<dynamic> voices = [];
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    initTTS();
    connectGlove();
  }

  Future<void> initTTS() async {
    voices = await flutterTts.getVoices;
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  void connectGlove() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.name == "ISL_GLOVE") {
          glove = r.device;
          await FlutterBluePlus.stopScan();
          await glove!.connect();

          var services = await glove!.discoverServices();

          for (var s in services) {
            if (s.uuid.toString().contains("1234")) {
              gestureChar = s.characteristics.first;
              await gestureChar!.setNotifyValue(true);

              gestureChar!.value.listen((value) {
                String gesture = String.fromCharCodes(value);

                setState(() {
                  controller.text = gesture;
                });

                speak(); // auto TTS
              });
            }
          }
        }
      }
    });
  }

  Future<void> speak() async {
    if (controller.text.isEmpty) return;

    String input = controller.text;
    String targetLang = selectedLang.split("-")[0];

    final translation = await translator.translate(input, to: targetLang);
    String finalText = translation.text;

    final voice = voices.firstWhere(
      (v) => v["locale"] == selectedLang,
      orElse: () => null,
    );

    if (voice != null) {
      await flutterTts.setVoice({
        "name": voice["name"],
        "locale": voice["locale"],
      });
    }

    await flutterTts.speak(finalText);
  }

  Widget langChip(String label, String code) {
    bool active = selectedLang == code;
    return GestureDetector(
      onTap: () => setState(() => selectedLang = code),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Gesture Translator",
          style: TextStyle(color: maroon),
        ),
        backgroundColor: bgBlack,
      ),
      body: Stack(
        children: [
          const ParticleBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ISL AI Voice",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Multilingual Text to Speech",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    langChip("EN", "en-US"),
                    langChip("தமிழ்", "ta-IN"),
                    langChip("हिन्दी", "hi-IN"),
                  ],
                ),
                const SizedBox(height: 35),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      height: 220,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: controller,
                        maxLines: 6,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type in English...",
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    return GestureDetector(
                      onTap: speak,
                      child: Container(
                        width: 85 + (_pulse.value * 10),
                        height: 85 + (_pulse.value * 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white24,
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 34,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
//  PARTICLE BACKGROUND (used in both STT & TTS)
// ======================================================================
class ParticleBackground extends StatelessWidget {
  const ParticleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ParticlePainter(), size: Size.infinite);
  }
}

class ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white10;
    for (int i = 0; i < 100; i++) {
      final x = (i * 97) % size.width;
      final y = (i * 151) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Future<Map<String, dynamic>?> fetchUserProfile() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .get();

  return doc.data();
}

Future<void> saveGestureLog(String gestureText) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection("gesture_logs")
      .add({
        "gestureText": gestureText,
        "source": "esp32_glove",
        "createdAt": FieldValue.serverTimestamp(),
      });
}
