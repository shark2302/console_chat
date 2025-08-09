import 'dart:convert';

class Message {
  String nickname;
  String color;
  String text;
  int type;

  Message({
    required this.nickname,
    required this.color,
    required this.text,
    required this.type,
  });

  static List<dynamic> tryParseJson(String jsonString) {
    Message m;
    try {
      m = Message.fromRawJson(jsonString);
      return [true, m];
    }
    catch (e) {
      return [false, null];
    }
  }

  factory Message.fromRawJson(String rawJson) {
    return Message.fromJson(jsonDecode(rawJson));
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      nickname: json['nickname'],
      color: json['color'],
      text: json['text'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'color': color,
      'text': text,
      'type': type,
    };
  }
}