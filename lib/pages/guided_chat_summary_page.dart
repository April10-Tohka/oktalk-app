import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'ai_home_page.dart';

class GuidedChatSummaryPage extends StatefulWidget {
  final String sessionId;
  final String title;

  const GuidedChatSummaryPage({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<GuidedChatSummaryPage> createState() => _GuidedChatSummaryPageState();
}

class _GuidedChatSummaryPageState extends State<GuidedChatSummaryPage> {
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );
  static const String _aiAvatarUrl =
      'https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/3Ddragon.png';

  bool _loading = true;
  String? _error;

  String _summaryIntro = '';
  List<String> _summaryItems = [];
  int _passedSteps = 0;
  int _totalSteps = 0;
  int _passRate = 0;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse(
        '$_apiBaseUrl/api/v1/scene/session/${widget.sessionId}/summary',
      );
      final res = await http.get(uri);
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '加载总结失败');
      }
      final data = decoded['data'] as Map<String, dynamic>;
      final itemsRaw = data['summary_items'];
      final items = itemsRaw is List
          ? itemsRaw.map((e) => e.toString()).toList()
          : <String>[];

      if (!mounted) return;
      setState(() {
        _summaryIntro = (data['summary_intro'] ?? '').toString();
        _summaryItems = items;
        _passedSteps =
            int.tryParse((data['passed_steps'] ?? 0).toString()) ?? 0;
        _totalSteps = int.tryParse((data['total_steps'] ?? 0).toString()) ?? 0;
        _passRate = int.tryParse((data['pass_rate'] ?? 0).toString()) ?? 0;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF010101), Color(0xFF71A66E)],
            stops: [0.13, 1.0],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(child: _buildBody()),
            Positioned(top: 0, left: 0, right: 0, child: _buildAppBar(context)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFDC003)),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _fetchSummary,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFDC003),
                  foregroundColor: Colors.black,
                ),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 80),
          _buildHeroSection(),
          const SizedBox(height: 40),
          _buildAICharacterSection(),
          const SizedBox(height: 40),
          _buildLessonListSection(),
          const SizedBox(height: 180),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 100,
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          color: Colors.white.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              Text(
                '对话总结',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 48), // 占位平衡
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final title = widget.title.toUpperCase();
    final total = _totalSteps <= 0 ? 1 : _totalSteps;
    final passed = _passedSteps.clamp(0, total);
    final progress = passed / total;

    return Column(
      children: [
        // 场景标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFC0F19A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 自定义进度环
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: ProgressRingPainter(
                  progress: progress,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  progressColor: const Color(0xFF71A66E),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$passed / $total',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '关卡通过',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 鼓励文案
        Text(
          '通过率 $_passRate% · 很棒！继续加油💪',
          style: GoogleFonts.beVietnamPro(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAICharacterSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 头像
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
            color: const Color(0xFFFDC003),
          ),
          child: ClipOval(
            child: Image.network(
              _aiAvatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/ai_avatar.png', // 本地默认头像
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),

        // 对话气泡
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _summaryIntro.isEmpty ? 'Great job!' : _summaryIntro,
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFF2B3028),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // 角色标签
              Positioned(
                top: -12,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF874D00),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'OK AI',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonListSection() {
    final items = _summaryItems;
    final total = _totalSteps <= 0
        ? (items.isEmpty ? 1 : items.length)
        : _totalSteps;
    final passed = _passedSteps.clamp(0, total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            '今天学会了 ✨',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...items.asMap().entries.map((entry) {
          final idx = entry.key;
          final text = entry.value;
          final completed = idx < passed;
          return Padding(
            padding: EdgeInsets.only(bottom: idx == items.length - 1 ? 0 : 12),
            child: _buildLessonCard(
              title: text,
              isCompleted: completed,
              showTag: !completed,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLessonCard({
    required String title,
    required bool isCompleted,
    bool showTag = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 状态图标
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFFC0F19A).withOpacity(0.3)
                          : Colors.transparent,
                      border: isCompleted
                          ? Border.all(
                              color: const Color(0xFFC0F19A).withOpacity(0.4),
                            )
                          : Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFFC0F19A),
                            size: 20,
                          )
                        : Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),

                  // 标题
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 发音按钮
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: isCompleted
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (showTag) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF874D00).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: const Color(0xFF874D00).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '再练练 💪',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFFC9922),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildBottomActions(BuildContext context) {
  //   return ClipRRect(
  //     borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
  //       child: Container(
  //         padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFF0A1F0A).withOpacity(0.8),
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
  //           border: Border.all(color: Colors.white.withOpacity(0.05)),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // // 主按钮: 再来一次
  //             // Container(
  //             //   width: double.infinity,
  //             //   height: 60,
  //             //   decoration: BoxDecoration(
  //             //     gradient: const LinearGradient(
  //             //       colors: [Color(0xFF71A66E), Color(0xFF4CAF50)],
  //             //     ),
  //             //     borderRadius: BorderRadius.circular(26),
  //             //     boxShadow: [
  //             //       BoxShadow(
  //             //         color: const Color(0xFF4CAF50).withOpacity(0.3),
  //             //         offset: const Offset(0, 10),
  //             //         blurRadius: 20,
  //             //       ),
  //             //     ],
  //             //   ),
  //             //   child: Material(
  //             //     color: Colors.transparent,
  //             //     child: InkWell(
  //             //       onTap: () {},
  //             //       borderRadius: BorderRadius.circular(26),
  //             //       child: Row(
  //             //         mainAxisAlignment: MainAxisAlignment.center,
  //             //         children: [
  //             //           const Text('🔁', style: TextStyle(fontSize: 18)),
  //             //           const SizedBox(width: 8),
  //             //           Text(
  //             //             '再来一次',
  //             //             style: GoogleFonts.plusJakartaSans(
  //             //               color: Colors.white,
  //             //               fontSize: 16,
  //             //               fontWeight: FontWeight.w800,
  //             //             ),
  //             //           ),
  //             //         ],
  //             //       ),
  //             //     ),
  //             //   ),
  //             // ),
  //             // const SizedBox(height: 12),

  //             // 次按钮: 回到首页
  //             Container(
  //               width: double.infinity,
  //               height: 56,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(22),
  //                 border: Border.all(color: Colors.white.withOpacity(0.4)),
  //               ),
  //               child: Material(
  //                 color: Colors.transparent,
  //                 child: InkWell(
  //                   onTap: () {
  //                     Navigator.of(context).pushReplacement(
  //                       MaterialPageRoute(builder: (_) => const AiHomePage()),
  //                     );
  //                   },
  //                   borderRadius: BorderRadius.circular(22),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       const Text('🏠', style: TextStyle(fontSize: 16)),
  //                       const SizedBox(width: 8),
  //                       Text(
  //                         '回到首页',
  //                         style: GoogleFonts.plusJakartaSans(
  //                           color: Colors.white,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.6)],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AiHomePage()),
                  );
                },
                borderRadius: BorderRadius.circular(100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '回到首页',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

// 自定义进度环绘制器
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;
    const strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF71A66E), Color(0xFF4CAF50)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
