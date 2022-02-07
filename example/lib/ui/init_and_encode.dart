
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huffman_compressor/huffman_compressor.dart';
import 'package:huffman_compressor_example/constant.dart';
import 'package:huffman_compressor_example/widgets/titleRow.dart';
import 'package:oktoast/oktoast.dart';

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
      body: Obx(()=>initLogic.encoding.value?_encodingWidget():
      (initLogic.encoded.value?_encodedWidget(context):
      (initLogic.fileChoosed.value?_fileChoseWidget():_fileUnchoseWidget()))),
    );
  }

  Widget _encodingWidget() {
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

  Widget _fileUnchoseWidget(){
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

  Widget _fileChoseWidget(){
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
                               initLogic.encode().then((value){
                                 if(value){
                                   initLogic.encoding.value = false;
                                   initLogic.encoded.value = true;
                                 }else{
                                  showToast('编码失败',position: ToastPosition.bottom);
                                  initLogic.encoding.value = false;
                                  initLogic.encoded.value = false;
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
                              style: const TextStyle(
                                  fontSize: Constant.FONT_SIZE
                              )
                          ),)
                        )
                      ]),),
              ],
            )),
      ],
    );
  }

  Widget _encodedWidget(BuildContext context){
    return Column(
      children: [
        const TitleRow(firstTitle: '编码表',secondTitle: '编码结果',),
        Expanded(child:_resultRow())
      ],
    );
  }

  Widget _resultRow(){
    final initLogic = Get.put(InitLogic());
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            primary: false,
              itemCount: initLogic.encodeMap.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){},
                  hoverColor: Colors.grey[100],
                  title: Text(initLogic.encodeMap[index]),
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
                    initLogic.encodeResult,
                    maxLines: null,
                      style: const TextStyle(
                          fontSize: Constant.FONT_SIZE
                      )
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
  String encodeResult = "";
  List encodeMap = [];

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

  Future<bool> encode()async{
    if(filePath.isNotEmpty){
      await HuffmanCompressor.getEncodeResult(filePath.value).then((value)async{
        if(value == null) {
          return false;
        } else{
          encodeResult = value;
          await HuffmanCompressor.getEncodeMap().then((value){
            if(value != null){
              encodeMap = value.split("<br>");
              encodeMap.removeLast();
            }
            return true;
          });
        }
      });
    }else{
      showToast('文件路径不能为空', position: ToastPosition.bottom);
      return false;
    }
    return true;
  }

  void reset(){
    encoded.value = false;
    encoding.value = false;
    fileChoosed.value = false;
    filePath.value = '';
    encodeString.value = '';
    encodeResult = '';
    encodeMap = [];
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitLogic());
  }
}