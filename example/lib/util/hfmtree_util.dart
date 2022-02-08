import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:huffman_compressor_example/bean/node.dart';

import '../constant.dart';

class HfmtreeUtil {
  static Map<int, TreeNode> buildTreeWithLeaves(List<TreeNode> leaves) {
    int i = 0;
    int locateChild = 0, locateParent = 0;
    TreeNode newNode;
    int level, n;
    bool isLeftChild = true, exist = true;
    Map<int, TreeNode> allNodes = {};

    for (TreeNode leaf in leaves) {
      level = leaf.level;
      n = leaf.n;
      locateChild = getLocate(level, n);
      allNodes[locateChild] = leaf;
      for (i = 0; i < leaf.codeword.length; i++) {
        level--;
        isLeftChild = n % 2 == 0;
        n = n ~/ 2;
        locateParent = getLocate(level, n);
        if (allNodes[locateParent] == null) {
          exist = false;
          newNode = TreeNode(level: level, n: n, num: 0, weight: 0);
          allNodes[locateParent] = newNode;
        } else {
          exist = true;
        }
        if (isLeftChild) {
          //左子树
          allNodes = _addNode(
              allNodes, locateParent, locateChild, ChildState.leftChild);
        } else {
          allNodes = _addNode(
              allNodes, locateParent, locateChild, ChildState.rightChild);
        }
        locateChild = locateParent;
        if (exist) break;
      }
    }
    allNodes = _sumWeight(allNodes, leaves);
    return allNodes;
  }

  static Map<int, TreeNode> _addNode(Map<int, TreeNode> allNodes,
      int locateParent, int locateChild, ChildState state) {
    allNodes[locateChild]!.parent = locateParent;
    if (state == ChildState.rightChild) {
      allNodes[locateParent]!.rightChild = locateChild;
    } else {
      allNodes[locateParent]!.leftChild = locateChild;
    }
    return allNodes;
  }

  static Map<int, TreeNode> _sumWeight(
      Map<int, TreeNode> allNodes, List<TreeNode> leaves) {
    int level, n, locate;
    for (TreeNode value in leaves) {
      level = value.level;
      n = value.n;
      locate = getLocate(level, n);
      while (allNodes[locate]!.parent != -1) {
        level--;
        n = n ~/ 2;
        locate = getLocate(level, n);
        allNodes[locate]!.weight += value.weight;
      }
    }
    return allNodes;
  }

  static int getLocate(int level, int n) {
    return (pow(2, level) + n - 1).toInt();
  }

  ///返回真正的层数
  static int getHeight(List<TreeNode> leaves) {
    int height = 0;
    if (leaves.isEmpty) return height;
    for (TreeNode leaf in leaves) {
      if (leaf.level + 1 > height) height = leaf.level + 1;
    }
    return height;
  }

  ///获取节点竖直偏移量
  static int getNodeVerticalOffset(int level) {
    return Constant.MARGIN_DEFAULT_TOP +
        (level + 1) * Constant.MARGIN_EACH_LEVEL +
        level * Constant.NODE_SIZE;
  }

  ///获取节点在层内的水平偏移量
  ///首先要知道节点在中轴线左右是对称的
  ///这个heiget是调用getHeiget获得的
  static double getNodeHorizontalOffset(int level, int n, int height) {
    int drop = height - level - 1;
    double ratio = n - (pow(2, level) - 1) / 2;
    double eachMargin =
        Constant.MARGIN_EACH_NODE_HORIZONTIAL * pow(2, drop) + 0.0;
    return ratio * eachMargin;
  }

  ///child(start)->parent(end)
  static Map<Offset, Offset> getLineOffsets(Map<int, TreeNode> allNodes,
      List<TreeNode> leaves, int height, double scale) {
    Map<Offset, Offset> lines = {};
    Offset start, end;
    double x, y;
    TreeNode child, parent;
    for (TreeNode leaf in leaves) {
      child = leaf;
      while (child.parent != -1) {
        parent = allNodes[child.parent]!;

        ///x,y都要加半个节点大小进行校正，否则会定位到节点左上角
        ///并且要在x上加4以修正偏移
        x = Constant.WIDGET_WIDEH / 2 +
            (HfmtreeUtil.getNodeHorizontalOffset(child.level, child.n, height) +
                    Constant.NODE_SIZE / 2 +
                    4.0) *
                scale;
        y = getNodeVerticalOffset(child.level) + Constant.NODE_SIZE / 2 + 0.0;
        y = y * scale;
        start = Offset(x, y);
        if (lines[start] == null) {
          x = Constant.WIDGET_WIDEH / 2 +
              (HfmtreeUtil.getNodeHorizontalOffset(
                          parent.level, parent.n, height) +
                      Constant.NODE_SIZE / 2 +
                      4.0) *
                  scale;
          y = getNodeVerticalOffset(parent.level) +
              Constant.NODE_SIZE / 2 +
              0.0;
          y = y * scale;
          end = Offset(x, y);
          lines[start] = end; //一个节点可能有多个子节点，但一个子节点只会有一个父节点
          child = parent;
        } else {
          break;
        }
      }
    }
    return lines;
  }
}
