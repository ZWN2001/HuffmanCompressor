import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/widgets/titleRow.dart';

class DecodePage extends StatelessWidget {
  const DecodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final decodeLogic = Get.put(DecodeLogic());
    return Scaffold(
      appBar: AppBar(
        title: const Text('解码'),
        toolbarHeight: 48,
        backgroundColor: Colors.blue[600],
      ),
      body: decodeBody(),
    );
  }

  Widget decodeBody(){
    return Column(
    children: [
      const TitleRow(firstTitle: '解码内容',secondTitle: '解码结果',),
      Expanded(child: resultRow(),),
    ],
    );
  }

  Widget resultRow(){
    final decodeLogic = Get.put(DecodeLogic());
    String str = '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
    return Row(
      children: [
        Expanded(
          child: ListView(
              primary: false,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Text(
                    str,
                    maxLines: null,
                  ),
                )
              ]),
        ),
        const VerticalDivider(color: Colors.blue,width: 1,),
        Obx(()=>decodeLogic.decoding.value?decodingWidget():
        (decodeLogic.decoded.value?decodedWidget():undecodeWidget())),
      ],
    );
  }

  Widget decodingWidget() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 12,),
          Text(
            '解码中',
            style: TextStyle(
                fontSize: 24
            ),
          )
        ],
      ),
    );
  }

  Widget undecodeWidget(){
    final decodeLogic = Get.put(DecodeLogic());
    return Expanded(
      flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('开始解码'),
              onPressed: (){
                decodeLogic.decoding.value = true;
                //TODO:调用cpp进行编码
                Future.delayed(const Duration(seconds: 3),(){
                  if(decodeLogic.decode()) {
                    decodeLogic.decoding.value = false;
                    decodeLogic.decoded.value = true;
                  }
                });
              },
            )
          ],
        )
    );
  }

  Widget decodedWidget(){
    String str = '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
    return  Expanded(
      flex: 2,
      child: ListView(
          primary: false,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                str,
                maxLines: null,
              ),
            )
          ]),
    );
  }

}

class DecodeLogic extends GetxController {
  RxBool decoded = false.obs;
  RxBool decoding = false.obs;

  bool decode(){
    return true;
  }

  List<String> jsonToList(String str){
    return json.decode(str).sort((a,b)=>a.length.compareTo(b.length));
  }
}

class DecodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DecodeLogic());
  }
}