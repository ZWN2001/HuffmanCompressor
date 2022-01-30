import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/bean/node.dart';
import 'package:huffman_compressor_example/util/hfmtree_util.dart';

class HfmTreePage extends StatelessWidget {
  const HfmTreePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hfmTreeLogic = Get.put(HfmTreeLogic());
    return Container(child: ElevatedButton(
      child: Text('a'),
      onPressed: (){
        hfmTreeLogic.readFile();
      },
    ),);
  }
}

class HfmTreeLogic extends GetxController {

  List<TreeNode> leaves = [];
  List<String> infos = [];
  late TreeNode node;

  Future<void> readFile() async {
     FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    ).then((value){
       if (value != null) {
         File(value.files.single.path!).openRead()
             .map(utf8.decode)
             .transform( const LineSplitter())
             .forEach((line) {
//    l->key<<":"<<l->codeword<<":"<<l->level<<":"<<l->n<<":"<<l->p->num<<":"<<l->p->weight
//       0            1                  2            3               4                 5
           infos = line.split(":");
           node = TreeNode(key: infos[0], codeword: infos[1], level: int.parse(infos[2]),
               n: int.parse(infos[3]), num: int.parse(infos[4]), weight: int.parse(infos[5]));
           leaves.add(node);
         }).whenComplete((){
           HfmtreeUtil.buildTreeWithLeaves(leaves);
         });
       }
    });

  }


}

class HfmTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HfmTreeLogic());
  }
}
