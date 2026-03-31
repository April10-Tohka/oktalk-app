import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    defaultValue: 'http://10.0.2.2:8080',
  );

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    // 这里模拟从后端获取数据，实际开发中请使用 http 库请求真实接口:
    // final response = await http.get(Uri.parse('https://your_domain/api/v1/pronunciation/units?type=${widget.type}'));

    await Future.delayed(const Duration(milliseconds: 800)); // 模拟网络延迟加载效果

    // 根据传入的 type 构造对应 Mock 数据
    final titleSuffix = widget.type == 'word' ? 'Words' : 'Sentences';
    final String mockResponse =
        '''
    {
    "code": 200,
    "message": "success",
    "data": [
        {
            "id": "word_animals",
            "type": "word",
            "topic": "animals",
            "title": "Animal Words",
            "cover_emoji": "🐶",
            "total_items": 3
        },
        {
            "id": "word_food",
            "type": "word",
            "topic": "food",
            "title": "Food Words",
            "cover_emoji": "🍗",
            "total_items": 3
        },
        {
            "id": "word_fruits",
            "type": "word",
            "topic": "fruits",
            "title": "Fruit Words",
            "cover_emoji": "🍎",
            "total_items": 3
        }
    ]
}
    ''';

    if (mounted) {
      final decoded = jsonDecode(mockResponse);
      if (decoded['code'] == 200) {
        setState(() {
          _topicList = decoded['data'];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startSessionAndNavigate({
    required String unitId,
    required String topic,
  }) async {
    if (_startingUnitId != null) return;

    setState(() => _startingUnitId = unitId);
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/pronunciation/session/start');
      final res = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
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
                        'Choose a Topic',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a category to start practicing',
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
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFDC003).withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ready for a challenge?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Practice daily to unlock new special categories!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAi2KCXJ31F0WYJDa4QI1O8G5WQ1xki_nGKWMvTAfljZzK5jXfLfY2RAUWF1M9TgpV4WEQPCDTrg6N8aEHvc-ZG8n6RkwAPdhDKqkWMw6Fmgvt4wH9D02U4cAaXJjxN3dRYsCp34oPNvi3ZO-K9WWxzo8TLiFKEN-mDXfrqOWosfyvGxH8eIjuqdpyPX4TvyKQkHEjagYk4dp_JFLDxrrsnLRhyLJSSxbsrNcovZ5hkowdFUyvvFjARSeH4Gik9NWCv7bbCYgW-70ia',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
