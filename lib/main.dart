import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperBabyNameGenerator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  late String userPromt;
  String generatedNames = '';

  Future<void> _sendPromt() async {
    userPromt = myController.text;
    var result =
        await http.post(Uri.parse("https://api.openai.com/v1/completions"),
            headers: {
              "Authorization": "Bearer <you're secret key>",
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "prompt": userPromt,
              "model":
                  "babbage:ft-personal:custom-model-name-2022-04-14-16-34-19",
              "max_tokens": 16,  // answering limit
              "temperature": 0.4, // how creative to you want it to be.
            }));

    var body = jsonDecode(result.body);
    setState(() {
      generatedNames = body["choices"][0]["text"];
      myController.clear();
      userPromt = myController.text;
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("baby name generator"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            generatedNames.characters.string,
                            style: const TextStyle(
                                fontSize: 20, fontStyle: FontStyle.italic),
                          )))),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLength: 120,
                          maxLines: 2,
                          controller: myController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ask for some  baby names',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: _sendPromt,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.blueGrey,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
