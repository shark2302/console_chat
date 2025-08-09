import 'dart:convert';

class ClientData {
  final String nickname;
  final String nicknameColor;

  ClientData({required this.nickname, required this.nicknameColor});

  Map<String, String> toJson() => {
        '\"nickname\"': "\"$nickname\"",
        '\"color\"': "\"$nicknameColor\"",
      };

  factory ClientData.fromRawJson(String rawJson) {
    var json = jsonDecode(rawJson);
    var m = ClientData(
      nickname: json['nickname'],
      nicknameColor: json['color'],
    );
    return m;
  }
}
