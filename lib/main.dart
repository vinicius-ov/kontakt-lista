import 'package:flutter/material.dart';
import 'package:kontaktlista/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontakt Lista',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 136, 109, 62)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Contatos'),
    );
  }
}
