import 'package:flutter/material.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/constant.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';


class HfmtreeWidget extends StatefulWidget{

  final List<TreeNode> leaves;
  final Map<int,TreeNode> allNodes;
  const HfmtreeWidget({Key? key,required this.leaves,required this.allNodes}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_StackWidget();
}

class _StackWidget extends State<HfmtreeWidget>{
  List<Widget> nodeStackWidgets = [];
  int heiget = 0;

  @override
  void initState() {
    super.initState();
    heiget = HfmtreeUtil.getHeight(widget.leaves);
    getNodeWidget(widget.allNodes, heiget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///节点层
        Stack(
          children: nodeStackWidgets,
        ),

      ],
    );
  }

  void getNodeWidget(Map<int,TreeNode> allNodes,int heiget){
    Positioned p;
    allNodes.forEach((key, value) {
      p = Positioned(
          left: Constant.WIDGET_WIDEH/2,
          top: 0,
          child: Card(child: Text('$key'),)
      );
      nodeStackWidgets.add(p);
    });
  }
}