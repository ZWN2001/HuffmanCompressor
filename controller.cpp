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


//string getEncodedString(){
//    return  huff->encodeResult;
//}

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

//    getCodeMapJsonStr();


    decode("C:\\codefile\\codefile.txt");
    huff->writeTree("C:\\codefile\\hfmtree.txt");
    huff->readTree("C:\\codefile\\hfmtree.txt");
//    refresh();
    return 0;
}


//#include <Windows.h>
//#include <iostream>
//#include <fstream>
//#include <cstdio>
//#include <string>
//#include <vector>
//
//using namespace std;
//
//std::vector<string> getEachString(const string& str) { //将分割后的子字符串存储在vector中
//    vector<string> res;
//    if (str.empty()) return res;
//    string eachString = "";
//    size_t size = str.size();
//
//    for (int i = 0; i < size; ++i) {
//        cout<<str.substr(i,1);
//        res.push_back(str.substr(i,1));
//    }
//    return res;
//}
//int main()
//{
//    string str = "";
//    wchar_t wch = '中';
//    char ch = 'b';
//    cout<<"char : "<<ch<<wch<<endl;
//
//    char filename[MAX_PATH];
//    GetModuleFileName(NULL,filename, MAX_PATH);
//    str = (string)filename;
//    int pos = str.find_last_of('\\',str.length());
//    str = str.substr(0,pos);
//    char * ch2 = const_cast<char *>(str.c_str());
//    cout<<"file path: "<< ch2<<endl;
//
//    str += "\\read.txt";
//
//    ifstream ifs;
//    ifs.open(str);
//    if (!ifs.is_open())
//    {
//        cout<<"open file "<<str<<"	failed"<<endl;
//    }
//    else
//    {
//        string con = "";
//        int count = 0;
////        getline(ifs,con);
//
//        do{
//            getline(ifs,con);
//            ++count;
//            cout<<count<<":	"<<con<<endl;
//            getEachString(con);
//
//        }while (ifs);
//    }
//    return 0;
//}
