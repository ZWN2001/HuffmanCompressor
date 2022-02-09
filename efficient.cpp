#include<iostream>
#include<cstdio>
#include<string>
#include<conio.h>
#include<io.h>
#include <ctime>
#include <windows.h>

using namespace std;

// 256 个字符，最多有 2 * 256 - 1 = 511个节点，这里用 512 + 5
#define MAXLEN 512+5
#define ASCLLNUM 256

//哈夫曼树节点
typedef struct huffmanNode {
    int parent, lchild, rchild; //二叉树关系
    unsigned long weight;      //符号个数
    unsigned char key;          //符号
    char code[MAXLEN];           //编码

} HuffmanNode;

//存放文件中各个字符，及其出现次数
typedef struct characters {
    unsigned char key;          //符号
    unsigned long weight;      //符号个数
} Characters;

void showGUI() {
    cout << "霍夫曼编解码\n\n";
    cout << "     1.压缩" << endl;
    cout << "     2.解压缩" << endl;
    cout << endl;
    cout << endl;
    cout << "请选择操作：";
}

void select(HuffmanNode *HN, int i, int *s1, int *s2) {
    unsigned int j, s;
    s = 0; //记录当前找到的最小权值的结点的下标
    for (j = 1; j <= i; j++) {
        if (HN[j].parent == 0)   //找最小
        {
            if (s == 0) //第一个找到的点
                s = j;
            if (HN[j].weight < HN[s].weight)
                s = j;
        }
    }
    *s1 = s;

    s = 0;
    for (j = 1; j <= i; j++) {   //找次小
        if ((HN[j].parent == 0) && (j != *s1)) { //仅比上面一个多了J!=*s1，应为不能是最小
            if (s == 0)
                s = j;
            if (HN[j].weight < HN[s].weight)
                s = j;
        }
    }
    *s2 = s;
}

//创建的哈夫曼树是以一维数组建立，同时起始地址是1。
int creatHuffmanTree(HuffmanNode *HN, Characters *ascll) {
    int i, s1, s2, leafNum, j = 0;

    //初始化叶节点,256个ascll字符
    for (i = 0; i < 256; i++) {
        //只使用出现的过的字符 ascll[i].weight > 0
        if (ascll[i].weight > 0) {
            HN[++j].weight = ascll[i].weight;
            HN[j].key = ascll[i].key;
            HN[j].parent = HN[j].lchild = HN[j].rchild = 0;
        }
    }
    leafNum = j;
    int nodeNum = 2 * leafNum - 1; //节点个数

    //初始化内部节点
    for (i = leafNum + 1; i <= nodeNum; i++) {
        HN[i].weight = 0;
        HN[i].code[0] = 0;
        HN[i].parent = HN[i].lchild = HN[i].rchild = 0;
    }
    //给内部节点找孩子
    for (i = leafNum + 1; i <= nodeNum; i++) {
        select(HN, i - 1, &s1, &s2); //找到当前最小和次小的树根
        HN[s1].parent = i;
        HN[s2].parent = i;
        HN[i].lchild = s2;
        HN[i].rchild = s1;
        HN[i].weight = HN[s1].weight + HN[s2].weight;
    }
    return leafNum;
}

void HuffmanCoding(char *hTable[ASCLLNUM], HuffmanNode *HT, int leafNum) {
    int i, j, m, c, f, start;
    char cd[MAXLEN];
    m = MAXLEN;
    cd[m - 1] = 0;
    for (i = 1; i <= leafNum; i++) {
        start = m - 1;
        //先是从后往前编码，从子叶开始编码
        for (c = i, f = HT[c].parent; f != 0; c = f, f = HT[f].parent) { //找父节点
            //判断自己c是父节点的哪个孩子
            if (HT[f].lchild == c) {
                cd[start--] = '0';
            } else {
                cd[start--] = '1';
            }
        }
        // [0 0 0 0 0 start 0 1 0 1 1], start 表示偏移，m-start 表示压入的01的长度，start到达根
        start++;
        for (j = 0; j < m - start; j++) {
            // 获取字符编码
            HT[i].code[j] = cd[start + j];
            // 编码 [叶子]---[根]
        }
        // 添加结尾
        HT[i].code[j] = '\0';
        //写入字符-频数表
        hTable[HT[i].key] = HT[i].code;
    }
}

