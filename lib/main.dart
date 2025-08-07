import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'portrait_lock.dart';
import 'app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPortraitOrientation();
  runApp(ConsoleChatApp());
}

class ConsoleChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Консольный чат',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kPrimaryBackgroundColor,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: kFontFamily, fontSize: kDefaultFontSize)),
      ),
      home: StartScreen(),
    );
  }
}
