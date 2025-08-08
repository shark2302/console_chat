import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class TcpSocketService {
  late Socket _socket;
  final String host;
  final int port;
  final void Function(List<int> data)? onListen;
  final void Function()? onConnect;
  final void Function()? onConnectError;
  final void Function()? onSocketClosed;

  TcpSocketService({required this.host, required this.port, this.onListen, this.onConnect, this.onConnectError, this.onSocketClosed});

  Future<void> connect() async {
    try {
      _socket = await Socket.connect(host, port);
      print('Connected to: \\${_socket.remoteAddress.address}:\\${_socket.remotePort}');
      if (onConnect != null)
        onConnect!();
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
          if (onSocketClosed != null){
            onSocketClosed!();
          }
          print('Socket closed');
        },
      );
    } catch (e) {
      print('Unable to connect: \\${e}');
      if (onConnectError != null) {
        onConnectError!();
      }
    }
  }

  void send(String message) {
    _socket.write(message);
  }

  void disconnect() {
    _socket.close();
  }
}
