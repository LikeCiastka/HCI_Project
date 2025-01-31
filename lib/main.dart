import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'ui/home_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: FlexThemeData.light(
        scheme: FlexScheme.mandyRed,
      ),
      darkTheme: FlexThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
