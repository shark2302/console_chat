import 'package:flutter/material.dart';

class ClientData {
  final String nickname;
  final Color nicknameColor;

  ClientData({required this.nickname, required this.nicknameColor});

  Map<String, String> toJson() => {
        '\"nickname\"': "\"$nickname\"",
        '\"color\"': "\"red\"",
      };

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        nickname: json['nickname'],
        nicknameColor: Color(json['nicknameColor']),
      );
}
