import 'dart:convert';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'ai_home_page.dart';


class PronunciationSummaryPage extends StatefulWidget {
  final String sessionId;

  const PronunciationSummaryPage({
    super.key,
    required this.sessionId,
  });

  @override
  State<PronunciationSummaryPage> createState() =>
      _PronunciationSummaryPageState();
}

class _PronunciationSummaryPageState extends State<PronunciationSummaryPage> {

  // 鼓励语文本数组
  final List<String> _encouragementTexts = [
    '很棒！继续练习你会更厉害！',
    '进步明显，保持这个节奏！',
    '你的努力正在开花结果！',
    '太棒了！你比昨天更强大了！',
    '坚持就是胜利，继续加油！',
    '每一次练习都在让你变强！',
    '你做得很好，为自己骄傲吧！',
    '学习路上，你已经走得很远了！',
    '今天的你比昨天更优秀！',
    '继续保持，成功就在不远处！',
  ];
  
  late final String _randomText;
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  bool _loading = true;
  String? _error;

  String _unitTitle = '';
  double _averageScore = 0;
  int _averageStars = 0;
  String _summary = '';
  List<dynamic> _items = [];
  List<String> _highlight = [];
  List<String> _weak = [];

  @override
  void initState() {
    super.initState();
    _fetchSummary();
    _randomText = _encouragementTexts[math.Random().nextInt(_encouragementTexts.length)];
  }

