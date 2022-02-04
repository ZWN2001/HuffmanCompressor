#include "include/huffman_compressor/huffman_compressor_plugin.h"

// This must be included before many other Windows headers.
#include <winsock.h>
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include "include/huffman.cpp"
namespace {

class HuffmanCompressorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HuffmanCompressorPlugin();

  virtual ~HuffmanCompressorPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

    HuffmanTree* huff = new HuffmanTree();
    string buildTreeAndEncode(const string& filename){
        try {
          huff->ReadFile(filename);
        huff->buildTree();
        huff->ReadFile(filename);
        huff->encode("C:\\codefile\\codefile.txt");
        }
        catch (string e) {
            return e;
        }
        return huff->encodeResult;
    }

    string decode(const string& filename){
        huff->ReadFile(filename);
        huff->decodeWithMap();
        return huff->decodeResult;
    }

    string getCodeStr(){
       string str;
        Leaf* l;
        for (auto & leave : huff->leaves) {
            l = huff->leaves.at(leave.first);
            string s(1,l->key);
            str.append(s+":"+l->codeword);
            str.append(",");
        }
        return  str;
    }

    string getEncodedString(){
        return  huff->encodeResult;
    }

    void refresh(){
        delete huff;
        huff = new HuffmanTree();
    }

// static
void HuffmanCompressorPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "huffman_compressor",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<HuffmanCompressorPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

HuffmanCompressorPlugin::HuffmanCompressorPlugin() {}

HuffmanCompressorPlugin::~HuffmanCompressorPlugin() {}

void HuffmanCompressorPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());

  if (method_call.method_name().compare("getEncodeResult") == 0) {
      std::string filename,resultString;
      std::ostringstream os;
          auto filename_it = arguments->find(flutter::EncodableValue("filename"));
          if (filename_it != arguments->end()){
              filename = std::get<std::string>(filename_it->second);
              resultString = buildTreeAndEncode(filename);
              os<<resultString;
          }
          result->Success(flutter::EncodableValue(os.str()));
  }
  if (method_call.method_name().compare("getEncodeMap") == 0) {
      std::ostringstream os;
       os<<getCodeStr();
        result->Success(flutter::EncodableValue(os.str()));
    }else {
    result->NotImplemented();
  }
}

}  // namespace

void HuffmanCompressorPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  HuffmanCompressorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
