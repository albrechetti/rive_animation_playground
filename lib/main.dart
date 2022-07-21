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
      debugShowCheckedModeBanner: false,
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

  //Setup artboard
  void moodAnimationSetup() {
    rootBundle.load('../assets/animations/mood_face.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(artboard, 'mood_state');
      if (controller != null) {
        artboard.addController(controller);
        moodValue = controller.findInput('mood_value');
      }
      setState(() => _riveArtboard = artboard);
    });
  }

  @override
  void initState() {
    super.initState();
    moodAnimationSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1D39),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _riveArtboard == null
                ? const SizedBox()
                : SizedBox(
                    width: 500,
                    height: 500,
                    child: Rive(
                      artboard: _riveArtboard!,
                      fit: BoxFit.contain,
                      useArtboardSize: false,
                    ),
                  ),
            Slider(
              activeColor: const Color(0xff35EBF1),
              inactiveColor: const Color(0xff2F418D),
              value: moodValue!.value,
              min: 0,
              max: 100,
              onChanged: (value) {
                moodValue!.value = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
