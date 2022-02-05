import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor/huffman_compressor.dart';
import 'package:huffman_compressor_example/constant.dart';
import 'package:huffman_compressor_example/widgets/titleRow.dart';
import 'package:oktoast/oktoast.dart';

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
      body: _decodeBody(),
    );
  }

  Widget _decodeBody(){
    return Column(
    children: [
      const TitleRow(firstTitle: '解码内容',secondTitle: '解码结果',),
      Expanded(child: _resultRow(),),
    ],
    );
  }

  Widget _resultRow(){
    final decodeLogic = Get.put(DecodeLogic());
    return Row(
      children: [
        Expanded(
          child: ListView(
              primary: false,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Obx(()=>Text(
                    decodeLogic.decodeString.value,
                    maxLines: null,
                      style: const TextStyle(
                          fontSize: Constant.FONT_SIZE
                      )
                  ),),
                )
              ]),
        ),
        const VerticalDivider(color: Colors.blue,width: 1,),
        Obx(()=>decodeLogic.decoding.value?_decodingWidget():
        (decodeLogic.decoded.value?_decodedWidget():_undecodeWidget())),
      ],
    );
  }

  Widget _decodingWidget() {
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

  Widget _undecodeWidget(){
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
                decodeLogic.decode().then((value){
                  if(value){
                    decodeLogic.decoding.value = false;
                    decodeLogic.decoded.value = true;
                  }else{
                    showToast('解码失败',position: ToastPosition.bottom);
                    decodeLogic.decoding.value = false;
                    decodeLogic.decoded.value = false;
                  }
                });
              },
            )
          ],
        )
    );
  }

  Widget _decodedWidget(){
    final decodeLogic = Get.put(DecodeLogic());
    return  Expanded(
      flex: 2,
      child: ListView(
          primary: false,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                decodeLogic.decodeResult,
                maxLines: null,
                style: const TextStyle(
                  fontSize: Constant.FONT_SIZE
                )
              ),
            )
          ]),
    );
  }

}

class DecodeLogic extends GetxController {
  RxBool decoded = false.obs;
  RxBool decoding = false.obs;
  String decodeResult = '';
  RxString decodeString = ''.obs;

  @override
  void onInit()  {
    super.onInit();
    File file = File("C:\\codefile\\codefile.txt");
     file.readAsString().then((value){
      decodeString.value = value;
    });
  }

  Future<bool> decode() async {
    await HuffmanCompressor.getDecodeResult().then((value){
      if(value == ''||value == null||value.isEmpty) return false;
      decodeResult = value;
      return true;
    });
    return true;
  }

  void reset(){
    decoded.value = false;
    decoding.value = false;
    decodeResult = '';
    decodeString.value = '';
  }
}

class DecodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DecodeLogic());
  }
}