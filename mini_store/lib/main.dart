import 'package:flutter/material.dart';
import 'presentation/main_page.dart';

void main() {
  runApp(const TiendaGoApp());
}

class TiendaGoApp extends StatelessWidget {
  const TiendaGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniStore',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
