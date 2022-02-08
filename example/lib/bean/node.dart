class TreeNode {
  late String key;
  late String codeword;
  late int level;
  late int n;
  late int num;
  late int weight;
  int leftChild = -1;
  int rightChild = -1;
  int parent = -1;
  int x = 0;
  int y = 0;

  TreeNode(
      {this.key = '',
      this.codeword = '',
      required this.level,
      required this.n,
      required this.num,
      required this.weight,
      this.x = 0,
      this.y = 0});

  @override
  String toString() {
    return 'TreeNode{key: $key, codeword: $codeword, level: $level, n: $n, num: $num, '
        'weight: $weight, leftChild: $leftChild, rightChild: $rightChild, parent: $parent, x: $x, y: $y}';
  }
}

enum ChildState {
  leftChild,
  rightChild,
}
