import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  String getMilestoneMessage() {
    if (value <= 12) return "You're a child!";
    if (value <= 19) return "Teenager time!";
    if (value <= 30) return "You're a young adult!";
    if (value <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color getBackgroundColor() {
    if (value <= 12) return Colors.lightBlue;
    if (value <= 19) return Colors.lightGreen;
    if (value <= 30) return Colors.yellow;
    if (value <= 50) return Colors.orange;
    return Colors.grey;
  }

  void setAge(int newAge) {
  value = newAge;
  notifyListeners();
  }

  Color getProgressColor() {
    if (value <= 33) return Colors.green;
    if (value <= 67) return Colors.yellow;
    return Colors.red;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          backgroundColor: counter.getBackgroundColor(),
          appBar: AppBar(
            title: const Text('Age Counter'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I am ${counter.value} years old',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  counter.getMilestoneMessage(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: counter.value / 99, // Normalize age (0 to 1)
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(counter.getProgressColor()),
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: counter.value.toString(),
                  onChanged: (newValue) {
                    counter.setAge(newValue.toInt());
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => counter.increment(),
                  child: const Text('Increase Age'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => counter.decrement(),
                  child: const Text('Decrease Age'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}