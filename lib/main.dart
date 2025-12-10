import 'package:flutter/material.dart';
import 'package:jerry/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JerryApp());
}

class JerryApp extends StatelessWidget {
  const JerryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jerry - AI Dev Assistant',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
    );
  }
}
