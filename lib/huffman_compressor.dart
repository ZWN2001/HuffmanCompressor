
import 'dart:async';

import 'package:flutter/services.dart';

class HuffmanCompressor {
  static const MethodChannel _channel = MethodChannel('huffman_compressor');

  static Future<String?>  platformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> getEncodeResult()  async {
    final String? jsonString = await _channel.invokeMethod('getEncodeResult');
    return jsonString;
  }

  static Future<String?> getDecodeMapString()  async {
    final String? jsonString = await _channel.invokeMethod('getDecodeMapString');
    return jsonString;
  }

}
