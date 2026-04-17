import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'pronunciation_practice_page.dart';

class TopicSelectPage extends StatefulWidget {
  final String type;

  const TopicSelectPage({super.key, required this.type});

  @override
  State<TopicSelectPage> createState() => _TopicSelectPageState();
}

class _TopicSelectPageState extends State<TopicSelectPage> {
  bool _isLoading = true;
  List<dynamic> _topicList = [];
  String? _startingUnitId;

  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uri = Uri.parse('$_apiBaseUrl/api/v1/pronunciation/units').replace(
        queryParameters: {'type': widget.type},
      );
      final res = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '加载单元列表失败');
      }
      final data = decoded['data'];
      if (!mounted) return;
      setState(() {
        _topicList = data is List<dynamic> ? data : <dynamic>[];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _topicList = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载话题失败：$e')),
      );
    }
  }

  Future<void> _startSessionAndNavigate({
    required String unitId,
    required String topic,
  }) async {
    if (_startingUnitId != null) return;

    setState(() => _startingUnitId = unitId);
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uri = Uri.parse('$_apiBaseUrl/api/v1/pronunciation/session/start');
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'unit_id': unitId}),
      );

      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? 'start session failed');
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final sessionId = (data['session_id'] ?? '').toString();
      final currentItem = (data['current_item'] ?? {}) as Map<String, dynamic>;

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PronunciationPracticePage(
            sessionId: sessionId,
            currentItem: currentItem,
            type: widget.type,
            topic: topic,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('启动练习失败：$e')),
      );
    } finally {
      if (mounted) {
        setState(() => _startingUnitId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 1. 全局线性渐变背景
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010101), // 顶部深黑
              Color(0xFF2D4F2B), // 底部深绿
            ],
            stops: [0.13, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. 自定义导航栏
              _buildAppBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // 3. 标题部分
                      const Text(
                        '选择一个主题',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '选择一个类别开始练习',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 4. 话题网格展示，如果正在加载则显示进度条
                      _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFDC003),
                                ),
                              ),
                            )
                          : GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.0, // 正方形卡片
                              children: _topicList.map((item) {
                                // 将每个item通过对应的id, topic, cover_emoji等绑定去渲染
                                return _buildTopicCard(
                                  id: item['id'] ?? '',
                                  topic: item['topic'] ?? '',
                                  emoji: item['cover_emoji'] ?? '✨',
                                  label: item['title'] ?? item['topic'] ?? '',
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 32),

                      // 5. 挑战横幅
                      _buildChallengeBanner(),

                      const SizedBox(height: 120), // 为底部导航留出空间
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 导航栏组件
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFDC003),
            ), // 黄色箭头
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.type == 'word' ? '单词练习' : '句子练习',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 话题卡片组件 (毛玻璃效果)
  Widget _buildTopicCard({
    required String id,
    required String topic,
    required String emoji,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        _startSessionAndNavigate(unitId: id, topic: topic);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (_startingUnitId == id)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFFDC003),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 挑战横幅组件
  Widget _buildChallengeBanner() {
    return Container(
      height: 140, // 稍微调低一点高度，更加精致
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        // 加强一点深绿色和金色的渐变对比，让它从背景中浮现出来
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFDC003).withOpacity(0.25),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFDC003).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none, // 允许元素稍微溢出一点点，更有立体感
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 220, // 给文字多留点空间
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '准备好挑战了吗？',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800, // 加粗标题
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '每天进步一点点，成为英语小达人！',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4, // 增加行高，提升阅读体验
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 用大号 Emoji 替换损坏的网络图片
          const Positioned(
            right: 16,
            bottom: 10, // 稍微靠下一点，错落有致
            child: Text(
              '🏆', // 如果你更喜欢宝箱，可以换成 '🎁' 或者 '🏆'
              style: TextStyle(
                fontSize: 80, // 超大号 Emoji
                shadows: [
                  // 给 Emoji 加上一点发光阴影
                  Shadow(
                    color: Color(0xFFFDC003),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
