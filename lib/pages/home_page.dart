import 'package:flutter/material.dart';
import 'editor_page.dart';
import '../services/ai_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController promptController = TextEditingController();
  final AIService aiService = AIService();
  stt.SpeechToText speech = stt.SpeechToText();
  bool listening = false;

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => listening = true);
      speech.listen(onResult: (val) {
        setState(() {
          promptController.text = val.recognizedWords;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Speech not available')));
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => listening = false);
  }

  Future<void> generate() async {
    final prompt = promptController.text.trim();
    if (prompt.isEmpty) return;
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
    try {
      final files = await aiService.generateProject(prompt);
      if (!mounted) return;
      Navigator.pop(context); // close loading
      Navigator.push(context, MaterialPageRoute(builder: (_) => EditorPage(files: files, projectName: prompt)));
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    }
  }

  void openSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => aiService.settingsPage(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jerry - AI Dev Assistant'),
        actions: [IconButton(onPressed: openSettings, icon: const Icon(Icons.settings))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(
            controller: promptController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the website or code (e.g., "portfolio site with dark theme")',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            ElevatedButton.icon(onPressed: generate, icon: const Icon(Icons.code), label: const Text('Generate')),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: listening ? stopListening : startListening,
              icon: Icon(listening ? Icons.mic_off : Icons.mic),
              label: Text(listening ? 'Stop' : 'Voice'),
            ),
          ]),
        ]),
      ),
    );
  }
}
