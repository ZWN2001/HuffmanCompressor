import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/constant.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

import 'hfmtree_widget.dart';

class NodeWidget extends StatefulWidget {
  final TreeNode node;
  final double scale;
  final double nodeL;
  final double nodeT;

  const NodeWidget({
    Key? key,
    required this.node,
    required this.scale,
    required this.nodeL,
    required this.nodeT,
  }) : super(key: key);

  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  Color cardColor = Colors.white;
  double elevation = 2;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.blue,
        child: SizedBox(
          width: Constant.NODE_SIZE * widget.scale,
          height: Constant.NODE_SIZE * widget.scale,
          child: Center(
            child: Text(
              '${widget.node.weight}',
              style:
                  TextStyle(color: Colors.white, fontSize: 12 * widget.scale),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0))),
        //设置圆角
        elevation: elevation,
      ),
      onEnter: (v) {
        setState(() {
          elevation = 8;
          addCard();
        });
      },
      onExit: (v) {
        setState(() {
          elevation = 2;
          remmoveCard();
        });
      },
    );
  }

  Widget detailCard() {
    return Positioned(
        left: widget.nodeL + ((Constant.NODE_SIZE) * widget.scale),
        top: widget.nodeT,
        child: Transform.scale(
          scale: widget.scale,
          child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'locate : ${HfmtreeUtil.getLocate(widget.node.level, widget.node.n)}'),
                    const SizedBox(height: 2,),
                    Text('level : ${widget.node.level}'),
                    const SizedBox(height: 2,),
                    Text('n : ${widget.node.n}'),
                    const SizedBox(height: 2,),
                    Text('weiget : ${widget.node.weight}'),
                    const SizedBox(height: 2,),
                    Text('leftchild : ${widget.node.leftChild}'),
                    const SizedBox(height: 2,),
                    Text('rightchild : ${widget.node.rightChild}'),
                    const SizedBox(height: 2,),
                    Text('parentchild : ${widget.node.parent}'),
                  ],
                ),
              )),
        ));
  }

  void addCard() {
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    hfmtreeWidgetLogic.nodeStackWidgets.add(detailCard());
  }

  void remmoveCard() {
    final hfmtreeWidgetLogic = Get.put(HfmtreeWidgetLogic());
    hfmtreeWidgetLogic.nodeStackWidgets.removeLast();
  }
}
