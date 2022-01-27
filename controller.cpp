#include "huffman.cpp"
#include "./dist/json/json.h"
#include "./dist/jsoncpp.cpp"
//Controller controller;
HuffmanTree huff;
string buildTreeAndEncode(const string& filename){
    huff.ReadFile(filename);
    huff.buildTree();
    return huff.encodeResult;
}

void getCodeMap(){
    std::string jsonStr;
    Json::Value map;
    Json::StreamWriterBuilder writerBuilder;
    std::ostringstream os;
    Leaf* l;
    string str;
    int i = 0;
    for (auto & leave : huff.leaves) {
        l = huff.leaves.at(leave.first);
        string s(1,l->key);
        str = s+":"+l->codeword;
        map[i] = str;
        i++;
    }
    std::unique_ptr<Json::StreamWriter> jsonWriter(writerBuilder.newStreamWriter());
    jsonWriter->write(map, &os);
    jsonStr = os.str();
    std::cout << jsonStr << std::endl;
}

void getEncodedString(){
   cout<< huff.encodeResult<<endl;
}



int main(){

    string str = "D:\\myCppProject\\untitled\\iHaveADream.txt";
    buildTreeAndEncode(str);
    str = "D:\\myCppProject\\untitled\\iHaveADream.txt";
    huff.ReadFile(str);
    str = "../iHaveADream_output.txt";
    huff.encode(str);
    getCodeMap();
    getEncodedString();
    return 0;
}
