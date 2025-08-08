import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class TcpSocketService {
  late Socket _socket;
  final String host;
  final int port;
  final void Function(List<int> data)? onListen;

  TcpSocketService({required this.host, required this.port, this.onListen});

  Future<void> connect() async {
    try {
      _socket = await Socket.connect(host, port);
      print('Connected to: \\${_socket.remoteAddress.address}:\\${_socket.remotePort}');
      _socket.listen(
        (data) {
          print('Received: \\${utf8.decode(data)}');
          if (onListen != null)
            onListen!(data); // вызов функций
        },
        onError: (error) {
          print('Socket error: \\${error}');
          _socket.destroy();
        },
        onDone: () {
          print('Socket closed');
        },
      );
    } catch (e) {
      print('Unable to connect: \\${e}');
    }
  }

  void send(String message) {
    _socket.write(message);
  }

  void disconnect() {
    _socket.close();
  }
}
