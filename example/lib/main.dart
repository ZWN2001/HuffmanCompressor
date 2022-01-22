import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:huffman_compressor_example/util/windowsButtons.dart';

void main() {
  runApp( const MyApp());
  doWhenWindowReady(() {
    appWindow.title = "霍夫曼编解码";
    const initialSize = Size(1200, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('霍夫曼编解码'),
        // ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const SizedBox(
                width: 156,
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
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
      ),
    );
  }
}


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 110,
              height: 110,
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
            title: "初始化",
            svgSrc: "assets/icons/init.svg",
            press: () {

            },
          ),
            DrawerListTile(
              title: "编码",
              svgSrc: "assets/icons/encode.svg",
              press: () {

              },
            ),
          DrawerListTile(
            title: "解码",
            svgSrc: "assets/icons/decode.svg",
            press: () {

            },
          ),
          DrawerListTile(
            title: "编码结果",
            svgSrc: "assets/icons/print.svg",
            press: () {

            },
          ),
          DrawerListTile(
            title: "霍夫曼树",
            svgSrc: "assets/icons/tree.svg",
            press: () {

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
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading:  SvgPicture.asset(
        svgSrc,
        color: Colors.blue,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}

