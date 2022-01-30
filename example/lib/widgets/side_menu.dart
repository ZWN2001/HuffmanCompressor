import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/ui/main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenController = Get.put(MainScreenLogic());
    return Drawer(
      child: Obx((){
        return ListView(
          children: [
            DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6,),
                    SizedBox(
                        width: 100,
                        height: 100,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/images/avatar.jpg"),
                        )
                    ),
                    const Spacer(),
                    const Text(
                      'ZWN',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue
                      ),)
                  ],
                )
            ),
            DrawerListTile(
              title: "初始化&编码",
              svgSrc: "assets/icons/encode.svg",
              isSelected: mainScreenController.selectedItem.value == 0,
              press: () {
                mainScreenController.selectedItem.value = 0;
              },
            ),
            DrawerListTile(
              title: "解码",
              svgSrc: "assets/icons/decode.svg",
              isSelected: mainScreenController.selectedItem.value == 1,
              press: () {
                mainScreenController.selectedItem.value = 1;
              },
            ),
            DrawerListTile(
              title: "霍夫曼树",
              svgSrc: "assets/icons/tree.svg",
              isSelected: mainScreenController.selectedItem.value == 2,
              press: () {
                mainScreenController.selectedItem.value = 2;
              },
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: ElevatedButton(
                child: const Text('重置'),
                onPressed: (){
                  FlutterToastr.show( 'msg',context);
                },
              ),
            ),
          ],
        );
      })
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading:  SvgPicture.asset(
        svgSrc,
        color: isSelected?Colors.blue[900]:Colors.blue[400],
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: isSelected?Colors.blue[900]:Colors.blue[400],),
      ),
    );
  }
}