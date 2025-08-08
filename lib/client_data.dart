class ClientData {
  final String nickname;
  final String nicknameColor;

  ClientData({required this.nickname, required this.nicknameColor});

  Map<String, String> toJson() => {
        '\"nickname\"': "\"$nickname\"",
        '\"color\"': "\"$nicknameColor\"",
      };

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        nickname: json['nickname'],
        nicknameColor: json['nicknameColor'],
      );
}
