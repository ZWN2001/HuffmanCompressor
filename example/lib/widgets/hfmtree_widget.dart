import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

import '../constant.dart';
import 'node_widget.dart';

class HfmtreeWidget extends StatefulWidget {
  final List<TreeNode> leaves;
  final Map<int,TreeNode> allNodes;
  const HfmtreeWidget({Key? key,required this.leaves,required this.allNodes}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>HfmtreeWidgetView();
}

class HfmtreeWidgetView extends State<HfmtreeWidget>{
  final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
  @override
  void initState() {
    super.initState();
    hfmtreeWidgetLogic.leaves = widget.leaves;
    hfmtreeWidgetLogic.allNodes = widget.allNodes;

    hfmtreeWidgetLogic.init();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Stack(
      children: [
        ///画板层（放在最底下）
        CustomPaint(
          painter: BranchPainter(lines: hfmtreeWidgetLogic.lines),
        ),
        ///节点层
        Obx(()=> Stack(
          children: hfmtreeWidgetLogic.nodeStackWidgets,
        ),),
      ],
    ));
  }

}

class HfmtreeWidgetLogic extends GetxController {
  late final List<TreeNode> leaves;
  late final Map<int,TreeNode> allNodes;
  RxList<Widget> nodeStackWidgets = <Widget>[].obs;
  int height = 0;
  Map<Offset,Offset> lines = {};

  void init() {
    height = HfmtreeUtil.getHeight(leaves);
    getNodeWidget(allNodes, height);
    lines = HfmtreeUtil.getLineOffsets(allNodes, leaves, height);
  }

  void getNodeWidget(Map<int,TreeNode> allNodes,int height){
    Positioned p;
    allNodes.forEach((key, value) {
      p = Positioned(
          left: Constant.WIDGET_WIDEH/2 + HfmtreeUtil.getNodeHorizontalOffset(value.level, value.n, height),
          top: HfmtreeUtil.getNodeVerticalOffset(value.level) + 0.0,
          child: NodeWidget(
            node: value,
          )
      );
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
  final Map<Offset,Offset> lines ;
  const BranchPainter({required this.lines});
  @override
  void paint(Canvas canvas, Size size) {
    // 创建画笔
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3 //线宽
      ..style = PaintingStyle.stroke //模式--线型
      ..isAntiAlias = true;
    if(lines.isNotEmpty){
      lines.forEach((key, value) {
        canvas.drawLine(key, value, paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
