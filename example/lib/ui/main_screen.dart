import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/widgets/side_menu.dart';
import 'package:huffman_compressor_example/widgets/windows_buttons.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 156,
            child: SideMenu(),
          ),
          Expanded(
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                    Expanded(child: MoveWindow()),
                    const WindowButtons()
                  ])),
            ]),
          ),
        ],
      ),
    );
  }
}

class MainScreenLogic extends GetxController{

}

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenLogic());
  }
}