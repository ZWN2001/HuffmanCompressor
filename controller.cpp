#include "huffman.cpp"
#include "./dist/json/json.h"
#include "./dist/jsoncpp.cpp"
//Controller controller;
HuffmanTree* huff = new HuffmanTree();
string buildTreeAndEncode(const string& filename){
        huff->ReadFile(filename);
        huff->buildTree();
    return huff->encodeResult;
}

string decode(const string& filename){
    huff->ReadFile(filename);
    huff->decodeWithMap();
    return huff->decodeResult;
}

string getCodeMapJsonStr(){
    std::string jsonStr;
    Json::Value map;
    Json::StreamWriterBuilder writerBuilder;
    std::ostringstream os;
    Leaf* l;
    string str;
    int i = 0;
    for (auto & leave : huff->leaves) {
        l = huff->leaves.at(leave.first);
        string s(1,l->key);
        str = s+":"+l->codeword;
        map[i] = str;
        i++;
    }
    std::unique_ptr<Json::StreamWriter> jsonWriter(writerBuilder.newStreamWriter());
    jsonWriter->write(map, &os);
    jsonStr = os.str();
    return  jsonStr;
}

//string getEncodedString(){
//    return  huff->encodeResult;
//}

void refresh(){
delete huff;
huff = new HuffmanTree();
}



int main(){
    char c = '1';
    int i = int(c) - 48;
    cout<<i;
    string str = "../tobetrans.txt";
    buildTreeAndEncode(str);

    str = "../tobetrans.txt";
    huff->ReadFile(str);
    str = "D:\\myCppProject\\untitled\\codefile.txt";
    huff->encode(str);

    getCodeMapJsonStr();


    decode("../codefile.txt");
    huff->writeTree("../hfmtree.txt");
    huff->readTree("../hfmtree.txt");
    refresh();
    return 0;
}
