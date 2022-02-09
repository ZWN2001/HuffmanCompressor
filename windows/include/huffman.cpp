#include <iostream>
#include <stack>
#include <cmath>
#include <windows.h>
#include <vector>
#include "huffman.h"
#include <clocale>


int HuffmanTree::sum = 1;
using namespace std;
//二叉树成员函数实现
BinaryTree::BinaryTree(int num,int weight){
    p_root = new Node(nullptr,nullptr,nullptr);
    p_root->num = num;
    p_root->weight = weight;
}

BinaryTree::~BinaryTree(){
    deleteNode(p_root);
}

bool BinaryTree::swap(Node * p_nodeA, Node * p_nodeB){
    if(p_nodeA==nullptr||p_nodeB==nullptr||p_nodeA==p_nodeB)
        return false;
    Node *pTemp;
    if (getBrotherState(p_nodeA)==LeftChild) {
        if (getBrotherState(p_nodeB)==LeftChild) {
            pTemp = p_nodeA->p_parent->p_left;
            p_nodeA->p_parent->p_left = p_nodeB->p_parent->p_left;
            p_nodeB->p_parent->p_left = pTemp;
        }
        else {
            pTemp = p_nodeA->p_parent->p_left;
            p_nodeA->p_parent->p_left = p_nodeB->p_parent->p_right;
            p_nodeB->p_parent->p_right = pTemp;
        }
    }
    else {
        if (getBrotherState(p_nodeB)==LeftChild) {
            pTemp = p_nodeA->p_parent->p_right;
            p_nodeA->p_parent->p_right = p_nodeB->p_parent->p_left;
            p_nodeB->p_parent->p_left = pTemp;
        }
        else {
            pTemp = p_nodeA->p_parent->p_right;
            p_nodeA->p_parent->p_right = p_nodeB->p_parent->p_right;
            p_nodeB->p_parent->p_right = pTemp;

        }
    }
    pTemp = p_nodeA->p_parent;
    p_nodeA->p_parent = p_nodeB->p_parent;
    p_nodeB->p_parent = pTemp;
    return true;

}

bool BinaryTree::addNode(Node * p_parent, Node * p_child, Brother brotherState){
    if(p_parent==nullptr||p_child==nullptr)
        return false;
    if (brotherState == LeftChild) {
        if (p_parent->p_left != nullptr) {
            return false;
        }
        p_parent->p_left = p_child;
    }
    else if (brotherState == RightChild) {
        if (p_parent->p_right != nullptr) {
            return false;
        }
        p_parent->p_right = p_child;
    }
    else {
        return false;
    }
    p_child->p_parent = p_parent;
    return true;
}

bool BinaryTree::isAncestor(Node * p_nodeChild, Node * p_nodeAncestor){
    while (p_nodeChild != p_root) {
        if (p_nodeChild == p_nodeAncestor) {
            return true;
        }else {
            p_nodeChild = p_nodeChild->p_parent;
        }
    }
    return false;
}

void BinaryTree::deleteNode(Node *p_node){
    if (p_node->p_left!=nullptr) {
        deleteNode(p_node->p_left);
    }
    if (p_node->p_right != nullptr) {
        deleteNode(p_node->p_right);
    }
    delete p_node;
}

BinaryTree::Brother BinaryTree::getBrotherState(Node *p_node){
    if (p_node->p_parent->p_left == p_node) {
        return LeftChild;
    }
    else {
        return RightChild;
    }
}

//哈夫曼树成员函数实现
HuffmanTree::HuffmanTree(){tree = new BinaryTree(0,0);}

HuffmanTree::~HuffmanTree(){
    os.close();
    is.close();
}

bool HuffmanTree::ReadFile(const std::string& filename){
    is.close();
    is.clear();
    is.open(filename, std::ios_base::in);
    if (!is.is_open()) {return false;}
    return true;
}

//获取节点的哈夫曼编码
std::string HuffmanTree::getHuffmanCode(Node *p_n) const{
    std::string huffmanCode = "";
    std::stack<unsigned char> code;

    //逆向后推，当为左孩子的时候则置0，当为右孩子的时候则置1。
    while (p_n != tree->getRoot()) {
        if (tree->getBrotherState(p_n) == tree->LeftChild)
            code.push('0');
        else
            code.push('1');
        p_n = p_n->p_parent;
    }

    while (!code.empty()) {
        huffmanCode += code.top();
        code.pop();
    }
    return huffmanCode;
}