  Future<void> _fetchSummary() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uri = Uri.parse(
        '$_apiBaseUrl/api/v1/pronunciation/session/${widget.sessionId}/summary',
      );
      print(uri);
      final res = await http.get(uri);
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '加载总结失败');
      }
      final data = decoded['data'] as Map<String, dynamic>;

      final highlightRaw = data['highlight'] ?? [];
      final weakRaw = data['weak'] ?? [];

      if (!mounted) return;
      setState(() {
        _unitTitle = (data['unit_title'] ?? '').toString();
        _averageScore =
            (data['average_score'] is num)
                ? (data['average_score'] as num).toDouble()
                : double.tryParse('${data['average_score'] ?? 0}') ?? 0;
        _averageStars =
            int.tryParse('${data['average_stars'] ?? 0}')?.clamp(0, 5) ?? 0;
        _summary = (data['summary'] ?? '').toString();
        _items = data['items'] is List ? data['items'] as List<dynamic> : [];
        _highlight = _stringListFromJson(highlightRaw);
        _weak = _stringListFromJson(weakRaw);
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

  List<String> _stringListFromJson(dynamic raw) {
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).toList();
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
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Practice Summary',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
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
          const SizedBox(height: 32),
          _buildHeroSection(),
          const SizedBox(height: 48),
          _buildAISpeechBubble(),
          const SizedBox(height: 48),
          _buildWordList(),
          const SizedBox(height: 160),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final titleChip = _unitTitle.isEmpty ? '—' : _unitTitle.toUpperCase();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            titleChip,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFDC003).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
            const Text('🏆', style: TextStyle(fontSize: 80)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 36,
              color: index < _averageStars
                  ? const Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.2),
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          _randomText,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            color: Colors.white.withOpacity(0.7),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAISpeechBubble() {
    final textStyle = GoogleFonts.beVietnamPro(
      color: const Color(0xFF2B3028),
      fontSize: 15,
      height: 1.5,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            image:  DecorationImage(
              image: AssetImage(
                'assets/images/3Ddragon.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'AI 小助手',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF4B2800),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _summary.isEmpty ? '暂无总结内容' : _summary,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -12,
                top: 0,
                child: CustomPaint(
                  painter: TrianglePainter(color: Colors.white),
                  size: const Size(12, 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWordList() {
    final highlightSet = _highlight.toSet();
    final weakSet = _weak.toSet();
    final count = _items.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '本次单词',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$count个词汇',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ..._items.asMap().entries.map((entry) {
          final item = entry.value;
          final map = item is Map
              ? Map<String, dynamic>.from(item)
              : <String, dynamic>{};
          final word = (map['content'] ?? '').toString();
          final bestStars =
              int.tryParse('${map['best_stars'] ?? 0}')?.clamp(0, 5) ?? 0;

          final isHighlight = highlightSet.contains(word);
          final isWeak = weakSet.contains(word);
          final isBest = isHighlight;

          final String status;
          if (isHighlight) {
            status = '最佳表现';
          } else if (isWeak) {
            status = '再练练 💪';
          } else {
            status = '本次练习';
          }

          return Padding(
            padding: EdgeInsets.only(bottom: entry.key == _items.length - 1 ? 0 : 16),
            child: _buildWordCard(word, status, bestStars, isBest),
          );
        }),
      ],
    );
  }

  // Widget _buildWordCard(String word, String status, int stars, bool isBest) {
  //   return Stack(
  //     children: [
  //       if (isBest)
  //         Positioned.fill(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(32),
  //               gradient: const LinearGradient(
  //                 colors: [Color(0xFFFDC003), Color(0xFFFC9922)],
  //               ),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: const Color(0xFFFDC003).withOpacity(0.3),
  //                   blurRadius: 10,
  //                   spreadRadius: 2,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       Container(
  //         margin: isBest ? const EdgeInsets.all(1) : EdgeInsets.zero,
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: Colors.white.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(32),
  //           border: Border.all(
  //             color: isBest
  //                 ? const Color(0xFFFDC003).withOpacity(0.3)
  //                 : Colors.white.withOpacity(0.05),
  //           ),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 56,
  //                   height: 56,
  //                   decoration: BoxDecoration(
  //                     color: isBest
  //                         ? const Color(0xFFFDC003).withOpacity(0.2)
  //                         : const Color(0xFFC0F19A).withOpacity(0.1),
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                       color: isBest
  //                           ? const Color(0xFFFDC003).withOpacity(0.4)
  //                           : const Color(0xFFC0F19A).withOpacity(0.2),
  //                     ),
  //                   ),
  //                   child: Icon(
  //                     isBest ? Icons.workspace_premium : Icons.auto_awesome,
  //                     color: isBest
  //                         ? const Color(0xFFFDC003)
  //                         : const Color(0xFFC0F19A),
  //                     size: 24,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       word,
  //                       style: GoogleFonts.plusJakartaSans(
  //                         color: Colors.white,
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 10,
  //                         vertical: 2,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: isBest
  //                             ? const Color(0xFFFDC003)
  //                             : Colors.white.withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(100),
  //                       ),
  //                       child: Text(
  //                         status,
  //                         style: GoogleFonts.plusJakartaSans(
  //                           color: isBest
  //                               ? const Color(0xFF3D2B00)
  //                               : Colors.white.withOpacity(0.6),
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.w800,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: List.generate(5, (index) {
  //                 return Icon(
  //                   Icons.star,
  //                   size: 18,
  //                   color: index < stars
  //                       ? const Color(0xFFFDC003)
  //                       : Colors.white.withOpacity(0.1),
  //                 );
  //               }),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildWordCard(String word, String status, int stars, bool isBest) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBest
              ? const Color(0xFFFDC003).withOpacity(0.6)
              : Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: isBest
            ? [
          BoxShadow(
            color: const Color(0xFFFDC003).withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ]
            : [],
      ),
      // 优化了这里的 Row 结构
      child: Row(
        children: [
          // 1. 左侧图标区域 (固定大小)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isBest
                  ? const Color(0xFFFDC003).withOpacity(0.2)
                  : const Color(0xFFC0F19A).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isBest ? '👑' : '✨',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. 中间文本区域 (使用 Expanded 吸收剩余空间，防止溢出)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  // 增加限制：最多显示 2 行，超出的显示省略号
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // 状态标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isBest
                        ? const Color(0xFFFDC003).withOpacity(0.2)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.plusJakartaSans(
                      color: isBest ? const Color(0xFFFFD700) : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // 文字和星星之间保留一点间距

          // 3. 右侧星星评分区域 (使用 mainAxisSize.min 保持紧凑)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 22,
                color: index < stars
                    ? const Color(0xFFFDC003)
                    : Colors.white.withOpacity(0.3),
              );
            }),
          ),
        ],
      ),
    );
  }


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
                    MaterialPageRoute(
                      builder: (context) => const AiHomePage(),
                    ),
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

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
