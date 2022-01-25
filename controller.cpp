#include "huffman.cpp"

//Controller controller;
HuffmanTree huff;
string buildTreeAndEncode(const string& filename){
    huff.ReadFile(filename);
    huff.buildTree();
    return huff.encodeResult;
}

void getCodeMap(){
    for (auto & leave : huff.leaves) {

    }
}



int main(){

    HuffmanTree huff;
    string str = "D:\\myCppProject\\untitled\\iHaveADream.txt";
    buildTreeAndEncode(str);
    str = "D:\\myCppProject\\untitled\\iHaveADream.txt";
    huff.ReadFile(str);
    str = "../iHaveADream_output.txt";
    huff.encode(str);
    return 0;
}
