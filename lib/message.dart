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

  factory Message.fromRawJson(String rawJson) {
    var json = jsonDecode(rawJson);
    var m = Message(
      nickname: json['nickname'],
      color: json['color'],
      text: json['text'],
      type: json['type'],
    );
    print(m.nickname);
    return m;
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