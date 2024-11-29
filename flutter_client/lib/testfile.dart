import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Screen Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _messageFocusNode = FocusNode();
  late EventSourceSubscription _eventSource;
  final bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    // Initialize event source
    _eventSource =
        EventSourceSubscription('http://localhost:9001/api/chat/events');

    // Listen to messages
    _eventSource.messages.listen((message) {
      setState(() {
        _messages.add(ChatMessage(
          message: message['message'],
          username: message['username'],
        ));
      });
    });

    // Start subscription
    _eventSource.subscribe();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      message: _messageController.text,
      username: 'User', // Replace with actual user identification
    );

    try {
      final response = await http.post(
        Uri.parse('http://localhost:9001/api/chat/message'),
        body: {
          'message': message.message,
          'username': message.username,
          'room': "OpenChat",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages.add(message);
          _messageController.clear();
        });

        // Maintain focus on message input
        _messageFocusNode.requestFocus();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _eventSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Chat'),
            const Spacer(),
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return MessageBubble(message: message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final String username;

  bool isMe = false;

  ChatMessage({
    required this.message,
    required this.username,
  });
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: message.isMe
                ? const Radius.circular(15)
                : const Radius.circular(0),
            bottomRight: message.isMe
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message.message,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 5),
            const Text(
              'time here',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventSourceSubscription {
  final String uri;
  late StreamController<Map<String, dynamic>> _messageController;
  StreamSubscription? _subscription;
  int _retryTime = 1;
  Timer? _reconnectTimer;

  EventSourceSubscription(this.uri) {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  void subscribe() {
    _connect();
  }

  void _connect() {
    _cancelCurrentSubscription();

    final request = http.Request('GET', Uri.parse(uri));
    http.Client().send(request).then((streamedResponse) {
      _subscription = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            _handleEvent,
            onDone: _handleConnectionError,
            onError: (_) => _handleConnectionError(),
          );
    }).catchError((error) {
      _handleConnectionError();
    });
  }

  void _handleEvent(String event) {
    try {
      final parsedData = jsonDecode(event);

      if (parsedData is Map &&
          parsedData.containsKey('content') &&
          parsedData.containsKey('sender')) {
        _messageController.add(Map<String, dynamic>.from(parsedData));
        _resetRetryTime();
      }
    } catch (e) {
      print('Error parsing event: $e');
    }
  }

  void _handleConnectionError() {
    _cancelCurrentSubscription();

    final timeout = _retryTime;
    _retryTime = _calculateNextRetryTime();

    print('Connection lost. Attempting to reconnect in ${timeout}s');

    _reconnectTimer = Timer(Duration(seconds: timeout), _connect);
  }

  int _calculateNextRetryTime() {
    return _retryTime == 1 ? 1 : (_retryTime * 2).clamp(1, 64);
  }

  void _resetRetryTime() {
    _retryTime = 1;
  }

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  void dispose() {
    _cancelCurrentSubscription();
    _messageController.close();
  }

  void _cancelCurrentSubscription() {
    _subscription?.cancel();
    _reconnectTimer?.cancel();
  }
}
