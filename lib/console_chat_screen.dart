import 'dart:convert';

import 'package:flutter/material.dart';
import 'message_widget.dart';
import 'app_constants.dart';
import 'start_screen.dart';
import 'websocket_service.dart';
import 'client_data.dart';
import 'message.dart';

const String _delimiter = ">>>";
class ConsoleChatScreen extends StatefulWidget {
  final ClientData clientData;

  const ConsoleChatScreen({Key? key, required this.clientData}) : super(key: key);

  @override
  _ConsoleChatScreenState createState() => _ConsoleChatScreenState();
}

class _ConsoleChatScreenState extends State<ConsoleChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TcpSocketService _tcpService;
  List<Message> messages = [];

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
      onConnect: () {
        var json = widget.clientData.toJson().toString();
        print(json);
        _tcpService.send(json);
      },
      onListen: (data) {
        setState(() {
          Message message = Message.fromRawJson(utf8.decode(data));
          messages.add(message);
        });
      },
      onConnectError: (){
        _showConnectionErrorDialog(context);
      },
      onSocketClosed: () {
        _showConnectionErrorDialog(context);
      }
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
    _tcpService.send(text);
    setState(() {
      Message message = new Message(
        nickname: widget.clientData.nickname,
        color: widget.clientData.nicknameColor,
        text: text,
        type: 2,
      );
      messages.add(message);
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
                      var message = messages[realIndex];
                      if (message.type != 0 && message.type != 1) {
                        final nickname = messages[realIndex].nickname;
                        _controller.text = "@$nickname ";
                      }
                    },
                    child: MessageWidget(
                      message: messages[realIndex],
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

void _showConnectionErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text('Ошибка подключения'),
      content: Text('Не удалось подключиться или соединение было разорвано.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartScreen(),
              ),
            );
          },
          child: Text('ОК'),
        ),
      ],
    ),
  );
}