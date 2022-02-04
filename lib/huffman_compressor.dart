
import 'dart:async';

import 'package:flutter/services.dart';

class HuffmanCompressor {
  static const MethodChannel _channel = MethodChannel('huffman_compressor');

  static Future<String?>  platformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> getEncodeResult(String filename)  async {
    final String? encodeString = await _channel.invokeMethod('getEncodeResult',
        {'filename':filename});
    return encodeString;
  }

  static Future<String?> getEncodeMap()  async {
    final String? encodeMap = await _channel.invokeMethod('getEncodeMap');
    return encodeMap;
  }

  // static Future<String?> getDecodeMapString()  async {
  //   final String? jsonString = await _channel.invokeMethod('getDecodeMapString');
  //   return jsonString;
  // }

}
