import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mood Animation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Artboard? _riveArtboard;
  SMIInput<double>? moodValue;
  late StateMachineController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('../assets/animations/mood_face.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        moodValue = controller.findInput('Mood Value');
      }
      setState(() => _riveArtboard = artboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _riveArtboard == null
                  ? const SizedBox()
                  : SizedBox(
                      width: 300,
                      height: 300,
                      child: Rive(
                        artboard: _riveArtboard!,
                        fit: BoxFit.contain,
                        useArtboardSize: false,
                      ),
                    ),
              Slider(
                  value: moodValue!.value,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    moodValue!.value = value;
                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
