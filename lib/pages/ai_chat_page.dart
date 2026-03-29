import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

// --- Data Models ---
enum ChatRole { user, ai }

enum MsgStatus { normal, skeleton }

class ChatMessage {
  final String id;
  final String textEn;
  final String textZh;
  final ChatRole role;
  final MsgStatus status;

  ChatMessage({
    required this.id,
    required this.textEn,
    required this.textZh,
    required this.role,
    this.status = MsgStatus.normal,
  });

  ChatMessage copyWith({
    String? id,
    String? textEn,
    String? textZh,
    ChatRole? role,
    MsgStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      textEn: textEn ?? this.textEn,
      textZh: textZh ?? this.textZh,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({Key? key}) : super(key: key);

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  // Chat list state
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Recording state
  bool _isRecording = false;

  // Timers and task tracking
  Timer? _pollingTimer;
  int _pollingAttempt = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- Audio Playback Mock ---
  void _playAudio(String messageId) {
    print('Play audio for message: \$messageId');
    // TODO: Implement actual audio playback here.
  }

  // --- Action Handlers ---
  void _onRecordPressed() {
    if (_isRecording) {
      _stopRecordingAndSend();
    } else {
      setState(() {
        _isRecording = true;
      });
      // Start actual audio recording logic here
    }
  }

  Future<void> _stopRecordingAndSend() async {
    setState(() {
      _isRecording = false;
    });

    // 1. Show user skeleton bubble
    final userTempId = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _messages.add(
        ChatMessage(
          id: userTempId,
          textEn: '',
          textZh: '',
          role: ChatRole.user,
          status: MsgStatus.skeleton,
        ),
      );
    });
    _scrollToBottom();

    // 2. Call Interface 1 (Mock submit audio)
    final submitRes = await _mockSubmitAudio();
    final taskId = submitRes['task_id'];

    // 3. Replace user skeleton with real user message
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == userTempId);
      if (idx != -1) {
        _messages[idx] = ChatMessage(
          id: userTempId, // Keep id or use returned real id
          textEn: submitRes['user_text_en'],
          textZh: submitRes['user_text_zh'],
          role: ChatRole.user,
          status: MsgStatus.normal,
        );
      }
    });

    _startPollingAiResponse(taskId);
  }

  void _startPollingAiResponse(String taskId) {
    // Show AI skeleton bubble
    final aiTempId = 'ai_\${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      _messages.add(
        ChatMessage(
          id: aiTempId,
          textEn: 'Listening...',
          textZh: '连接中...',
          role: ChatRole.ai,
          status: MsgStatus.skeleton,
        ),
      );
    });
    _scrollToBottom();

    _pollingAttempt = 0;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) async {
      _pollingAttempt++;
      final pollRes = await _mockPollingTask(taskId, _pollingAttempt);

      if (!mounted) {
        timer.cancel();
        return;
      }

      final status = pollRes['status'];
      final idx = _messages.indexWhere((m) => m.id == aiTempId);
      if (idx == -1) {
        timer.cancel();
        return;
      }

      if (status == 'processing' || status == 'pending') {
        // Update skeleton bubble text
        setState(() {
          _messages[idx] = _messages[idx].copyWith(
            textEn: pollRes['message_en'],
            textZh: pollRes['message_zh'],
          );
        });
      } else if (status == 'success' || status == 'failed') {
        // Stop polling, show real AI bubble
        timer.cancel();
        setState(() {
          _messages[idx] = ChatMessage(
            id: aiTempId,
            textEn: pollRes['message_en'],
            textZh: pollRes['message_zh'],
            role: ChatRole.ai,
            status: MsgStatus.normal,
          );
        });
        // Auto play ai audio
        _playAudio(aiTempId);
        _scrollToBottom();
      }
    });
  }

  // --- Mock APIs ---
  Future<Map<String, dynamic>> _mockSubmitAudio() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return {
      'task_id': 'task_123',
      'user_text_en': 'I am fine.',
      'user_text_zh': '我挺好的。',
    };
  }

  Future<Map<String, dynamic>> _mockPollingTask(
    String taskId,
    int attempt,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    if (attempt < 3) {
      return {
        'status': 'processing',
        'message_en': 'Thinking...',
        'message_zh': '思考中...',
      };
    } else {
      return {
        'status': 'success',
        'message_en': 'How are you today?',
        'message_zh': '你今天过得怎么样？',
      };
    }
  }

  // --- UI Builders ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1305, 1.0],
            colors: [Color(0xFF010101), Color(0xFF71A66E)],
          ),
        ),
        child: Stack(
          children: [
            // Global wave background at bottom (decorative)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/wave_bg.png', // Fallback, no problem if it fails gracefully
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 200),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF233322), Color(0xFF75AC72)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            blurStyle: BlurStyle.inner,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(child: _buildChatList()),
                          _buildBottomAction(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.phone_in_talk,
                      color: Color(0xFFFFC524),
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_off,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          // Dragon image centered
          Image.asset(
            'assets/images/3Ddragon.png', // Replace with your path
            width: 341,
            height: 341,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.pets, color: Colors.white, size: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildChatBubble(msg),
        );
      },
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    if (msg.status == MsgStatus.skeleton && msg.role == ChatRole.user) {
      return _buildUserSkeleton();
    } else if (msg.status == MsgStatus.skeleton && msg.role == ChatRole.ai) {
      return _buildAiSkeleton(msg);
    }

    // Normal Bubbles
    final isAi = msg.role == ChatRole.ai;
    return GestureDetector(
      onTap: () => _playAudio(msg.id),
      child: Column(
        crossAxisAlignment: isAi
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          // Tags
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAi
                    ? [
                        const Color(0xFFFF9900),
                        const Color(0xFFFFCC5F),
                        const Color(0xFFFFEABD),
                      ]
                    : [const Color(0xFF97D96C), const Color(0xFFEAF587)],
                stops: isAi ? [0.1233, 0.6204, 0.9572] : [0.1233, 0.863],
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(5),
                topRight: const Radius.circular(5),
                bottomLeft: isAi ? Radius.zero : const Radius.circular(5),
                bottomRight: isAi ? const Radius.circular(5) : Radius.zero,
              ),
            ),
            child: Text(
              isAi ? "OK AI" : "You",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          // Bubble Box
          Container(
            margin: const EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 2,
                  offset: Offset(0, 0),
                  blurStyle: BlurStyle.inner,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: isAi ? Radius.zero : const Radius.circular(20),
                topRight: isAi ? const Radius.circular(20) : Radius.zero,
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
            ),
            constraints: const BoxConstraints(maxWidth: 344),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.textEn,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  msg.textZh,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // User skeleton (right side)
  Widget _buildUserSkeleton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.8),
        highlightColor: Colors.white,
        child: Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(radius: 4, backgroundColor: Colors.grey),
              CircleAvatar(radius: 4, backgroundColor: Colors.grey),
              CircleAvatar(radius: 4, backgroundColor: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // AI Skeleton (processing text)
  Widget _buildAiSkeleton(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            constraints: const BoxConstraints(maxWidth: 260),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.textEn,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(msg.textZh, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 10),
      child: GestureDetector(
        onTap: _onRecordPressed,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isRecording
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFC7DC66), Color(0xFF59A64A)],
                    stops: [0.0808, 0.7961],
                    transform: GradientRotation(160.97 * 3.14159 / 180),
                  ),
            color: _isRecording ? Colors.greenAccent.shade400 : null,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(218, 255, 167, 0.5),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: _isRecording
                ? const SpinKitWave(color: Colors.white, size: 30)
                : const Icon(Icons.mic, color: Colors.white, size: 36),
          ),
        ),
      ),
    );
  }
}
