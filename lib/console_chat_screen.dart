import 'package:flutter/material.dart';
import 'message_widget.dart';
import 'app_constants.dart';

const String _delimiter = ">>>";
class ConsoleChatScreen extends StatefulWidget {
  final String nickname;
  final Color color;

  ConsoleChatScreen({required this.nickname, required this.color});

  @override
  _ConsoleChatScreenState createState() => _ConsoleChatScreenState();
}

class _ConsoleChatScreenState extends State<ConsoleChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> messages = [];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add('${widget.nickname}${_delimiter}${_controller.text}');
      messages.add('Бот${_delimiter}${_getBotResponse(text)}');
    });

    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  String _getBotResponse(String message) {
    message = message.toLowerCase();
    if (message.contains('привет')) return 'Привет! Как дела?';
    if (message.contains('как дела')) return 'Всё отлично!';
    if (message.contains('пока')) return 'Пока!';
    return 'Не понял.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Консольный чат', style: TextStyle(fontSize: kDefaultFontSize, fontFamily: kFontFamily)),
        backgroundColor: kPrimaryContainerColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final realIndex = messages.length - 1 - index;
                return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                  child: GestureDetector(
                    onTap: () {
                      final nickname = messages[realIndex].split(_delimiter)[0];
                      _controller.text = "@$nickname ";
                    },
                    child: MessageWidget(
                      message: messages[realIndex],
                      nickname: widget.nickname,
                      userColor: widget.color,
                      delimiter: _delimiter,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: kPrimaryContainerColor,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: kPrimaryTextColor, fontFamily: kFontFamily),
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      hintStyle: TextStyle(color: Colors.white30, fontFamily: kFontFamily),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: kPrimaryTextColor),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}