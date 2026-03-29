import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// --- Mock Data Models based on Go Backend ---
class ReportMVPResponse {
  final String reportId;
  final String reportType;
  final String periodStartDate;
  final String periodEndDate;
  final ActivityStats activityStats;
  final AbilityRadar abilityRadar;
  final ProgressStats progressStats;
  final KidFriendlyCard kidFriendlyCard;
  final List<DifficultWord> difficultWords;
  final FullReport fullReport;

  ReportMVPResponse({
    required this.reportId,
    required this.reportType,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.activityStats,
    required this.abilityRadar,
    required this.progressStats,
    required this.kidFriendlyCard,
    required this.difficultWords,
    required this.fullReport,
  });
}

class ActivityStats {
  final int conversationCount;
  final int evaluationCount;
  final int totalMinutes;
  final int activeDays;

  ActivityStats({
    required this.conversationCount,
    required this.evaluationCount,
    required this.totalMinutes,
    required this.activeDays,
  });
}

class AbilityRadar {
  final double accuracyScore;
  final double fluencyScore;
  final double integrityScore;
  final String summary;

  AbilityRadar({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.integrityScore,
    required this.summary,
  });
}

class ProgressStats {
  final int overallScoreChange;
  final double previousScore;
  final double currentScore;
  final List<String> highlights;
  final String levelImprovement;

  ProgressStats({
    required this.overallScoreChange,
    required this.previousScore,
    required this.currentScore,
    required this.highlights,
    required this.levelImprovement,
  });
}

class KidFriendlyCard {
  final String encouragementText;
  final List<String> highlights;
  final String smallGoal;

  KidFriendlyCard({
    required this.encouragementText,
    required this.highlights,
    required this.smallGoal,
  });
}

class DifficultWord {
  final String word;
  final int frequency;
  final String demoAudioUrl;

  DifficultWord({
    required this.word,
    required this.frequency,
    required this.demoAudioUrl,
  });
}

class FullReport {
  final String periodSummary;
  final String abilityAnalysis;
  final String progressHighlight;
  final List<String> improvementAreas;
  final List<String> recommendations;
  final String fullText;

  FullReport({
    required this.periodSummary,
    required this.abilityAnalysis,
    required this.progressHighlight,
    required this.improvementAreas,
    required this.recommendations,
    required this.fullText,
  });
}

class SmartReportPage extends StatefulWidget {
  const SmartReportPage({Key? key}) : super(key: key);

  @override
  State<SmartReportPage> createState() => _SmartReportPageState();
}

class _SmartReportPageState extends State<SmartReportPage> {
  late ReportMVPResponse _mockData;

  @override
  void initState() {
    super.initState();
    _mockData = _getMockData();
  }

