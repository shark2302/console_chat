import 'dart:convert';

import 'package:console_chat/color_parser.dart';
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

  const ConsoleChatScreen({Key? key, required this.clientData})
      : super(key: key);

  @override
  _ConsoleChatScreenState createState() => _ConsoleChatScreenState();
}

class _ConsoleChatScreenState extends State<ConsoleChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TcpSocketService _tcpService;
  List<Message> messages = [];
  List<ClientData> users = [];
  void Function(void Function())? _usersModalSetState;

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
          _tcpService.send(json);
        },
        onListen: (data) {
          setState(() {
           _handleMessage(data);
           _scrollController.animateTo(
             0,
             duration: Duration(milliseconds: 300),
             curve: Curves.easeOut,
           );
          });
          if (_usersModalSetState != null) {
            _usersModalSetState!(() {});
          }
        },
        onConnectError: () {
          _showConnectionErrorDialog(context);
        },
        onSocketClosed: () {
          _showConnectionErrorDialog(context);
        });
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
      if (!text.startsWith("@")) {
        Message message = new Message(
            nickname: widget.clientData.nickname,
            color: widget.clientData.nicknameColor,
            text: text,
            type: 2);
        messages.add(message);
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _handleMessage(List<int> data) {
    String allData = utf8.decode(data);
    List<String> parts = allData.split("\n");
    for (var part in parts) {
      print(part);
      if (part
          .trim()
          .isEmpty) continue;
      var parse = Message.tryParseJson(part);
      if (parse[0]) {
        Message message = parse[1];
        if (message.type == 1) {
          users = parseClientDataList(message.text);
        }
        else if (message.type == 0) {
          users.add(ClientData(
              nickname: message.nickname, nicknameColor: message.color));
        }
        else if (message.type == 5) {
          users.removeWhere((user) => user.nickname == message.nickname);
        }
        messages.add(message);
      }
      else {
        messages.addAll(parseMessageList(part));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Image.asset(
          'assets/background.jpeg', // путь к вашей картинке
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryContainerColor,
          actions: [
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _showUsersList();
                })
          ],
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
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 4, bottom: 4),
                    child: GestureDetector(
                      onTap: () {
                        var message = messages[realIndex];
                        if (message.type != 0 && message.type != 1) {
                          final nickname = messages[realIndex].nickname;
                          if (nickname != widget.clientData.nickname) {
                            _controller.text = "@$nickname ";
                          }
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
                      style: TextStyle(
                          color: kPrimaryTextColor, fontFamily: kFontFamily),
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        hintStyle: TextStyle(
                            color: Colors.white30, fontFamily: kFontFamily),
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
      )
    ]);
  }

  void _showUsersList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _usersModalSetState = setModalState;
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: users.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Список пользователей:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    final user = users[index - 2];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        user.nickname,
                        style: TextStyle(
                          color: ColorParser.fromString(user.nicknameColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
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


List<ClientData> parseClientDataList(String jsonString) {
  final List<dynamic> decoded = jsonDecode(jsonString);
  print(decoded);
  return decoded.map((e) => ClientData.fromRawJson(e)).toList();
}

List<Message> parseMessageList(String jsonString) {
  final decoded = jsonDecode(jsonString) as List;
  return decoded.map((e) => Message.fromRawJson(e)).toList();
}