void compress() {
    FILE *infile, *outfile;
    char infileName[MAXLEN], outfileName[MAXLEN];
    cout << "\n请输入你想要压缩的文件路径:";
    cin >> infileName;
    // 打开文件
    infile = fopen(infileName, "rb");
    while (infile == NULL) {
        cout << "文件：" << infileName << "不存在..." << endl;
        cout << "重新输入需压缩文件路径(1)或返回主菜单(2)?" << endl;
        char option;
        cin >> option;
        while (option != '1' && option != '2') {
            cout << endl;
            cout << "无效输入！" << endl;
            cout << "重新输入文件名(1)或返回主菜单(2)?" << endl;
            cin >> option;
        }
        if (option == '2') {
            return;
        }
        cout << "\n请输入需压缩文件路径：";
        cin >> infileName;
        // 读取文件
        infile = fopen(infileName, "rb");
    }

    // 创建文件名
    strcpy(outfileName, infileName);
    strcat(outfileName, ".hfmc");
    // 判断文件是否存在
    // 对文件进行操作，判断文件是否存在
    while ((_access(outfileName, 0)) != -1) {
        cout << "文件：" << outfileName << "已存在..." << endl;
        cout << "是否替换原文件？(Y/N)：";
        char option;
        cin >> option;
        while (option != 'Y' && option != 'N' && option != 'y' && option != 'n') {
            cout << "\n无效输入！" << endl;
            cout << "请输入Y或者N：";
            cin >> option;
        }
        if (option == 'Y' || option == 'y') {
            break;
        }
        cout << "输入压缩文件文件路径(含拓展名)：";
        cin >> outfileName;

        cout << outfileName; //DEB
    }
    //判断是否可以创建该文件，如果不行，表示无法再文件系统中创建该文件。输入内容有误
    outfile = fopen(outfileName, "wb");
    if (outfile == NULL) {
        cout << "\n无法创建该压缩文件..." << endl;
        cout << "输入任意键返回主菜单...";
        _getch();
        return;
    }

    cout << "文件压缩中..." << endl;

    //[TIME-START]
    LARGE_INTEGER t1,t2,tc;
    QueryPerformanceFrequency(&tc);
    QueryPerformanceCounter(&t1);

    //统计字符种类数和频数
    unsigned char c;
    int i, k;
    unsigned long total = 0;              //文件长度

    // 利用hash表存放字母表及字母出现频数
    Characters ascll[ASCLLNUM];
    for (i = 0; i < ASCLLNUM; i++) {
        ascll[i].weight = 0;
    }

    while (!feof(infile)) {
        c = fgetc(infile);
        ascll[c].key = c;
        ascll[c].weight++;
        total++; //读取到的字符个数
    }
    total--;
// 创建 节点数组
    HuffmanNode HN[MAXLEN];
    int leafNum = creatHuffmanTree(HN, ascll);

    char *hTable[MAXLEN];
    for (i = 0; i < ASCLLNUM; i++) {
        hTable[i] = new char[MAXLEN];
    }
// 哈夫曼编码
    HuffmanCoding(hTable, HN, leafNum);

//写头文件 -- 将压缩的哈夫曼树编码信息写入哈夫曼树
    fseek(infile, 0, 0);
    fwrite(&total, sizeof(unsigned long), 1, outfile);          //原文件总长度

    for (i = 0; i <= 255; i++) {
        // 将哈夫曼树按照 unsigned long 的方式压入文件中，下标表示字母，数值表示字母的频数
        fwrite(&ascll[i].weight, sizeof(unsigned long), 1, outfile);
    }

//开始压缩主文件
    unsigned long j = 0;             //最大为total
    string buf = "\0";
    int charNum = 2;

    while (!feof(infile)) {
        c = fgetc(infile);
        string tempCode = hTable[c];
        j++;
        buf += tempCode;
        k = buf.length();
        c = 0;
        // 将所得的 0 1 每8个就可以构建一个字母的方式压入文件用
        while (k >= 8) {
            for (i = 0; i < 8; i++) {
                // 利用左移以为在右边空出一个空位
                // 利用与 1 取或的方式压入 bit 1
                if (buf[i] == '1')
                    c = (c << 1) | 1;
                else
                    c = c << 1;
            }
            fwrite(&c, sizeof(unsigned char), 1, outfile);
            charNum++;
            buf.erase(0, 8);
            // 确定剩下的bit 的长度，如果大于8表示还可以压成一个字节
            k = buf.length();
        }
        if (j == total) {
            break;
        }
    }

    // 当 k < 8 时，表示还剩下不足 8 位的bit，需要拓展0位压缩
    if (k > 0)            //可能还有剩余字符{
        buf += "00000000";
    for (i = 0; i < 8; i++) {
        if (buf[i] == '1')
            c = (c << 1) | 1;
        else
            c = c << 1;
    }
    fwrite(&c, sizeof(unsigned char), 1, outfile);
    charNum++;
// 关闭打开的文件
    fclose(infile);
    fclose(outfile);

//[TIME-END]
    QueryPerformanceCounter(&t2);
    double time1=(double)(t2.QuadPart-t1.QuadPart)/(double)tc.QuadPart;
    cout << "压缩成功！" << endl;
    float s;
    s = (float) charNum / (float) total;
    cout << "压缩率为：" << s << endl;
    cout << "耗时为：" << time1<< " s" << endl;
    _getch();
}

