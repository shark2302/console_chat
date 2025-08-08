import 'package:flutter/material.dart';
import 'console_chat_screen.dart';
import 'app_constants.dart';
import 'client_data.dart';
import 'color_parser.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String _color = "white";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: kPrimaryContainerColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nicknameController,
                    style: TextStyle(color: kPrimaryTextColor, fontFamily: kFontFamily),
                    decoration: InputDecoration(
                      labelText: 'Ваш никнейм',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите никнейм';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Выберите цвет ника:', style: TextStyle(color: Colors.white60, fontFamily: kFontFamily)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ColorParser.getSupportedColors().map((color) => _buildColorButton(color)).toList(),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        textStyle: TextStyle(fontFamily: kFontFamily, fontSize: 18),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final clientData = ClientData(nickname: _nicknameController.text, nicknameColor: _color);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsoleChatScreen(clientData: clientData),
                            ),
                          );
                        }
                      },
                      child: Text('Открыть консольный чат'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() {
        _color = ColorParser.toStringName(color);
      }),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: _color == ColorParser.toStringName(color)
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              )
            : null,
      ),
    );
  }
}