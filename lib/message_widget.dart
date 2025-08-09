import 'package:console_chat/MessageWidgets/CommonMessageWidget.dart';
import 'package:flutter/material.dart';
import 'MessageWidgets/ErrorMessageWidget.dart';
import 'MessageWidgets/JoinMessageWidget.dart';
import 'MessageWidgets/PrivateMessageWidget.dart';
import 'MessageWidgets/WelcomeMessageWidget.dart';
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
    if(message.type == 3) {
      return PrivateMessageWidget(message: message);
    }
    if(message.type == 4) {
      return ErrorMessageWidget(message: message);
    }

    return Container();
  }
}
