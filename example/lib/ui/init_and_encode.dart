
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor_example/widgets/titleRow.dart';

class InitAndEncodePage extends StatelessWidget {


  const InitAndEncodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initLogic = Get.put(InitLogic());
    return Scaffold(
      appBar: AppBar(
        title: const Text('初始化与编码'),
        toolbarHeight: 48,
        backgroundColor: Colors.blue[600],
      ),
      body: Obx(()=>initLogic.encoding.value?encodingWidget():
      (initLogic.encoded.value?encodedWidget(context):
      (initLogic.fileChoosed.value?fileChoseWidget():fileUnchoseWidget()))),
    );
  }

  Widget encodingWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 12,),
          Text(
            '编码中',
            style: TextStyle(
                fontSize: 24
            ),
          )
        ],
      ),
    );
  }

  Widget fileUnchoseWidget(){
    final initLogic = Get.put(InitLogic());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24,),
          ElevatedButton(
            child: const Text('选择文件'),
            onPressed: ()  {
              initLogic.readFile().then((value){
                initLogic.filePath.value = value;
              });
            },
          ),
          const SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget fileChoseWidget(){
    final initLogic = Get.put(InitLogic());
    return Column(
      children: [
        const TitleRow(firstTitle: '信息',secondTitle:'文件内容',),
        Expanded(
            child: Row(
              children: [
                Expanded(
                    child:Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 24,),
                          Obx(()=>Text(
                            '文件路径:\n${initLogic.filePath.value}',
                            style: const TextStyle(
                                fontSize: 16
                            ),
                          )),
                          const SizedBox(height: 128,),
                          ElevatedButton(
                              child: const Text('重新选择文件'),
                              onPressed: ()  {
                                initLogic.readFile().then((value){
                                  initLogic.filePath.value = value;
                                });
                              },
                            ),
                          const SizedBox(height: 24,),
                          ElevatedButton(
                            child: const Text('开始初始化并编码'),
                            onPressed: ()  {
                              initLogic.encoding.value = true;
                              //TODO:调用cpp进行编码
                              Future.delayed(const Duration(seconds: 3),(){
                                if(initLogic.encode()) {
                                  initLogic.encoding.value = false;
                                  initLogic.encoded.value = true;
                                }
                              });
                            },
                          ),

                          const SizedBox(height: 24,),
                        ],
                      ),
                    )
                ),
                const VerticalDivider(color: Colors.blue,width: 1,),
                Expanded(
                  flex: 2,
                  child: ListView(
                      primary: false,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Obx(()=>Text(
                            initLogic.encodeString.value,
                            maxLines: null,
                          ),)
                        )
                      ]),),
              ],
            )),
      ],
    );
  }

  Widget encodedWidget(BuildContext context){
    return Column(
      children: [
        const TitleRow(firstTitle: '编码表',secondTitle: '编码结果',),
        Expanded(child:resultRow())
      ],
    );
  }

  Widget resultRow(){
    List list = [
      'a:1111',
      'b:11',
      'c:111',
      'd；1',
      'a:1111',
      'b:11',
      'c:111',
      'd；1',
      'a:1111',
      'b:11',
      'c:111',
      'd；1',
      'a:1111',
      'b:11',
      'c:111',
      'd；1',     'a:1111',
      'b:11',
      'c:111',
      'd；1',     'a:1111',
      'b:11',
      'c:111',
      'd；1',
      'a:1111',
      'b:11',
      'c:111',
      'd；1',
    ];
    String str = '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
        '11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            primary: false,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){},
                  hoverColor: Colors.grey[100],
                  title: Text(list[index]),
                );
              }),
        ),
        const VerticalDivider(color: Colors.blue,width: 1,),
        Expanded(
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
        ),
      ],
    );
  }

}

class InitLogic extends GetxController {

  RxBool encoded = false.obs;
  RxBool encoding = false.obs;
  RxBool fileChoosed = false.obs;
  RxString filePath = ''.obs;
  RxString encodeString = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //
  // }

  Future<String> readFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      await file.readAsString().then((value){
        encodeString.value = value;
        fileChoosed.value = true;
      });
      return result.files.single.path!;
    } else {
      return '';
    }
  }

  bool encode(){
return true;
  }
  //
  // @override
  // void onClose() {
  //
  // }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitLogic());
  }
}