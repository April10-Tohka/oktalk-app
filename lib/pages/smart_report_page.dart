import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartReportPage extends StatefulWidget {
  const SmartReportPage({super.key});

  @override
  State<SmartReportPage> createState() => _SmartReportPageState();
}

class _SmartReportPageState extends State<SmartReportPage> {
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  static const String _default_ai_avatar= 'assets/images/default_ai_avatar.png';

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _loading = true;
  String? _error;

  String _weekStart = '';
  String _weekEnd = '';
  int _evaluationCount = 0;
  int _conversationCount = 0;
  int _persistenceDays = 0;

  int _accuracyScore = 0;
  int _fluencyScore = 0;
  int _integrityScore = 0;
  int _standardScore = 0;

  dynamic _hardWords; // null or list

  int _scenePassRate = 0;
  int _completedScenes = 0;

  String _encourageText = '';

  String _fullSummary = '';
  List<String> _strengths = [];
  List<String> _improvements = [];

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDate(String raw) {
    // raw: 2026-03-30 -> 2026/3/30
    final parts = raw.split('-');
    if (parts.length != 3) return raw;
    final y = parts[0];
    final m = int.tryParse(parts[1]) ?? parts[1];
    final d = int.tryParse(parts[2]) ?? parts[2];
    return '$y/$m/$d';
  }