//找到所在块中最大节点编号的节点
Node * HuffmanTree::findLarge(Node *p_node) const{
    std::stack<Node *> stack;
    Node *p = tree->getRoot();//从根节点开始
    Node *large = p;
    while (p || !stack.empty()) {
        if (p != nullptr) {
            stack.push(p);
            if (p->weight == p_node->weight) {
                //如果large不在同权重下，则置large为p
                if (large->weight != p->weight)  large = p;
                    //同权重下的large比p大，也就是说p在large上方，则置large为p
                else if(large->num > p->num)  large = p;
            }
            p = p->p_left;
        }
        else {
            p = stack.top();
            stack.pop();
            p = p->p_right;
        }
    }
    //large不可能是根节点，当large为根节点时返回原节点
    if (large == tree->getRoot()) {
        return p_node;
    }
    return large;
}

//从当前节点往上依次权重值加一，但是加一前先判断是否符合兄弟属性
void HuffmanTree::weightAdd(Node * p_node){
    while (p_node != nullptr) {
        Node* large = findLarge(p_node);
        if (large != p_node && !tree->isAncestor(p_node, large)) {
            tree->swap(large, p_node);
            int temp;
            temp = large->num;
            large->num = p_node->num;
            p_node->num = temp;

            Leaf* l;
            for (auto iterator = leaves.begin(); iterator != leaves.end(); iterator++) {
                l = leaves.at(iterator->first);
                l->codeword = getHuffmanCode(l->p);
                leaves[iterator->first] = l;
            }
        }
        p_node->weight++;
        p_node = p_node->p_parent;
    }
}

vector<string> getEachString(const string& s){
    vector<string> res;
    const char * chs = s.c_str();
    int length;
    int start = 0;
    while(start < strlen(chs) && start < s.length()) {
        length = ((unsigned int)chs[start] > 0x80) ? 3 : 1;
        res.push_back(s.substr(start, length));
        start += length;
    }
    return res;
}

//动态构建霍夫曼树
bool HuffmanTree::buildTree(){
    if (!is.is_open()) {return false;}
    //读取字符，设置nyt节点为根节点
    string cbuffer;
    bool exist;
    string();
    vector<string> stringRes;
    Node *nyt = tree->getRoot();
    getline(is,cbuffer);
    while (is){
        stringRes = getEachString(cbuffer);
        for (const string& stringEach : stringRes){
            exist = false;
            auto it = leaves.find(stringEach);

            if (it != leaves.end()){exist = true;}
            if (exist) {
                Node *existNode = leaves.at(stringEach)->p;
                weightAdd(existNode);
            }else {
                //当字符不存在树中时，则新建子树，并替代原nyt节点
                Node *c = new Node(nullptr, nullptr, nyt);
                c->num = sum++;
                c->weight = 1;

                Node *NYT = new Node(nullptr, nullptr, nyt);
                NYT->num = sum++;
                NYT->weight = 0;

                tree->addNode(nyt, NYT, BinaryTree::LeftChild);
                tree->addNode(nyt, c, BinaryTree::RightChild);
                nyt->weight = 1;

                //将新的字符放进leaves中
                Leaf *newLeaf = new Leaf();
                newLeaf->key = stringEach;
                newLeaf->p = nyt->p_right;
                newLeaf->codeword = getHuffmanCode(nyt->p_right);
                leaves[stringEach] = newLeaf;

                //依次增加权重
                Node *root = nyt->p_parent;
                weightAdd(root);

                //设置新的nyt节点为原nyt节点的左孩子
                nyt = nyt->p_left;
            }
        }
        getline(is,cbuffer);
    }
    removeNYT(nyt);
    setLevelAndN();
    return false;
}

//给所有叶子节点设置level与n
void HuffmanTree::setLevelAndN(){
    Leaf* l;
    string  str ;
    int n = 0,drop;
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        str = l->codeword;
        l->level = int(l->codeword.length());
        drop = l->level;
        for (char i : str) {
            if (i == '1')
                n += int(pow(2, drop - 1));
            drop--;
        }
        l->n = n;
        n = 0;
    }
}

//完成树的构建，删除nyt节点并将nyt的兄弟叶子节点上移
void HuffmanTree::removeNYT(Node* nyt) {
    //如果只有一个编码元素或者没有，那删不删无所谓
    if (leaves.size()>1){
        Node* brotherNode;
        Node* pp_node;//父节点的父节点
        pp_node = nyt->p_parent->p_parent;
        brotherNode = nyt->p_parent->p_right;
        pp_node->p_left = brotherNode;
        Leaf* l;
        for (auto & leave : leaves) {
            l = leaves.at(leave.first);
            if (l->p == brotherNode){
                l->codeword = l->codeword.substr(0,l->codeword.length()-1);
                l->p = brotherNode;
                l->p->num = l->p->num - 1;
            }
        }
    }
}

