import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

import '../constant.dart';
import 'node_widget.dart';

class HfmtreeWidget extends StatelessWidget {
  final List<TreeNode> leaves;
  final Map<int,TreeNode> allNodes;
  const HfmtreeWidget({Key? key,required this.leaves,required this.allNodes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    hfmtreeWidgetLogic.leaves = leaves;
    hfmtreeWidgetLogic.allNodes = allNodes;
    hfmtreeWidgetLogic.init();
    return Stack(
      children: [
        ///节点层
        Obx(()=> Stack(
          children: hfmtreeWidgetLogic.nodeStackWidgets,
        ),),


      ],
    );
  }
}

class HfmtreeWidgetLogic extends GetxController {
  late final List<TreeNode> leaves;
  late final Map<int,TreeNode> allNodes;
  RxList<Widget> nodeStackWidgets = <Widget>[].obs;
  int height = 0;

  void init() {
    height = HfmtreeUtil.getHeight(leaves);
    getNodeWidget(allNodes, height);
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