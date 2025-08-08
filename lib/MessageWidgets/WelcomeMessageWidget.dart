import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../color_parser.dart';
import '../message.dart';

class WelcomeMessageWidget extends StatelessWidget {
  final Message message;

  const WelcomeMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
        children: [
          TextSpan(
            text: "${message.text}, ",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
            ),
          ),
          TextSpan(
            text: message.nickname,
            style: TextStyle(
              color: ColorParser.fromString(message.color),
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
    ));
  }

}
