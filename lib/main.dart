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
  final double _panelWidth = 150;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  String _selectedData = '';

  final List<String> data = ["sample1", "sample2"];

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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  void _onButtonPressed(String text) {
    setState(() {
      _selectedData = text;
    });
    if (!_controller.isCompleted) {
      _controller.forward();
    }
  }
  
  void _onClosePressed() {
    if (_controller.isCompleted) {
      _controller.reverse();
      setState(() {
        _selectedData = '';
      });
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
          // 元々のコンテンツ。右の余白を_controllerの値に合わせて調整
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.only(right: _controller.value * _panelWidth),
                child: child,
              );
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () => _onButtonPressed(item),
                      child: Text(item),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // スライドインするパネル
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: _panelWidth,
                height: double.infinity,
                color: Colors.blueAccent,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _onClosePressed,
                    ),
                    Expanded(
                      child: _selectedData.isNotEmpty
                          ? Image.asset(
                              'assets/images/$_selectedData.png',
                              fit: BoxFit.contain,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}