import 'dart:math';

import 'package:huffman_compressor_example/bean/node.dart';

class HfmtreeUtil{
  static Map<int,TreeNode> buildTreeWithLeaves(List<TreeNode> leaves){
    int i = 0;
    int locateChild = 0,locateParent = 0;
    TreeNode newNode;
    int level,n;
    bool isLeftChild = true,exist = true;
    Map<int,TreeNode> allNodes = {};

    for(TreeNode leaf in leaves){
      level = leaf.level;
      n = leaf.n;
      locateChild = getLocate(level, n);
      allNodes[locateChild] = leaf;
      for(i = 0;i<leaf.codeword.length;i++){
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
    }
    allNodes = _sumWeight(allNodes, leaves);
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

  static Map<int,TreeNode> _sumWeight(Map<int,TreeNode> allNodes,List<TreeNode> leaves){
    int level,n,locate;
    for (TreeNode value in leaves) {
      level =value.level;
      n = value.n;
      locate = getLocate(level, n);
      while(allNodes[locate]!.parent != -1){
        level--;
        n = n ~/ 2;
        locate = getLocate(level, n);
        allNodes[locate]!.weight += value.weight;
      }
    }
    return allNodes;
  }

  static int getLocate(int level, int n){
    return (pow(2, level)  + n - 1).toInt();
  }

  ///返回真正的层数
  static int getHeight(List<TreeNode> leaves){
    int height = 0;
    if(leaves.isEmpty)return height;
    for(TreeNode leaf in leaves){
      if(leaf.level+1>height) height = leaf.level+1;
    }
    return height;
  }
}