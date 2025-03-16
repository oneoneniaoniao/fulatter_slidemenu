import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Riverpod の StateProvider で選択文字列を管理
final selectedDataProvider = StateProvider<String>((ref) => '');

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide In Demo with Hooks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SlideInExample(),
    );
  }
}

class SlideInExample extends HookConsumerWidget {
  const SlideInExample({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double panelWidth = 150;

    // アニメーションコントローラーを hooks で生成
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    // Tween によるスライドアニメーション
    final slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    // Riverpod で管理している選択文字列
    final selectedData = ref.watch(selectedDataProvider);
    
    // ボタン押下時のハンドラ
    void onButtonPressed(String text) {
      ref.read(selectedDataProvider.notifier).state = text;
      if (controller.status != AnimationStatus.completed) {
        controller.forward();
      }
    }
    
    // メインコンテンツ（ボタン群）
    final mainContent = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonItem(
            text: "sample1",
            onPressed: () => onButtonPressed("sample1"),
          ),
          const SizedBox(width: 20),
          ButtonItem(
            text: "sample2",
            onPressed: () => onButtonPressed("sample2"),
          ),
        ],
      ),
    );
    
    return Scaffold(
      appBar: AppBar(title: const Text("Slide In Example")),
      body: Stack(
        children: [
          // ボタン群に右側余白を与える（アニメーションに合わせて広がる余白）
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.only(right: controller.value * panelWidth),
                child: child,
              );
            },
            child: mainContent,
          ),
          // スライドインするパネル
          SlideTransition(
            position: slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: panelWidth,
                height: double.infinity,
                color: Colors.blueAccent,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        if (controller.status == AnimationStatus.completed) {
                          controller.reverse();
                          ref.read(selectedDataProvider.notifier).state = '';
                        }
                      },
                    ),
                    Expanded(
                      child: selectedData.isNotEmpty
                          ? Image.asset(
                              'assets/images/$selectedData.png',
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

class ButtonItem extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const ButtonItem({super.key, required this.text, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}