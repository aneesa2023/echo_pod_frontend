import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String topicId;
  final void Function(String message) onMessage;
  final void Function()? onDone;
  WebSocketChannel? _channel;

  WebSocketManager(
      {required this.topicId, required this.onMessage, this.onDone});

  void connect() {
    final uri = Uri.parse(
        'wss://guf5dhj3gb.execute-api.us-east-1.amazonaws.com/dev?topic_id=$topicId');
    _channel = WebSocketChannel.connect(uri);

    int messageCount = 0;

    _channel!.stream.listen((event) {
      messageCount++;
      onMessage(event);
      if (messageCount >= 3) {
        disconnect();
        if (onDone != null) onDone!();
      }
    }, onError: (error) {
      print('WebSocket Error: \$error');
    }, onDone: () {
      print('WebSocket closed.');
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
