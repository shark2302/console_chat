import 'package:flutter/material.dart';

import '../app_constants.dart';
import '../message.dart';

class JoinMessageWidget extends StatelessWidget {
  final Message message;

  const JoinMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
        message.text,
        style: const TextStyle(
          color: Colors.amber,
          fontSize: kAppDefaultFontSize,
          fontFamily: kFontFamily,
        ),
      );
  }

}