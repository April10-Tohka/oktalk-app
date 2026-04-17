import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pronunciation_summary_page.dart';

class PronunciationPracticePage extends StatefulWidget {
  final String sessionId;
  final Map<String, dynamic> currentItem;
  final String type;
  final String topic;

  const PronunciationPracticePage({
    super.key,
    required this.sessionId,
    required this.currentItem,
    required this.type,
    required this.topic,
  });

  @override
  State<PronunciationPracticePage> createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage> {
  // 核心对象
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 状态变量
  bool _isRecording = false;
  bool _isPlayingStandard = false;
  bool _isPlayingMyAudio = false;
  bool _isPlayingAiAudio = false;
  bool _isPlayingHowToFix = false;
  bool _isRequesting = false;

  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  // 练习会话核心数据
  late final String _sessionId;
  late Map<String, dynamic> _currentItem;
  late final String _type;
  late final String _topic;

  late String _content;
  late String _standardAudioUrl;
  late int _itemIndex;
  late int _totalItems;

  late final String _practiceType;

  // 接口返回的数据
  bool _hasResult = false;
  int _stars = 0;
  int _starAnimSeed = 0;
  String _correctionHint = '';
  String _myAudioUrl = '';
  String _aiAudioUrl = '';
  String _howToFixUrl = '';

  @override
  void initState() {
    super.initState();
    _sessionId = widget.sessionId;
    _currentItem = widget.currentItem;
    _type = widget.type;
    _topic = widget.topic;

    if (_type == "word") {
      _practiceType = "单词";
    } else if (_type == "sentence") {
      _practiceType = "句子";
    }
    _content = (_currentItem['content'] ?? '').toString();
    _standardAudioUrl = (_currentItem['standard_audio_url'] ?? '').toString();
    _itemIndex =
        int.tryParse((_currentItem['item_index'] ?? 0).toString()) ?? 0;
    _totalItems =
        int.tryParse((_currentItem['total_items'] ?? 0).toString()) ?? 0;

    // 监听播放完成事件以重置播放状态
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlayingStandard = false;
          _isPlayingMyAudio = false;
          _isPlayingAiAudio = false;
          _isPlayingHowToFix = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ==== 播放控制 ====

  // 播放标准读音
  Future<void> _playStandardAudio() async {
    if (_standardAudioUrl.isEmpty) return;
    if (_isPlayingStandard) {
      await _audioPlayer.stop();
      setState(() => _isPlayingStandard = false);
      return;
    }

    // 如果正在播放我的录音，先停止
    if (_isPlayingMyAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingMyAudio = false);
    }

    setState(() => _isPlayingStandard = true);
    await _audioPlayer.play(UrlSource(_standardAudioUrl));
  }

  // 播放我的录音
  Future<void> _playMyAudio() async {
    if (_myAudioUrl.isEmpty) return;

    if (_isPlayingMyAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingMyAudio = false);
      return;
    }

    // 如果正在播放标准读音，先停止
    if (_isPlayingStandard) {
      await _audioPlayer.stop();
      setState(() => _isPlayingStandard = false);
    }
    if (_isPlayingAiAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingAiAudio = false);
    }

