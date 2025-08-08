import 'package:console_chat/MessageWidgets/CommonMessageWidget.dart';
import 'package:flutter/material.dart';
import 'MessageWidgets/JoinMessageWidget.dart';
import 'MessageWidgets/WelcomeMessageWidget.dart';
import 'app_constants.dart';
import 'message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final String delimiter;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.delimiter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.type == 0) {
      return JoinMessageWidget(message: message);
    }
    if (message.type == 1) {
      return WelcomeMessageWidget(message: message);
    }
    if(message.type == 2) {
      return CommonMessageWidget(message: message);
    }

    Color nicknameColor;

    nicknameColor = Colors.cyan;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname,
          style: TextStyle(
            color: nicknameColor,
            fontSize: kAppDefaultFontSize,
            fontFamily: kFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          delimiter,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: kAppDefaultFontSize,
            fontFamily: kFontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