  ReportMVPResponse _getMockData() {
    return ReportMVPResponse(
      reportId: 'REP-202402',
      reportType: 'weekly',
      periodStartDate: '2024-02-12',
      periodEndDate: '2024-02-18',
      activityStats: ActivityStats(
        conversationCount: 12,
        evaluationCount: 8,
        totalMinutes: 45,
        activeDays: 5,
      ),
      abilityRadar: AbilityRadar(
        accuracyScore: 75,
        fluencyScore: 82,
        integrityScore: 88,
        summary: "整体表现很棒！",
      ),
      progressStats: ProgressStats(
        overallScoreChange: 7,
        previousScore: 75,
        currentScore: 82,
        highlights: ["流利度提升 +8 分", "S/A 级增加 3 次"],
        levelImprovement: "S/A 级评测增加 3 次",
      ),
      kidFriendlyCard: KidFriendlyCard(
        encouragementText: "这周你更敢开口了，真棒！",
        highlights: ["流利度提升", "发音更清晰"],
        smallGoal: "每天跟读 5 分钟",
      ),
      difficultWords: [
        DifficultWord(
          word: "apples",
          frequency: 3,
          demoAudioUrl: "https://example.com/audio/apples.mp3",
        ),
        DifficultWord(
          word: "banana",
          frequency: 2,
          demoAudioUrl: "https://example.com/audio/banana.mp3",
        ),
      ],
      fullReport: FullReport(
        periodSummary: "本周英语学习积极性很高，对话流利度有显著提升。",
        abilityAnalysis: "在日常问候场景中表达准确，但在复合句的语法运用上稍微有些犹豫。",
        progressHighlight: "敢于尝试长句表达，这是非常大的进步！",
        improvementAreas: ["需加强部分元音的发音", "词汇量需要进一步扩充"],
        recommendations: ["建议每天坚持阅读简单的英语绘本", "可以多看一些原声英文动画片磨耳朵"],
        fullText:
            "小朋友在本周的学习中表现出了极大的热情。不仅完成了所有的日常打卡任务，还在模拟对话中勇敢尝试了许多新词汇。虽然在部分复杂句型上还有提升空间，但这种积极开口的态度非常值得肯定！继续保持对英语的好奇心，下周我们一起来挑战更多的趣味场景吧！",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Diffused 빛 (Blur bubbles)
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  left: -4,
                  top: 0,
                  child: Container(
                    width: 396,
                    height: 852,
                    color: const Color(0xFFFFF8BF).withOpacity(0.5),
                  ),
                ),
                Positioned(
                  left: -4,
                  top: 0,
                  child: Container(
                    width: 396,
                    height: 852,
                    color: const Color(0xFFD9F266).withOpacity(0.2),
                  ),
                ),
                // Emulated large blurred ellipses
                Positioned(
                  left: -56.4,
                  top: 197.71,
                  child: _buildBlurNode(
                    474.82,
                    490.55,
                    const Color(0xFFF5F5F5),
                  ),
                ),
                Positioned(
                  left: 129.36,
                  top: -36.97,
                  child: _buildBlurNode(
                    436.19,
                    493.47,
                    const Color(0xFFECFFE5),
                  ),
                ),
                Positioned(
                  left: -145.75,
                  top: -3.56,
                  child: _buildBlurNode(
                    453.99,
                    363.94,
                    const Color(0xFFFFF5D6),
                  ),
                ),
                Positioned(
                  left: 150.15,
                  top: 477.17,
                  child: _buildBlurNode(417.85, 411.8, const Color(0xFFDAFFA7)),
                ),
                Positioned(
                  left: -180,
                  top: 516.95,
                  child: _buildBlurNode(
                    409.78,
                    353.86,
                    const Color(0xFFE9F4BC),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      _buildRadarCard(),
                      const SizedBox(height: 16),
                      _buildActivityCard(),
                      const SizedBox(height: 16),
                      _buildProgressCard(),
                      const SizedBox(height: 16),
                      _buildDifficultWordsCard(),
                      const SizedBox(height: 16),
                      _buildFullReportCard(),
                      const SizedBox(height: 34),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurNode(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 88,
      padding: const EdgeInsets.only(top: 10, left: 8, right: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF0B3D03),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF0B3D03),
                ),
                onPressed: () {},
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '学习报告',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\${_mockData.periodStartDate} - \${_mockData.periodEndDate}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF878787),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Card 1: Radar Chart (Modified for 3 dimensions per spec) ---
  Widget _buildRadarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '口语智能分析',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5CA54E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFC524), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _mockData.abilityRadar.summary,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFA200),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                RadarChart(
                  RadarChartData(
                    tickCount: 3,
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    titlePositionPercentageOffset: 0.2,
                    dataSets: [
                      RadarDataSet(
                        fillColor: const Color(0xFFEAF587).withOpacity(0.5),
                        borderColor: const Color(0xFFBAE42E),
                        entryRadius: 4,
                        dataEntries: [
                          RadarEntry(
                            value: _mockData.abilityRadar.accuracyScore,
                          ),
                          RadarEntry(
                            value: _mockData.abilityRadar.fluencyScore,
                          ),
                          RadarEntry(
                            value: _mockData.abilityRadar.integrityScore,
                          ),
                        ],
                      ),
                    ],
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0:
                          return const RadarChartTitle(text: '准确度\nAccuracy');
                        case 1:
                          return const RadarChartTitle(text: '流利度\nFluency');
                        case 2:
                          return const RadarChartTitle(text: '完整度\nIntegrity');
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                  ),
                ),
                // Mocking the dragon icon in top right
                Positioned(
                  right: 0,
                  top: 0,
                  child: Image.asset(
                    'assets/images/3Ddragon.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.pets, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 2: Activity Stats (2x2 grid) ---
  Widget _buildActivityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '小朋友在本周的学习中：',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildActivityRow(
                  '对话次数: \${_mockData.activityStats.conversationCount} 次',
                ),
                _buildActivityRow(
                  '评测次数: \${_mockData.activityStats.evaluationCount} 次',
                ),
                _buildActivityRow(
                  '学习时长: \${_mockData.activityStats.totalMinutes} 分钟',
                ),
                _buildActivityRow(
                  '活跃天数: \${_mockData.activityStats.activeDays} 天',
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/3Ddragon.png',
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.pets, size: 80, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const CircleAvatar(radius: 4, backgroundColor: Color(0xFFFFC524)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 3: Progress & Goal Card (Using percentage visual style) ---
  Widget _buildProgressCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本周综合表现',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFFFBC00),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\${_mockData.progressStats.currentScore.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Potta One', // Fallback if unavailable
                  fontSize: 36,
                  color: Color(0xFF96D96C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ' 分',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF96D96C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '(\${_mockData.progressStats.overallScoreChange >= 0 ? ' +
                    ' : '
                        '}\${_mockData.progressStats.overallScoreChange} 分)',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _mockData.kidFriendlyCard.encouragementText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
            ),
          ),
          Text(
            '小目标: \${_mockData.kidFriendlyCard.smallGoal}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 4: Difficult Words ---
  Widget _buildDifficultWordsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '需加强的单词',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFFFBC00),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 16),
          ..._mockData.difficultWords.map((wordObj) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wordObj.word,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '出现问题次数: \${wordObj.frequency}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Color(0xFF5CA54E)),
                    onPressed: () {
                      // Play demo audio
                      print('Playing audio: \${wordObj.demoAudioUrl}');
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // --- Card 5: Full Report ---
  Widget _buildFullReportCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '家长点评/完整分析',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 90,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFFFBC00),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _mockData.fullReport.fullText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '学习建议:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ..._mockData.fullReport.recommendations
              .map(
                (rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: Colors.orange, fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          rec,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
