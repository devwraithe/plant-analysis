import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "AIzaSyCnuSoAywPxinSPDs7Mz9KnFFmfs9veZK4";

  String? aiResponse;

  void _testGenAI() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    const prompt =
        "Give a brief analysis on Wolfsbane and it's danger to cats and dogs";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    setState(() => aiResponse = response.text);
  }

  @override
  void initState() {
    super.initState();
    _testGenAI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(aiResponse ?? "Not generated"),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text("Regenerate"),
              onPressed: () => _testGenAI(),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
