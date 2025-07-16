import 'package:flutter/material.dart';
import 'presentation/auth/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
