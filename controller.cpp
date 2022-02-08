#include "huffman.cpp"

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

void refresh(){
delete huff;
huff = new HuffmanTree();
}

int main(){
    string str = "C:\\codefile\\tobetrans.txt";
    buildTreeAndEncode(str);
    str = "C:\\codefile\\tobetrans.txt";
    huff->ReadFile(str);
    huff->encode("C:\\codefile","codefile.txt");
    decode("C:\\codefile\\encodeResult.txt");
    huff->writeTree("C:\\codefile\\hfmtree.txt");
    huff->readTree("C:\\codefile\\hfmtree.txt");
//    refresh();
    return 0;
}
