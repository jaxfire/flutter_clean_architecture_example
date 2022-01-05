import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  await GetIt.instance.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
