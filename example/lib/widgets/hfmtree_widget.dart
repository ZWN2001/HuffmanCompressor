import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

import '../constant.dart';
import 'node_widget.dart';

class HfmtreeWidget extends StatefulWidget {
  final List<TreeNode> leaves;
  final Map<int, TreeNode> allNodes;

  const HfmtreeWidget({Key? key, required this.leaves, required this.allNodes})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => HfmtreeWidgetView();
}

class HfmtreeWidgetView extends State<HfmtreeWidget> {
  final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());

  @override
  void initState() {
    super.initState();
    if (hfmtreeWidgetLogic.leaves.isEmpty) {
      hfmtreeWidgetLogic.leaves = widget.leaves;
      hfmtreeWidgetLogic.allNodes = widget.allNodes;
      hfmtreeWidgetLogic.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 4 / hfmtreeWidgetLogic.scale,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ///画板层（放在最底下）
          Transform.scale(
            scale: 0.8,
            child: CustomPaint(
              painter: BranchPainter(lines: hfmtreeWidgetLogic.lines),
            ),
          ),

          ///节点层
          Transform.scale(
            scale: 0.8,
            child: Obx(
              () => Stack(
                children: hfmtreeWidgetLogic.nodeStackWidgets,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HfmtreeWidgetLogic extends GetxController {
  List<TreeNode> leaves = [];
  Map<int, TreeNode> allNodes = {};
  RxList<Widget> nodeStackWidgets = <Widget>[].obs;
  int height = 0;
  Map<Offset, Offset> lines = {};
  double scale = 1;

  void init() {
    height = HfmtreeUtil.getHeight(leaves);
    if (height > 5) {
      scale = 1 / pow(2, height - 4);
    }
    lines = HfmtreeUtil.getLineOffsets(allNodes, leaves, height, scale);
    getNodeWidget(allNodes, height);
  }

  void getNodeWidget(Map<int, TreeNode> allNodes, int height) {
    Positioned p;
    double l, t;
    allNodes.forEach((key, value) {
      l = Constant.WIDGET_WIDEH / 2 +
          (HfmtreeUtil.getNodeHorizontalOffset(value.level, value.n, height) +
                  4) *
              scale; //加4纠正偏移
      t = (HfmtreeUtil.getNodeVerticalOffset(value.level) + 0.0) * scale;
      p = Positioned(
          left: l,
          top: t,
          child: NodeWidget(
            node: value,
            scale: scale,
            nodeL: l,
            nodeT: t,
          ));
      nodeStackWidgets.add(p);
    });
  }
}

class HfmtreeWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HfmtreeWidgetLogic());
  }
}

class BranchPainter extends CustomPainter {
  final Map<Offset, Offset> lines;

  const BranchPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    // 创建画笔
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3 * hfmtreeWidgetLogic.scale //线宽
      ..style = PaintingStyle.stroke //模式--线型
      ..isAntiAlias = true;
    if (lines.isNotEmpty) {
      lines.forEach((key, value) {
        canvas.drawLine(key, value, paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
