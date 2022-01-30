import 'dart:math';

import 'package:huffman_compressor_example/bean/node.dart';

class HfmtreeUtil{
  static Map<int,TreeNode> buildTreeWithLeaves(Map<int,TreeNode> leaves){
    int i = 0;
    int locateChild = 0,locateParent = 0;
    TreeNode newNode;
    int level,n;
    bool isLeftChild = true,exist = true;
    Map<int,TreeNode> allNodes = {};

    leaves.forEach((key, value) {
      level = value.level;
      n = value.n;
      locateChild = getLocate(level, n);
      allNodes[locateChild] = value;
      for(i = 0;i<value.codeword.length;i++){
        level--;
        isLeftChild = n % 2 == 0;
        n = n ~/ 2;
        locateParent = getLocate(level, n);
        if(allNodes[locateParent] == null){
          exist = false;
          newNode = TreeNode(level: level, n: n, num: 0, weight: 0);
          allNodes[locateParent] = newNode;
        }else{
          exist = true;
        }
        if(isLeftChild){//左子树
          allNodes = _addNode(allNodes, locateParent, locateChild, ChildState.leftChild);
        }else{
          allNodes = _addNode(allNodes, locateParent, locateChild, ChildState.rightChild);
        }
        locateChild = locateParent;
        if(exist)break;
      }
    });
    allNodes = _sumWeight(allNodes, leaves);
    allNodes.forEach((key, value) {
      print(value.level);
      print(value.n);
      print(value.weight);
      print(value.parent);
      print(value.rightChild);
      print(value.leftChild);
      print("--------------");
    });
    return allNodes;
  }

  static Map<int,TreeNode> _addNode(Map<int,TreeNode> allNodes,
      int locateParent, int locateChild, ChildState state){
    allNodes[locateChild]!.parent = locateParent;
    if(state == ChildState.rightChild){
      allNodes[locateParent]!.rightChild = locateChild;
    }else{
      allNodes[locateParent]!.leftChild = locateChild;
    }
    return allNodes;
  }

  static Map<int,TreeNode> _sumWeight(Map<int,TreeNode> allNodes,Map<int,TreeNode> leaves){
    int level,n,locate;
    leaves.forEach((key, value) {
      level = -- value.level;
      n = value.n ~/ 2;
      locate = getLocate(level, n);
      while(allNodes[locate]!.parent != -1){
        allNodes[locate]!.weight += value.num;
        level--;
        n = n ~/ 2;
        locate = getLocate(level, n);
      }
    });
    return allNodes;
  }

  static int getLocate(int level, int n){
    return (pow(2, level)  + n - 1).toInt();
  }
}