import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/constant.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

import 'hfmtree_widget.dart';

class NodeWidget extends StatefulWidget {

  final TreeNode node;
  const NodeWidget({
    Key? key,
    required this.node
  }) : super(key: key);

  @override
  _NodeWidgetState createState() =>_NodeWidgetState();
}
class _NodeWidgetState extends State<NodeWidget>{

  Color cardColor = Colors.white;
  double elevation = 2;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          child: Card(
            color: Colors.blue,
            child: SizedBox(
              width: Constant.NODE_SIZE * 1.0,
              height: Constant.NODE_SIZE * 1.0,
              child: Center(
                child: Text('${widget.node.weight}',style: const TextStyle(color: Colors.white),),
              ),
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))), //设置圆角
            elevation: elevation,
          ),
          onEnter: (v){
            setState(() {
              elevation = 8;
              addCard();
            });
          },
          onExit: (v){
            setState(() {
              elevation = 2;
              remmoveCard();
            });
          },
        );
  }

  Widget detailCard(){
    final h = Get.put(HfmtreeWidgetLogic());
    return  Positioned(
        left: 42 + Constant.WIDGET_WIDEH/2 + HfmtreeUtil.getNodeHorizontalOffset(widget.node.level, widget.node.n, h.height),
        top: HfmtreeUtil.getNodeVerticalOffset(widget.node.level) + 0.0,
        child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text('locate : ${HfmtreeUtil.getLocate(widget.node.level, widget.node.n)}'),
                  const SizedBox(height: 2,),
                  Text('level : ${widget.node.level}'),
                  const SizedBox(height: 2,),
                  Text('n : ${widget.node.n}'),
                  const SizedBox(height: 2,),
                  Text('weiget : ${widget.node.weight}'),
                  // SizedBox(height: 2,),
                  // Text('locate : ${widget.node}'),
                  const SizedBox(height: 2,),
                  Text('leftchild : ${widget.node.leftChild}'),
                  const SizedBox(height: 2,),
                  Text('rightchild : ${widget.node.rightChild}'),
                  const SizedBox(height: 2,),
                  Text('parentchild : ${widget.node.parent}'),
                ],
              ),
            )
        )
    );
  }

  void addCard(){
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    hfmtreeWidgetLogic.nodeStackWidgets.add(detailCard());
  }

  void remmoveCard(){
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    hfmtreeWidgetLogic.nodeStackWidgets.removeLast();
  }
}