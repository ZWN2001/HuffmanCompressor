import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/ui/decode.dart';
import 'package:huffman_compressor_example/ui/hfmTree.dart';
import 'package:huffman_compressor_example/ui/init_and_encode.dart';
import 'package:huffman_compressor_example/widgets/side_menu.dart';
import 'package:huffman_compressor_example/widgets/windows_buttons.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenController = Get.put(MainScreenLogic());
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 170,
            child: SideMenu(),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                    Expanded(child: MoveWindow(
                      child: Container(
                        color: Colors.blue,
                        child: const Center(
                            child:Text(
                                '霍夫曼编解码',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    )),
                    const WindowButtons()
                  ])),
              Expanded(
                  child: Obx(()=>mainScreenController.list[mainScreenController.selectedItem.value])
              )

            ]),
          ),
        ],
      ),
    );
  }
}

class MainScreenLogic extends GetxController{
  RxInt selectedItem = 0.obs;
  final List<Widget> list = [
    const InitAndEncodePage(),
    const DecodePage(),
    const HfmTreePage(),
  ];
}

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenLogic());
  }
}