  Future<void> _fetchReport() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final uri = Uri.parse('$_apiBaseUrl/api/v1/report/generate');
      final res = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '生成报告失败');
      }

      final outerData = decoded['data'] as Map<String, dynamic>;
      final reportData = (outerData['data'] ?? {}) as Map<String, dynamic>;

      final activity = (reportData['activity'] ?? {}) as Map<String, dynamic>;
      final radar = (reportData['radar'] ?? {}) as Map<String, dynamic>;
      final scene = (reportData['scene'] ?? {}) as Map<String, dynamic>;
      final encourage = (reportData['encourage'] ?? {}) as Map<String, dynamic>;
      final fullReport =
          (reportData['full_report'] ?? {}) as Map<String, dynamic>;

      final strengthsRaw = fullReport['strengths'];
      final improvementsRaw = fullReport['improvements'];

      if (!mounted) return;
      setState(() {
        _weekStart = _formatDate((reportData['week_start'] ?? '').toString());
        _weekEnd = _formatDate((reportData['week_end'] ?? '').toString());

        _evaluationCount =
            int.tryParse((activity['evaluation_count'] ?? 0).toString()) ?? 0;
        _conversationCount =
            int.tryParse((activity['conversation_count'] ?? 0).toString()) ?? 0;
        _persistenceDays =
            int.tryParse((activity['persistence_days'] ?? 0).toString()) ?? 0;

        _accuracyScore =
            int.tryParse((radar['accuracy_score'] ?? 0).toString()) ?? 0;
        _fluencyScore =
            int.tryParse((radar['fluency_score'] ?? 0).toString()) ?? 0;
        _integrityScore =
            int.tryParse((radar['integrity_score'] ?? 0).toString()) ?? 0;
        _standardScore =
            int.tryParse((radar['standard_score'] ?? 0).toString()) ?? 0;

        _hardWords = reportData['hard_words'];

        _scenePassRate =
            int.tryParse((scene['pass_rate'] ?? 0).toString()) ?? 0;
        _completedScenes =
            int.tryParse((scene['completed_scenes'] ?? 0).toString()) ?? 0;

        _encourageText = (encourage['encourage_text'] ?? '').toString();

        _fullSummary = (fullReport['summary'] ?? '').toString();
        _strengths = strengthsRaw is List
            ? strengthsRaw.map((e) => e.toString()).toList()
            : <String>[];
        _improvements = improvementsRaw is List
            ? improvementsRaw.map((e) => e.toString()).toList()
            : <String>[];

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
      backgroundColor: const Color(0xFFFDFEF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF755700)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '学习报告',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Text(
              _weekStart.isEmpty || _weekEnd.isEmpty
                  ? '—'
                  : '$_weekStart ~ $_weekEnd',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF755700)),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDFEF5), Color(0xFFF0FAF0)],
          ),
        ),
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF3D6620)),
              )
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          color: const Color(0xFF585D54),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _fetchReport,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3D6620),
                        ),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        _buildRadarCard(),
                        const SizedBox(height: 24),
                        _buildActivityStatsCard(),
                        const SizedBox(height: 24),
                        _buildAIEngagementCard(),
                        const SizedBox(height: 24),
                        _buildScenePerformanceCard(),
                        const SizedBox(height: 24),
                        _buildHardWordsCard(),
                        const SizedBox(height: 24),
                        _buildSummaryCard(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildRadarCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '口语能力分析',
                    style: TextStyle(
                      fontFamily: 'Alimama ShuHeiTi',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.0,  
                      letterSpacing: 0,
                      color: Color(0xFF5CA54E),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCC524),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '本周表现不错！',
                      style: TextStyle(
                        fontFamily: 'PingFang SC',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Color(0xFFFFA100),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: RadarChartPainter(
                      accuracyScore: _accuracyScore,
                      fluencyScore: _fluencyScore,
                      integrityScore: _integrityScore,
                      standardScore: _standardScore,
                    ),
                    child: Stack(
                      children: [
                        _buildRadarLabel(
                          Alignment.topCenter,
                          '准确度',
                          'ACCURACY',
                          isActive: _accuracyScore > 0,
                          isLocked: _accuracyScore == 0,
                        ),
                        _buildRadarLabel(
                          Alignment.bottomCenter,
                          '完整度',
                          'INTEGRITY',
                          isActive: _integrityScore > 0,
                          isLocked: _integrityScore == 0,
                        ),
                        _buildRadarLabel(
                          Alignment.centerLeft,
                          '流畅度',
                          'FLUENCY',
                          isActive: _fluencyScore > 0,
                          isLocked: _fluencyScore == 0,
                        ),
                        _buildRadarLabel(
                          Alignment.centerRight,
                          '标准度',
                          'STANDARD',
                          isActive: _standardScore > 0,
                          isLocked: _standardScore == 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -30,
            right: -30,
            child: Image.asset(
              "assets/images/radarDragon.png",
              width: 76,
              height: 81,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarLabel(
    Alignment alignment,
    String title,
    String subtitle, {
    bool isActive = false,
    bool isLocked = false,
  }) {
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.bottomCenter) const SizedBox(height: 160),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: 0,
              color: isActive
                  ? Color(0xFF000000)
                  : Color(0xFF73786F).withOpacity(isLocked ? 0.5 : 1),
            )
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Alimama FangYuanTi VF',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              height: 1.0,
              color: isActive
                  ? Color(0xFF000000)
                  : Color(0xFF73786F).withOpacity(isLocked ? 0.5 : 1),
            ),
          ),
          if (isLocked)
            Text(
              '练句子题解锁',
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF73786F),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '小朋友在本周的学习中:',
                    style: TextStyle(
                      fontFamily: 'PingFang SC',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Color(0xFF000000),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDC003).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/activityDragon.png",
                width: 104,
                height: 98,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatItem('完成发音练习', '$_evaluationCount', '次'),
          const SizedBox(height: 16),
          _buildStatItem('完成场景对话', '$_conversationCount', '次'),
          const SizedBox(height: 16),
          _buildStatItem('坚持学习天数', '$_persistenceDays', '天'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: Color(0xFFFFC524),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF000000),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Potta One',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF96D96C),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            height: 1.0,
            letterSpacing: 0,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  Widget _buildAIEngagementCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFDC003), width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    "https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/3Ddragon.png",
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                       _default_ai_avatar ,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDC003),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'OK AI',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4B2800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _encourageText.isEmpty ? '—' : _encourageText,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF4B2800),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                left: 16,
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    color: const Color(0xFFFFF3E0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScenePerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '场景对话表现',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2B3028),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: (_scenePassRate.clamp(0, 100)) / 100.0,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFEDF3E6),
                          color: const Color(0xFF3D6620),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '${_scenePassRate.clamp(0, 100)}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3D6620),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '一次通过率',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: const Color(0xFF73786F),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        '$_completedScenes',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3D6620),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: const Icon(
                          Icons.flag,
                          color: Color(0xFF874D00),
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '完成场景数',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: const Color(0xFF73786F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHardWordsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '本周高频难词',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B3028),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_hardWords == null) ...[
            const Text('🎉', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              '本周没有难词！',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D6620),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '发音基础很棒，继续保持！',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: const Color(0xFF73786F),
              ),
            ),
          ] else ...[
            ..._buildHardWordsList(_hardWords),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildHardWordsList(dynamic hardWords) {
    final list = hardWords is List ? hardWords : <dynamic>[];
    if (list.isEmpty) {
      return [
        Text(
          '暂无难词数据',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            color: const Color(0xFF73786F),
          ),
        ),
      ];
    }

    return list.asMap().entries.map((entry) {
      final item = entry.value;
      final map = item is Map
          ? Map<String, dynamic>.from(item)
          : <String, dynamic>{};
      final word = (map['word'] ?? map['content'] ?? map['text'] ?? '')
          .toString();
      final times =
          int.tryParse(
            (map['times'] ??
                    map['practice_times'] ??
                    map['practice_count'] ??
                    map['count'] ??
                    0)
                .toString(),
          ) ??
          0;
      final audioUrl =
          (map['audio_url'] ?? map['standard_audio_url'] ?? map['audio'] ?? '')
              .toString();

      return Padding(
        padding: EdgeInsets.only(bottom: entry.key == list.length - 1 ? 0 : 12),
        child: _buildHardWordPill(
          word: word.isEmpty ? '—' : word,
          times: times,
          audioUrl: audioUrl,
        ),
      );
    }).toList();
  }

  Widget _buildHardWordPill({
    required String word,
    required int times,
    required String audioUrl,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3D6620), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              word,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B3028),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '练了 $times 次',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: audioUrl.isEmpty
                ? null
                : () async {
                    await _audioPlayer.stop();
                    await _audioPlayer.play(UrlSource(audioUrl));
                  },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FAF0),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3D6620).withOpacity(0.2),
                ),
              ),
              child: Icon(
                Icons.volume_up,
                size: 18,
                color: audioUrl.isEmpty
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF3D6620),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '本周学习总结',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2B3028),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _fullSummary.isEmpty ? '—' : _fullSummary,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF585D54),
            ),
          ),
          const SizedBox(height: 24),
          _buildSummarySection(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF3D6620),
            title: '✅ 本周亮点',
            items: _strengths.isEmpty ? const ['—'] : _strengths,
          ),
          const SizedBox(height: 24),
          _buildSummarySection(
            icon: Icons.lightbulb,
            iconColor: const Color(0xFF874D00),
            title: '💡 下周目标',
            items: _improvements.isEmpty ? const ['—'] : _improvements,
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFEDF3E6)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '报告由 AI 生成，仅供参考',
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                color: const Color(0xFFA9AFA4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF585D54),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              color: const Color(0xFF585D54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final int accuracyScore;
  final int fluencyScore;
  final int integrityScore;
  final int standardScore;

  RadarChartPainter({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.integrityScore,
    required this.standardScore,
  });

  double _norm(int v) => (v.clamp(0, 100)) / 100.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    final gridPaint = Paint()
      ..color = const Color(0xFFA9AFA4).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 绘制轴线
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      gridPaint,
    );

    // 绘制背景圆圈
    canvas.drawCircle(center, radius, gridPaint);
    canvas.drawCircle(center, radius * 0.5, gridPaint);

    // 绘制数据区域（四维：准确/流畅/完整/标准）
    final areaPaint = Paint()
      ..color = const Color(0xFF3D6620).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xFF3D6620)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final a = _norm(accuracyScore);
    final f = _norm(fluencyScore);
    final i = _norm(integrityScore);
    final s = _norm(standardScore);

    final pTop = Offset(center.dx, center.dy - radius * a); // accuracy
    final pLeft = Offset(center.dx - radius * f, center.dy); // fluency
    final pBottom = Offset(center.dx, center.dy + radius * i); // integrity
    final pRight = Offset(center.dx + radius * s, center.dy); // standard

    final path = Path()
      ..moveTo(pTop.dx, pTop.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..close();

    canvas.drawPath(path, areaPaint);
    canvas.drawPath(path, borderPaint);

    // 绘制得分点
    final dotPaint = Paint()..color = const Color(0xFF3D6620);
    canvas.drawCircle(pTop, 4, dotPaint);
    canvas.drawCircle(pLeft, 4, dotPaint);
    canvas.drawCircle(pBottom, 4, dotPaint);
    canvas.drawCircle(pRight, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    return accuracyScore != oldDelegate.accuracyScore ||
        fluencyScore != oldDelegate.fluencyScore ||
        integrityScore != oldDelegate.integrityScore ||
        standardScore != oldDelegate.standardScore;
  }
}
