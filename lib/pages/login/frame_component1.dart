import 'package:flutter/material.dart';

import 'qq.dart';
import 'tokens.dart';

class FrameComponent1 extends StatelessWidget {
  const FrameComponent1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width390,
      height: 95,
      alignment: AlignmentDirectional.topStart,
      child: Container(
        width: 289,
        height: height48,
        padding: const EdgeInsets.only(left: 101),
        alignment: AlignmentDirectional.topStart,
        child: const QQ(),
      ),
    );
  }
}