    setState(() => _isPlayingMyAudio = true);
    await _audioPlayer.play(UrlSource(_myAudioUrl));
  }

  Future<void> _playAiAudio() async {
    if (_aiAudioUrl.isEmpty) return;

    if (_isPlayingAiAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingAiAudio = false);
      return;
    }

    if (_isPlayingStandard) {
      await _audioPlayer.stop();
      setState(() => _isPlayingStandard = false);
    }
    if (_isPlayingMyAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingMyAudio = false);
    }

    setState(() => _isPlayingAiAudio = true);
    await _audioPlayer.play(UrlSource(_aiAudioUrl));
  }

  // 播放如何纠正音频 (How To Fix)
  Future<void> _playHowToFixAudio() async {
    if (_howToFixUrl.isEmpty) return;

    if (_isPlayingHowToFix) {
      await _audioPlayer.stop();
      setState(() => _isPlayingHowToFix = false);
      return;
    }

    // 停止其他正在播放的所有音频
    if (_isPlayingStandard || _isPlayingMyAudio || _isPlayingAiAudio) {
      await _audioPlayer.stop();
      setState(() {
        _isPlayingStandard = false;
        _isPlayingMyAudio = false;
        _isPlayingAiAudio = false;
      });
    }

    setState(() => _isPlayingHowToFix = true);
    await _audioPlayer.play(UrlSource(_howToFixUrl));
  }

  // ==== 录音控制 ====

  Future<void> _startRecording() async {
    debugPrint("开始录音");
    // 动态申请麦克风权限
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (status.isPermanentlyDenied) {
        // 跳转设置页
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('请在系统设置中允许麦克风权限'),
              action: SnackBarAction(
                label: '去设置',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
      if (!status.isGranted) {
        return;
      }
    }

    // 检查是否有足够的设备支持
    if (!await _audioRecorder.hasPermission()) return;

    try {
      // 构造临时录音文件路径
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/practice_record_${DateTime.now().millisecondsSinceEpoch}.wav';

      // 按照规定：采样率16k、位长16bit、单声道， WAV 格式 (用 wav 编码保存)
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 256000,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _hasResult = false; // 按下录音时重置状态
      });
    } catch (e) {
      debugPrint("录音启动失败: $e");
    }
  }

  Future<void> _stopRecording() async {
    debugPrint("停止录音");
    if (!_isRecording) return;

    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // 调用接口 evaluate
        await _evaluate(path);
      }
    } catch (e) {
      debugPrint("录音停止失败: $e");
    }
  }

  Future<void> _evaluate(String filePath) async {
    debugPrint("开始评测");
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    debugPrint("显示加载对话框");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFDC003)),
      ),
    );

    debugPrint("调用接口 evaluate");
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uri = Uri.parse('$_apiBaseUrl/api/v1/pronunciation/evaluate');
      final req = http.MultipartRequest('POST', uri);

      req.headers['Authorization'] = 'Bearer $accessToken';
      req.fields['session_id'] = _sessionId;
      req.fields['item_id'] = _itemIndex.toString();
      req.fields['audio_type'] = 'wav';

      req.files.add(await http.MultipartFile.fromPath('audio_file', filePath));

      final streamed = await req.send();
      final body = await streamed.stream.bytesToString();
      final decoded = jsonDecode(body) as Map<String, dynamic>;

      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? 'evaluate failed');
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final evaluation = (data['evaluation'] ?? {}) as Map<String, dynamic>;
      final aiFeedback = (data['ai_feedback'] ?? {}) as Map<String, dynamic>;

      final stars =
          int.tryParse((evaluation['stars'] ?? 0).toString())?.clamp(0, 5) ?? 0;
      final suggestion = (aiFeedback['how_to_fix'] ?? '').toString();
      final userAudioUrl = (data['user_audio_url'] ?? '').toString();
      final aiAudioUrl = (aiFeedback['ai_audio_url'] ?? '').toString();
      final howToFixUrl = (aiFeedback['how_to_fix_url'] ?? '').toString();
      if (!mounted) return;
      setState(() {
        _hasResult = true;
        _stars = stars;
        _starAnimSeed++;
        _correctionHint = suggestion;
        _myAudioUrl = userAudioUrl;
        _aiAudioUrl = aiAudioUrl;
        _howToFixUrl = howToFixUrl;
      });

      // 1. 首先开始播放 AI 音频
      await _playAiAudio();

      // 2. 关键：等待 AI 音频播放完成
      // 使用 .first 监听下一次播放完成的信号，确保顺序
      await _audioPlayer.onPlayerComplete.first;

      // 3. AI 音频播完后，自动播放纠错指导音频 (how_to_fix)
      if (mounted) {
        await _playHowToFixAudio();
      }
    } catch (e) {
      debugPrint("评测失败: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('评测失败：$e')));
    } finally {
      debugPrint("关闭加载对话框");
      if (mounted) {
        Navigator.pop(context);
        setState(() => _isRequesting = false);
      }
    }
  }

  Future<void> _advanceToNext() async {
    if (_isRequesting) return;
    setState(() => _isRequesting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uri = Uri.parse(
        '$_apiBaseUrl/api/v1/pronunciation/session/advance',
      );
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'session_id': _sessionId,
          'current_item_id': _itemIndex,
        }),
      );
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? 'advance failed');
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final unitCompleted = data['unit_completed'] == true;
      if (unitCompleted) {
        if (!mounted) return;
        await _audioPlayer.stop();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PronunciationSummaryPage(sessionId: _sessionId),
          ),
        );
        return;
      }

      final nextItem = (data['next_item'] ?? {}) as Map<String, dynamic>;
      final nextContent = (nextItem['content'] ?? '').toString();
      final nextStandard = (nextItem['standard_audio_url'] ?? '').toString();
      final nextIndex =
          int.tryParse((nextItem['item_index'] ?? 0).toString()) ?? _itemIndex;
      final nextTotal =
          int.tryParse((nextItem['total_items'] ?? 0).toString()) ??
          _totalItems;

      if (!mounted) return;
      await _audioPlayer.stop();
      setState(() {
        _currentItem = nextItem;
        _content = nextContent;
        _standardAudioUrl = nextStandard;
        _itemIndex = nextIndex;
        _totalItems = nextTotal;

        // 重置评测区域
        _hasResult = false;
        _stars = 0;
        _correctionHint = '';
        _myAudioUrl = '';
        _aiAudioUrl = '';
        _howToFixUrl = ''; // 新增
        _isPlayingHowToFix = false; // 新增

        _isPlayingStandard = false;
        _isPlayingMyAudio = false;
        _isPlayingAiAudio = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('获取下一条失败：$e')));
    } finally {
      if (mounted) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 1. 全局背景：从黑到绿的线性渐变
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010101), // 顶部深黑
              Color(0xFF3D6620), // 底部深绿
            ],
            stops: [0.13, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. 顶部导航栏
              _buildHeader(context),

              // 3. 顶部进度条
              _buildProgressBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      // 4. 单词练习卡片 (毛玻璃效果)
                      _buildPracticeCard(),

                      const SizedBox(height: 40),

                      // 5. 录音按钮区域
                      _buildRecordingSection(),

                      const SizedBox(height: 40),

                      // 6. 反馈评分区域 (录音后显示)
                      if (_hasResult) _buildFeedbackSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 7. 底部操作按钮
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  // 顶部标题栏
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Text(
            '$_topic - $_practiceType练习',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_itemIndex / $_totalItems',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 进度条
  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 4,
      color: Colors.white.withOpacity(0.1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final total = _totalItems <= 0 ? 1 : _totalItems;
          final idx = _itemIndex.clamp(0, total);
          final progress = idx / total;
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * progress,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFFDC003),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(2),
                ),
                boxShadow: [BoxShadow(color: Color(0x80FDC003), blurRadius: 8)],
              ),
            ),
          );
        },
      ),
    );
  }

  // 练习卡片 (毛玻璃)
  Widget _buildPracticeCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Text(
                _content,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _playStandardAudio, // 点击事件
                icon: Icon(
                  _isPlayingStandard
                      ? Icons.stop_circle_rounded
                      : Icons.play_circle_filled,
                  color: Colors.black,
                ),
                label: Text(
                  _isPlayingStandard ? '停止播放' : '播放标准音频',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 录音按钮
  Widget _buildRecordingSection() {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _startRecording(),
          onTapUp: (_) => _stopRecording(),
          onTapCancel: () => _stopRecording(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 脉冲动画装饰 (长按变大效果控制)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isRecording ? 120 : 100,
                height: _isRecording ? 120 : 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording
                      ? Colors.green.withOpacity(0.3)
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isRecording
                        ? Colors.greenAccent
                        : Colors.white.withOpacity(0.3),
                    width: 4,
                  ),
                  color: _isRecording
                      ? Colors.green
                      : Colors.white.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.mic,
                  color: _isRecording ? Colors.white : Colors.white70,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isRecording ? '正在录音...' : '按住说话',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: _isRecording
                ? Colors.greenAccent
                : Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // 反馈评分区域
  Widget _buildFeedbackSection() {
    return Column(
      children: [
        // 星级
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final enabled = index < _stars;
            final duration = Duration(milliseconds: 220 + index * 80);
            return TweenAnimationBuilder<double>(
              key: ValueKey('star_${_starAnimSeed}_$index'),
              tween: Tween(begin: 0.0, end: 1.0),
              duration: duration,
              curve: Curves.easeOutBack,
              builder: (context, t, _) {
                final scale = enabled ? (0.85 + 0.25 * t) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Icon(
                    Icons.star,
                    size: 36,
                    color: enabled ? const Color(0xFFFDC003) : Colors.white24,
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 24),
        // 纠错提示
        if (_correctionHint.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF95630).withOpacity(0.15),
              border: Border.all(
                color: const Color(0xFFF95630).withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFF95630),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _correctionHint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        // 录音对比行
        GestureDetector(
          onTap: _playMyAudio,
          child: _buildComparisonRow(
            Icons.volume_up,
            '我的录音',
            const Color(0xFFB2E28D),
            _isPlayingMyAudio, // 传递播放状态
          ),
        ),

        // AI 反馈按钮 (仅在有纠错音频时才显示)
        if (_howToFixUrl.isNotEmpty) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _playHowToFixAudio,
            child: _buildComparisonRow(
              Icons.auto_awesome,
              'AI 反馈音频',
              const Color(0xFFFDC003),
              _isPlayingHowToFix,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildComparisonRow(
    IconData icon,
    String label,
    Color iconColor,
    bool isPlaying,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.stop_rounded : Icons.play_arrow,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // 底部操作栏
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            children: [
              // 再来一次
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // 清空之前的状态
                    setState(() {
                      _hasResult = false;
                      _stars = 0;
                      _correctionHint = '';
                      _myAudioUrl = '';
                    });
                  },
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('再试一次'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 下一条
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _advanceToNext,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('下一条'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D6620),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                    elevation: 10,
                    shadowColor: const Color(0xFF3D6620).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