void decompress() {
    FILE *infile, *outfile;
    char infilename[255], outfilename[255];
    cout << "请输入要解压的文件的文件路径(不含.hfmc)：";
    cin >> outfilename;

    // 构建解压文件名
    strcpy(infilename, outfilename);
    strcat(infilename, ".hfmc");

    infile = fopen(infilename, "rb");
    //循环判断文件是否存在
    while (infile == NULL) {
        char option;
        cout << "文件" << infilename << "不存在...\n";
        cout << "重新输入文件名（1）或返回主菜单（2）？";
        cin >> option;
        while (option != '1' && option != '2') {
            cout << "\n无效的输入！\n";
            cout << "重新输入文件名（1）或返回主菜单（2）？";
            cin >> option;
        }
        if (option == '2') {
            return;
        } else {
            cout << "\n请输入要解压的文件的文件路径(不含.hfmc)：";

            cin >> outfilename;

            // 构建解压文件名
            strcpy(infilename, outfilename);
            strcat(infilename, ".hfmc");

            infile = fopen(infilename, "rb");
        }
    }
    // 输入解压后的文件名
    outfile = fopen(outfilename, "wb");
    if (outfile == NULL) {
        cout << "\n解压文件失败！无法创建解压后的文件...";
        cout << "\n按任意键回到主菜单...";
        _getch();
        return;
    }
    cout << "解压文件中..." << endl;
    //[TIME-BEGIN]
    LARGE_INTEGER t1,t2,tc;
    QueryPerformanceFrequency(&tc);
    QueryPerformanceCounter(&t1);

    unsigned long total = 0;
    // 将第一个 long 长度数据读入 tatol 中，为文件的总大小
    fread(&total, sizeof(unsigned long), 1, infile);

    Characters ascll[ASCLLNUM];
    int i;
    for (i = 0; i < ASCLLNUM; i++) {
        // 之后的每个long长度都是一个字符的频数
        fread(&ascll[i].weight, sizeof(unsigned long), 1, infile);
        ascll[i].key = i;
    }

    HuffmanNode HN[MAXLEN];
    // 创建哈夫曼树
    int leafNum = creatHuffmanTree(HN, ascll);

    fseek(infile, sizeof(unsigned long) * 257, 0);
    unsigned char c;

    int index = 2 * leafNum - 1;
    int charNum = 0;
    while (!feof(infile)) {
        // 按照字母读取
        c = fgetc(infile);

        // 从根节点往叶子走，读取到的是一个 字母（8位）， 所以使用循环8次
        for (i = 0; i < 8; i++) {
            unsigned int cod = (c & 128);
            c = c << 1;
            if (cod == 0) {
                index = HN[index].lchild;
            } else {
                index = HN[index].rchild;
            }
            if (HN[index].rchild == 0 && HN[index].lchild == 0) {
                charNum++;
                // 到达叶子
                unsigned char trueChar = HN[index].key;
                fwrite(&trueChar, sizeof(unsigned char), 1, outfile);
                // index 重新指向根节点
                index = 2 * leafNum - 1;
                if (charNum >= total) {
                    break;
                }
            }
        }
        if (charNum >= total) {
            break;
        }
    }

    // 关闭打开的文件
    fclose(infile);
    fclose(outfile);

    //[TIME-END]

    QueryPerformanceCounter(&t2);
    double time2 =(double)(t2.QuadPart-t1.QuadPart)/(double)tc.QuadPart;

    cout << "解压成功" << endl;
    cout << "耗时为：" << time2 << " s" << endl;
    _getch();
}

int main() {
    while (true) {
        showGUI();
        char option;
        cin >> option;
        while (option != '1' && option != '2') {
            cout << "无效的输入！\n";
            cout << "请选择操作：";
            cin >> option;
        }
        switch (option) {
            case '1': {
                compress();
                break;
            }
            case '2': {
                decompress();
                break;
            }
            default: {
                cout << "退出" << endl;
                return 0;
            }
        }
        system("cls");
    }
}