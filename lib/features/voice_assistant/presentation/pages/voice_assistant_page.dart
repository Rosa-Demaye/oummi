import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../theme/app_theme.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  State<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _text = "Appuyez sur le micro pour poser votre question (Français / Arabe Tchadien)";
  String _response = "";
  String _language = 'fr-FR';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _processQuery(_text);
            }
          }),
          listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.confirmation,
            localeId: _language,
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _processQuery(String query) {
    String reply = "";
    if (query.toLowerCase().contains("douleur")) {
      reply = "Si vous ressentez une douleur intense, veuillez consulter un médecin immédiatement.";
    } else if (query.toLowerCase().contains("manger")) {
      reply = "Privilégiez les aliments riches en fer et en acide folique comme les légumes verts.";
    } else {
      reply = "Je suis OUMI, votre assistante. Je n'ai pas bien compris, mais je suis là pour vous aider.";
    }

    setState(() {
      _response = reply;
    });
    _speak(reply);
  }

  void _speak(String text) async {
    await _tts.setLanguage(_language);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assistant Vocal OUMI'),
        backgroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: _language,
            items: const [
              DropdownMenuItem(value: 'fr-FR', child: Text('FR ')),
              DropdownMenuItem(value: 'ar-SA', child: Text('AR ')),
            ],
            onChanged: (val) {
              setState(() => _language = val!);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 40),
              if (_response.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text("Réponse de OUMI:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 10),
                      Text(_response, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              const SizedBox(height: 60),
              GestureDetector(
                onLongPressStart: (_) => _listen(),
                onLongPressEnd: (_) => _listen(),
                child: FloatingActionButton.large(
                  onPressed: () {},
                  backgroundColor: _isListening ? Colors.red : AppTheme.primaryColor,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isListening ? "Je vous écoute..." : "Maintenez pour parler",
                style: TextStyle(color: _isListening ? Colors.red : Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
