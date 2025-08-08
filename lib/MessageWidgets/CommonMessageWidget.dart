import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../color_parser.dart';
import '../message.dart';

class CommonMessageWidget extends StatelessWidget {
  final Message message;

  const CommonMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
        children: [
          TextSpan(
              text: "[Время]",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: kAppDefaultFontSize,
                fontFamily: kFontFamily)
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
          TextSpan(
            text: " >>> ",
            style: const TextStyle(
              color: Colors.white38,
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: message.text,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
            ),
          )
        ]
    ));
  }

}