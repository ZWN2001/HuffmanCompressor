import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';
import 'package:huffman_compressor_example/widgets/hfmtree_widget.dart';

class HfmTreePage extends StatelessWidget {
  const HfmTreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hfmTreeLogic = Get.put(HfmTreeLogic());
    return Scaffold(
      appBar: AppBar(
        title: const Text('霍夫曼树'),
        toolbarHeight: 48,
        backgroundColor: Colors.blue[600],
      ),
      body: Obx(() => (!hfmTreeLogic.hfmFileChose.value)
          ? _unChoseFileWidget()
          : (hfmTreeLogic.building.value
              ? _buildingWidget()
              : HfmtreeWidget(
                  leaves: hfmTreeLogic.leaves,
                  allNodes: hfmTreeLogic.allNodes,
                ))),
    );
  }

  Widget _unChoseFileWidget() {
    final hfmTreeLogic = Get.put(HfmTreeLogic());
    return Center(
      child: ElevatedButton(
        child: const Text('选择文件'),
        onPressed: () {
          hfmTreeLogic.readFile();
        },
      ),
    );
  }

  Widget _buildingWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 12,
          ),
          Text(
            '构建中',
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}

class HfmTreeLogic extends GetxController {
  List<TreeNode> leaves = [];
  Map<int, TreeNode> allNodes = {};
  List<String> _infos = [];
  late TreeNode _node;
  RxBool hfmFileChose = false.obs;
  RxBool building = false.obs;

  Future<void> readFile() async {
    FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    ).then((value) {
      if (value != null) {
        hfmFileChose.value = true;
        building.value = true;
        File(value.files.single.path!)
            .openRead()
            .map(utf8.decode)
            .transform(const LineSplitter())
            .forEach((line) {
//    l->key<<":"<<l->codeword<<":"<<l->level<<":"<<l->n<<":"<<l->p->num<<":"<<l->p->weight
//       0            1                  2            3               4                 5
          _infos = line.split(":");
          _node = TreeNode(
              key: _infos[0],
              codeword: _infos[1],
              level: int.parse(_infos[2]),
              n: int.parse(_infos[3]),
              num: int.parse(_infos[4]),
              weight: int.parse(_infos[5]));
          leaves.add(_node);
        }).whenComplete(() {
          allNodes = HfmtreeUtil.buildTreeWithLeaves(leaves);
          building.value = false;
        });
      }
    });
  }

  void reset() {
    leaves = [];
    allNodes = {};
    _infos = [];
    hfmFileChose.value = false;
    building.value = false;
  }
}

class HfmTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HfmTreeLogic());
  }
}
