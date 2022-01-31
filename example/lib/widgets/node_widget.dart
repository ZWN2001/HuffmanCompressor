import 'package:flutter/material.dart';
import 'package:huffman_compressor_example/bean/node.dart';

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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: (){},
          child: Card(
            color: Colors.blue,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Text('${widget.node.weight}',style: const TextStyle(color: Colors.white),),
              ),
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))), //设置圆角
            elevation: elevation,
          ),
          onHover: (value){
            setState(() {
              elevation = value ? 8 : 2;
              show = value?true:false;
            });
          },
        ),
        if(show)
          Positioned(
              left: 42,
              top: 0,
              child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
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
          ),
      ],
    );
  }
}