bool HuffmanTree::writeEncodeResultAsBinaryStream(const string& filepath,const string& filename){
//    os.close();
//    os.clear();
    os.open(filepath +"\\"+ filename, std::ios_base::out);
    if (!os.is_open()) {
        ofstream { filepath +"\\"+ filename };
        os.open(filepath + "\\"+filename, std::ios_base::out);
    }
    if (!os.is_open()) {
        return false;
    }

    int count = 0;
    char c = char(0);
    for (unsigned char ch : encodeResult){
        c <<= 1;
        if (ch == '1')
            c |= 1;
        else
            c |= 0;
        ++count;
        if (count == 8)
        {
            os<<c;
            c = char(0);
            count = 0;
        }
    }
    if (count != 0){//用0补位
        c <<= (8 - count);
        os<<c;
    }
    os.close();
//    os.clear();
    return  true;
}

//根据编码表对文件内容进行编码
bool HuffmanTree::encode(const std::string& filepath,const std::string& filename){
    int i = (INVALID_FILE_ATTRIBUTES != GetFileAttributesA(filepath.c_str()) && 0 != (GetFileAttributesA(filepath.c_str()) & FILE_ATTRIBUTE_DIRECTORY));
    if (i == 0){
        bool flag = CreateDirectoryA(filepath.c_str(),nullptr);
        // flag 为 true 说明创建成功
        if (!flag)return false;
    }
    //确认文件存在
    if (!is.is_open()) {return false;}

    //读取字符，设置nyt节点为根节点
    string cbuffer;
    vector<string> stringRes;
    getline(is,cbuffer);
    while (is){
        stringRes = getEachString(cbuffer);
        for(const string & stringEach : stringRes){
            encodeResult.append(leaves[stringEach]->codeword);
        }
        getline(is,cbuffer);
    }
//    os.close();
//    os.clear();
    os.open("C:\\codefile\\encodeResult.txt", std::ios_base::out);
    os<<encodeResult;
    os.close();
    cout<<"over";
    return writeEncodeResultAsBinaryStream(filepath,filename);
}

bool HuffmanTree::decodeWithMap() {
    getCodewordMap();
    char cbuffer;
    string codeword;
    while (!is.eof()) { //末尾以255表示输入的结束
        cbuffer = char(is.get());
        if (cbuffer != -1) {
//            for (int pos = 7; pos >= 0; --pos){
//                if (cbuffer & (1 << pos)) {//1
//                    codeword.append("1");
//                    cout<<"1";
//                }else{   //0
//                    codeword.append("0");
//                    cout<<"0";
//                }
//                if (codewordMap.find(codeword) != codewordMap.end()){
//                    decodeResult += codewordMap[codeword];
//                    codeword = "";
//                }
//            }
            if (cbuffer == '1'){
                codeword.append("1");
            } else{
                codeword.append("0");
            }
            if (codewordMap.find(codeword) != codewordMap.end()){
                decodeResult += codewordMap[codeword];
                codeword = "";
            }
        }
    }
//    os.close();
//    os.clear();
    os.open("C:\\codefile\\textfile.txt", std::ios_base::out);
    if (!os.is_open()) {
        ofstream { "C:\\codefile\\textfile.txt" };
        os.open("C:\\codefile\\textfile.txt", std::ios_base::out);
    }
    if (!os.is_open()) {
        return false;
    }
    os<<decodeResult;
    os.close();
    os.clear();
    return true;
}

void HuffmanTree::getCodewordMap() {
    Leaf* l;
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        codewordMap[l->codeword] = l->key;
    }
}

void HuffmanTree::printMap(){
    Leaf* l;
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        cout<<l->key<<endl;
        cout<<"codeword:"<<l->codeword<<endl;
        cout<<"level:"<<l->level<<endl;
        cout<<"n:"<<l->n<<endl;
    }

}

int HuffmanTree::getLocate(int level, int n) {
    return static_cast<int>(pow(2,level)) + n - 1;
}

