import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const SpeechApp());
}

class SpeechApp extends StatelessWidget {
  const SpeechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechHome(),
    );
  }
}

class SpeechHome extends StatefulWidget {
  const SpeechHome({super.key});

  @override
  State<SpeechHome> createState() => _SpeechHomeState();
}

class _SpeechHomeState extends State<SpeechHome>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Tap the mic and start speaking";
  String? _selectedLanguage;

  late AnimationController _micAnimation;

  final Map<String, String> _languages = {
    'en_IN': 'English',
    'ta_IN': 'Tamil',
    'hi_IN': 'Hindi',
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _micAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _micAnimation.repeat(reverse: true);

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
      _micAnimation.stop();
      _micAnimation.reset();
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _micAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: _selectedLanguage == null ? _languageMenu() : _speechScreen(),
      ),
    );
  }

  // ---------------- LANGUAGE MENU ----------------
  Widget _languageMenu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select a language",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),

          ..._languages.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(220, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedLanguage = entry.key;
                  });
                },
                child: Text(entry.value, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SPEECH SCREEN ----------------
  Widget _speechScreen() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Text(
            "The language selected is ${_languages[_selectedLanguage]}",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),

          TextButton(
            onPressed: () {
              setState(() {
                _selectedLanguage = null;
                _text = "Tap the mic and start speaking";
              });
            },
            child: const Text(
              "Change language",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),

          const SizedBox(height: 30),

          // Speech output box
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Mic button
          ScaleTransition(
            scale: _micAnimation,
            child: GestureDetector(
              onTap: _listen,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.black,
                  size: 36,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            _isListening ? "Tap to stop listening" : "Tap to start listening",
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
