import 'package:flutter/material.dart';

import 'frame_component.dart';
import 'frame_component1.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 使用全局背景渐变
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBE739),
              Color(0xFFE3FF91),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ],
            stops: [0, 0.15, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 顶部 Header (头像, 昵称, 金币, 体力)
                _buildHeader(),
                const SizedBox(height: 20),

                // 2. 龙宝AI 与 签到任务中心 (引入 frame_component)
                const FrameComponent(),
                const SizedBox(height: 16),

                // 3. 主题学习 Banner
                _buildThemeBanner(),
                const SizedBox(height: 16),

                // 4. 记忆卡片 & PK赛区 (引入 frame_component1)
                const FrameComponent1(),
                const SizedBox(height: 20),

                // 5. 底部四个功能入口
                _buildBottomIcons(),
                const SizedBox(height: 40), // 底部安全留白
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 局部组件构建方法 ---

  // 构建顶部栏
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧头像与昵称
        Row(
          children: [
            // 【修改点】嵌套 Container：外层是图片边框，内层是圆形头像
            Container(
              width: 50, // 外层边框的大小，可以根据实际切图微调
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/home/-12@2x.png'), // 边框图
                  fit: BoxFit.contain,
                ),
              ),
              child: Container(
                width: 42, // 头像比边框稍小，正好居中嵌进去
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 确保头像是圆的
                  image: DecorationImage(
                    image: AssetImage('assets/images/home/-13@2x.png'), // 人物头像图
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello,Ryujin!',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Alimama ShuHeiTi',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Level.17',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Alimama FangYuanTi VF',
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        // 右侧状态数值
        Row(
          children: [
            _buildStatusPill('assets/images/home/OK-1@2x.png', '812'),
            const SizedBox(width: 10),
            _buildStatusPill('assets/images/home/11@2x.png', '5/10'),
          ],
        ),
      ],
    );
  }

  // 构建右上角的圆角胶囊
  Widget _buildStatusPill(String iconPath, String value) {
    return Stack(
      alignment: Alignment.centerLeft, // 图标和胶囊都靠左垂直居中对齐
      clipBehavior: Clip.none,
      children: [
        // 1. 底层的文字胶囊
        Container(
          height: 24, // 胶囊整体高度
          // 【关键点1】margin: 让胶囊整体往右偏移 14px（约图标宽度的一半），给左侧图标留出露出的空间
          margin: const EdgeInsets.only(left: 14),
          // 【关键点2】padding: 左侧内边距给够（20px），防止数字被上面的图标挡住
          padding: const EdgeInsets.only(left: 20, right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFFC107), // 提取UI稿中的橙黄色外框
              width: 2,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alimama ShuHeiTi',
              color: Colors.black87,
            ),
          ),
        ),
        // 2. 顶层的图标（自然盖在左边）
        Image.asset(
          iconPath,
          width: 30, // 图标高度 30，比胶囊的 24 稍大，形成突破边框的立体效果
          height: 30,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // 构建主题学习宽条幅
  Widget _buildThemeBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/images/home/-10@2x.png'), // 绿色底图
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 右侧的 3D 物品框
          Positioned(
            right: 0,
            bottom: -10,
            child: Image.asset(
              'assets/images/home/Background-Rect@2x.png',
              width: 170,
            ),
          ),
          // 左侧的文字排版
          Positioned(
            top: 20,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Text(
                      '主题\n学习',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Alimama ShuHeiTi',
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.white,
                      ),
                    ),
                    const Text(
                      '主题\n学习',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Alimama ShuHeiTi',
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        color: Color(0xFF1E5128), // 墨绿色文字
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '海量口语主题等你来挑战',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF7CB342),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建底部四个带边框的图标按钮
  Widget _buildBottomIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSingleIcon('assets/images/home/-4@2x.png', '趣味听英语'),
        _buildSingleIcon('assets/images/home/-5@2x.png', '趣味背单词'),
        _buildSingleIcon('assets/images/home/-6@2x.png', '趣味学音标'),
        _buildSingleIcon('assets/images/home/-7@2x.png', '趣味看视频'),
      ],
    );
  }

  Widget _buildSingleIcon(String imagePath, String title) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFC107),
              width: 2,
            ), // 金色边框
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontFamily: 'PingFang SC',
          ),
        ),
      ],
    );
  }
}
