import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ai_guided_chat_page.dart';

class ScenceSelectPage extends StatefulWidget {
  const ScenceSelectPage({super.key});

  @override
  State<ScenceSelectPage> createState() => _ScenceSelectPageState();
}

class _ScenceSelectPageState extends State<ScenceSelectPage> {
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  bool _isLoading = true;
  List<dynamic> _sceneList = [];
  String? _startingSceneId;

  @override
  void initState() {
    super.initState();
    _fetchScenes();
  }

  Future<void> _fetchScenes() async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/scene/list');
      final res = await http.get(uri);
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '加载场景失败');
      }
      final data = decoded['data'];
      if (!mounted) return;
      setState(() {
        _sceneList = data is List ? data : <dynamic>[];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sceneList = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载场景失败：$e')),
      );
    }
  }

  Future<void> _startSceneAndNavigate({
    required String sceneId,
    required String title,
    required String subtitle,
  }) async {
    if (_startingSceneId != null) return;
    setState(() => _startingSceneId = sceneId);
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/scene/session/start');
      final res = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'scene_id': sceneId}),
      );
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '启动场景失败');
      }
      final data = decoded['data'] as Map<String, dynamic>;

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AiGuidedChatPage(
            title: title,
            subtitle: subtitle,
            startData: data,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('启动场景失败：$e')),
      );
    } finally {
      if (mounted) setState(() => _startingSceneId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 1. 全局背景渐变
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010101), // 顶部深黑
              Color(0xFF71A66E), // 底部深绿
            ],
            stops: [0.13, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. 自定义顶部导航栏
              _buildAppBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      // 3. 标题部分
                      const Text(
                        '选择一个场景',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '选择一个主题开始对话',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 4. 场景卡片列表（接口渲染）
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFFFDC003),
                            ),
                          ),
                        )
                      else
                        ..._sceneList.asMap().entries.map((entry) {
                          final item = entry.value;
                          final map = item is Map
                              ? Map<String, dynamic>.from(item)
                              : <String, dynamic>{};
                          final id = (map['id'] ?? '').toString();
                          final title = (map['title'] ?? '').toString();
                          final subtitle = (map['description'] ?? '').toString();
                          final emoji = (map['cover_emoji'] ?? '✨').toString();

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: entry.key == _sceneList.length - 1 ? 0 : 16,
                            ),
                            child: _buildScenarioCard(
                              id: id,
                              emoji: emoji,
                              title: title,
                              subtitle: subtitle,
                              isStarting: _startingSceneId == id,
                              onTap: () => _startSceneAndNavigate(
                                sceneId: id,
                                title: title,
                                subtitle: subtitle,
                              ),
                            ),
                          );
                        }),

                      const SizedBox(height: 40),
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

  // 顶部导航栏
  Widget _buildAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '模拟场景对话',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // 占位以保持标题居中
            ],
          ),
        ),
      ),
    );
  }

  // 场景卡片 (增加了 onTap 参数和 GestureDetector)
  Widget _buildScenarioCard({
    required String id,
    required String emoji,
    required String title,
    required String subtitle,
    required bool isStarting,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isStarting)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFFDC003),
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withOpacity(0.3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
