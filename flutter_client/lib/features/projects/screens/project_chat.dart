// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_client/common/constants/app_colors.dart';
import 'package:flutter_client/common/constants/app_images.dart';
import 'package:flutter_client/features/auth/services/auth_services.dart';
import 'package:flutter_client/features/home/provider/post_provider.dart';
import 'package:flutter_client/features/projects/models/project_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProjectChatting extends StatefulWidget {
  const ProjectChatting({super.key, required this.model});

  @override
  State<ProjectChatting> createState() => _ProjectChattingState();

  final ProjectModel model;
}

class _ProjectChattingState extends State<ProjectChatting> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _messageFocusNode = FocusNode();
  late EventSourceSubscription _eventSource;

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

    var r = Provider.of<AuthServices>(context, listen: false).userInfoModel!.id;

    final message = ChatMessage(
      message: _messageController.text,
      username: r,
    );

    try {
      final response = await http.post(
        Uri.parse('http://localhost:9001/api/chat/message'),
        body: {
          'message': message.message,
          'username': message.username,
          'room': widget.model.title,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          // _messages.add(message);
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
    var u = context.watch<AuthServices>().userInfoModel!.id;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.bgImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              AppImages.noiseImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  width: 375.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.noiseImage),
                      fit: BoxFit.cover,
                    ),
                    gradient: const LinearGradient(
                      transform: GradientRotation(-360 + 128),
                      colors: [
                        Color(0xFF412A81),
                        Color(0xFF140739),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.paddingOf(context).top + 10.h),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              AppImages.back,
                              width: 24,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white.withOpacity(.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    AppImages.profile,
                                    fit: BoxFit.cover,
                                    width: 40.w,
                                    height: 40.w,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.model.title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      "Online",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _messages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          if (_messages[index].username == u) const Spacer(),
                          SizedBox(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 6.h),
                              constraints: BoxConstraints(
                                minWidth: 0,
                                maxWidth: MediaQuery.sizeOf(context).width * .6,
                              ),
                              decoration: BoxDecoration(
                                color: _messages[index].username == u
                                    ? null
                                    : const Color(0xFF140739),
                                borderRadius: BorderRadius.circular(12),
                                gradient: _messages[index].username != u
                                    ? null
                                    : LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF412A81),
                                          const Color(0xFF412A81)
                                              .withOpacity(.8),
                                          // Color(0xFF140739),
                                        ],
                                      ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_messages[index].username != u)
                                    FutureBuilder(
                                        future: Provider.of<PostProvider>(
                                                context,
                                                listen: false)
                                            .getUserById(
                                                _messages[index].username),
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data?.name ?? "",
                                            style: TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                          );
                                        }),
                                  Text(_messages[index].message),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 12.h,
                left: 8,
                right: 8,
                top: 8,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 49, 31, 98),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (_) => _sendMessage(),
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Send message ...",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Iconsax.send_1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      if (event.length < 5) {
        return;
      }

      event = event.substring(5);

      log(event);

      final parsedData = jsonDecode(event);

      log(parsedData.runtimeType.toString());

      log(parsedData.toString());

      if (parsedData is Map &&
          parsedData.containsKey('message') &&
          parsedData.containsKey('username')) {
        _messageController.add(Map<String, dynamic>.from(parsedData));
        log("message");
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

class ChatMessage {
  final String message;
  final String username;

  bool isMe = false;

  ChatMessage({
    required this.message,
    required this.username,
  });
}
