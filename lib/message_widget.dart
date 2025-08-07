import 'package:flutter/material.dart';
import 'app_constants.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String nickname;
  final Color userColor;
  final String delimiter;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.nickname,
    required this.userColor,
    required this.delimiter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = message.split(delimiter);
    final sender = parts[0];
    final text = parts.length > 1 ? parts.sublist(1).join(delimiter) : '';
    Color nicknameColor;
    if (sender == 'Бот') {
      nicknameColor = Colors.blue;
    } else {
      nicknameColor = userColor;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sender,
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
            text,
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
