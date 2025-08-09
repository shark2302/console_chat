import 'package:flutter/material.dart';

import '../app_constants.dart';
import '../message.dart';

class PrivateMessageWidget extends StatelessWidget {
  final Message message;
  const PrivateMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
            message.text,
            style: const TextStyle(
              color: Colors.red,
              fontSize: kAppDefaultFontSize,
              fontFamily: kFontFamily,
            ),
          );
  }

}