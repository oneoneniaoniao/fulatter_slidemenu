import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide In Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SlideInExample(),
    );
  }
}

class SlideInExample extends StatefulWidget {
  const SlideInExample({super.key});

  @override
  State<SlideInExample> createState() => _SlideInExampleState();
}

class _SlideInExampleState extends State<SlideInExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onButtonPressed(String text) {
    setState(() {
      _displayText = text;
    });
    // 表示済みであれば一度リセット（右へ戻す）
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse().then((_) {
        _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slide In Example")),
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _onButtonPressed("1"),
                  child: const Text("1"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _onButtonPressed("2"),
                  child: const Text("2"),
                ),
              ],
            ),
          ),
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                height: double.infinity,
                color: Colors.blueAccent,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    _displayText,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
