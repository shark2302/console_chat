import 'dart:convert';

import 'package:flutter/material.dart';
import 'message_widget.dart';
import 'app_constants.dart';
import 'websocket_service.dart';

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

  late TcpSocketService _tcpService;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    super.initState();
    _tcpService = TcpSocketService(
      host: '10.0.2.2',
      port: 12345,
      onListen: (data) {
        setState(() {
          messages.add('Сервер$_delimiter${utf8.decode(data)}');
        });
      },
    );
    await _tcpService.connect();
  }

  @override
  void dispose() {
    _tcpService.disconnect();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _tcpService.send(utf8.decode(utf8.encode(text)));
    setState(() {
      messages.add('${widget.nickname}$_delimiter$text');
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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