bool HuffmanTree::writeTree(const std::string& filepath) {
//    os.close();
//    os.clear();
    os.open(filepath, std::ios_base::out);
    if (!os.is_open()) {
        ofstream { filepath  };
        os.open(filepath , std::ios_base::out);
    }
    if (!os.is_open()) {
        return false;
    }

    Leaf* l;
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        os<<l->key<<"<b>"<<l->codeword<<"<b>"<<l->level<<"<b>"<<l->n<<"<b>"<<l->p->num<<"<b>"<<l->p->weight<<endl;
    }
    os.close();
    return true;
}

std::vector<string> split(const string& str,const string& delim) { //将分割后的子字符串存储在vector中
    vector<string> res;
    if (str.empty()) return res;

    string strs = str + delim; //*****扩展字符串以方便检索最后一个分隔出的字符串
    size_t pos;
    size_t size = strs.size();

    for (int i = 0; i < size; ++i) {
        pos = strs.find(delim, i); //pos为分隔符第一次出现的位置，从i到pos之前的字符串是分隔出来的字符串
        if (pos < size) { //如果查找到，如果没有查找到分隔符，pos为string::npos
            string s = strs.substr(i, pos - i);//*****从i开始长度为pos-i的子字符串
            res.push_back(s);//两个连续空格之间切割出的字符串为空字符串，这里没有判断s是否为空，所以最后的结果中有空字符的输出，
            i = int(pos + delim.size() - 1);
        }

    }
    return res;
}

void sumWeight(Leaf* leaf){
    Node* p_parent;
    Node* node = leaf->p;
    while (node->p_parent != nullptr){
        p_parent = node->p_parent;
        p_parent->weight += leaf->p->weight;
        node = p_parent;
    }
}

bool HuffmanTree::readTree(const std::string &filename) {
    bool read = ReadFile(filename);
    if (!read) {
        return false;
    }

    auto *newTree = new BinaryTree(0, 0);
    Node *root = newTree->getRoot();
    Node *nodeNow;
    Leaf* leaf;
    string line;
    vector<string> info;
    int i;
    Node *parentNode;
    int locate;//用于唯一确定节点位置
    int level, n;//临时变量
    bool isLeftChild,exist = false;
//    l->key<<":"<<l->codeword<<":"<<l->level<<":"<<l->n<<":"<<l->p->num<<":"<<l->p->weight
//         0            1                  2          3               4                5
    while (getline(is, line)) {
        info = split(line, ":");
        if (info.size() != 6) return false;
        nodeNow = new Node(nullptr, nullptr, nullptr);//从叶子节点开始
        nodeNow->weight = stoi(info[5]);
        nodeNow->num = 0;
        leaf = new Leaf();
        leaf->key = info[0][0];
        leaf->codeword = info[1];
        leaf->level = stoi(info[2]);
        leaf->n = stoi(info[3]);
        leaf->p = nodeNow;

        level = leaf->level;
        n = leaf->n;
        locate = getLocate(level, n);
        allRebuildLeafNodes[locate] = leaf;
        for (i = 1; i < info[1].length(); ++i) {
            level--;
            isLeftChild = n % 2 == 0;
            n = n / 2;
            locate = getLocate(level,n);
            if (allRebuildNewNodes.find(locate) == allRebuildNewNodes.end()) {//不存在就创建
                exist = false;
                parentNode = new Node(nullptr, nullptr, nullptr);
                parentNode->num = 0;
                parentNode->weight = 0;
                allRebuildNewNodes[locate] = parentNode;
            } else {//存在
                exist = true;
                parentNode = allRebuildNewNodes[locate];
            }
            if (isLeftChild && parentNode->p_left == nullptr) {//偶数，说明是父节点的左子树
                newTree->addNode(parentNode, nodeNow, BinaryTree::LeftChild);
            } else if (!isLeftChild && parentNode->p_right == nullptr){//奇数，右子树
                newTree->addNode(parentNode, nodeNow, BinaryTree::RightChild);
            }
            if (exist)break;//出现一个存在的节点就直接跳出循环
            nodeNow = parentNode;//上移，准备下一次处理
        }
        if (!exist){
            isLeftChild = n % 2 == 0;
            // 根节点单独处理
            if (isLeftChild && root->p_left == nullptr) {//偶数，说明是父节点的左子树
                newTree->addNode(root, nodeNow, BinaryTree::LeftChild);
            } else if (!isLeftChild && root->p_right == nullptr){//奇数，右子树
                newTree->addNode(root, nodeNow, BinaryTree::RightChild);
            }
        }
    }
    for (auto & leave : allRebuildLeafNodes) {
        leaf = allRebuildLeafNodes.at(leave.first);
        sumWeight(leaf);
    }
    tree = newTree;
    return true;
}