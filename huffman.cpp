//#include "stdafx.h"
#include <iostream>
#include <stack>
#include <queue>
#include <cmath>
#include "huffman.h"


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
//            std::cout << "error:left child exist!" << std::endl;
            return false;
        }
        p_parent->p_left = p_child;
    }
    else if (brotherState == RightChild) {
        if (p_parent->p_right != nullptr) {
//            std::cout << "error:right child exist!" << std::endl;
            return false;
        }
        p_parent->p_right = p_child;
    }
    else {
//        std::cout << "error:brotherState is wrong!" << std::endl;
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
    if (!is.is_open()) {
        cout << "error: " << filename << " is not exist!" << endl;
        return false;
    }
    return true;
}

//获取节点的哈夫曼编码
std::string HuffmanTree::getHuffmanCode(Node *p_n){
    std::string huffmanCode = "";
    std::stack<Node *> stack;
    std::stack<char> code;

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
Node * HuffmanTree::findLarge(Node *p_node){
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
//            cout << "即将为节点" << p_node->num << "加一,但是同块最大节点为：" << large->num << ",权重值为：" << p_node->weight << endl;
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
//        cout << "节点" << p_node->num << "权重值加1" << "为：" << p_node->weight << endl;
        p_node = p_node->p_parent;
    }
}

//动态构建霍夫曼树
bool HuffmanTree::buildTree(){
    if (!is.is_open()) {
        cout << "error: no file read!" << endl;
        return false;
    }
    //读取字符，设置nyt节点为根节点
    char cbuffer;
    bool exist;
    std::string code;
    Node *nyt = tree->getRoot();
    while (!is.eof()) { //末尾以-1表示输入的结束
        cbuffer = is.get();
        if (cbuffer != -1) {
            exist = false;
            auto it = leaves.find(cbuffer);
            if (it != leaves.end()) exist = true;

            if (exist) {
                cout << cbuffer << " 在树中存在，编码为： " << leaves.at(cbuffer)->codeword << endl;
                Node *existNode = leaves.at(cbuffer)->p;
                weightAdd(existNode);
            }
            else {
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
                newLeaf->key = cbuffer;
                newLeaf->p = nyt->p_right;
                newLeaf->codeword = getHuffmanCode(nyt->p_right);
                leaves.insert(pair<char, Leaf *>(cbuffer, newLeaf));
                cout << cbuffer << "首次出现，设定编码为：" << newLeaf->codeword << endl;
                //依次增加权重
                Node *root = nyt->p_parent;
                weightAdd(root);

                //设置新的nyt节点为原nyt节点的左孩子
                nyt = nyt->p_left;
            }

        }
    }
    setLevelAndN();
    printMap();
    return false;
}

void HuffmanTree::setLevelAndN(){
    Leaf* l;
    string  str ;
    int n = 0,drop = 1;//认为初始落差是1，初始n为-1可以避免最后再减一
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        str = l->codeword;
        l->level = std::ceil(l->p->num*0.5);
        for (char i : str) {
            if (i == '1')
                n += pow(2,drop-1);
            drop++;
        }
        l->n = n;

        n = 0;
        drop = 1;
    }
}

//根据编码表对文件内容进行编码
bool HuffmanTree::encode(const std::string& osstr){
    //确认文件存在
    if (!is.is_open()) {
        cout << "error: no file read!" << endl;
        return false;
    }
    os.close();
    os.clear();
    os.open(osstr, std::ios_base::out);
    if (!os.is_open()) {
        cout << "error: can not open file to write!" << endl;
    }

    //读取字符，设置nyt节点为根节点
    char cbuffer;
    while (!is.eof()) { //末尾以-1表示输入的结束
        cbuffer = is.get();
        if (cbuffer != -1) {
            os<<leaves[cbuffer]->codeword;
            encodeResult.append(leaves[cbuffer]->codeword);
        }
    }
    return false;
}

bool HuffmanTree::decodeWithMap() {
    getCodewordMap();
    char cbuffer,addChar;
    string codeword;
    while (!is.eof()) { //末尾以-1表示输入的结束
        cbuffer = is.get();
        if (cbuffer != -1) {
            codeword = "";
            codeword += cbuffer;
            while (codewordMap.find(codeword) == codewordMap.end()){
                addChar = is.get();
                if (is.eof()&&addChar == -1){
                    return false;
                }
                codeword += addChar;
            }
            decodeResult += codewordMap[codeword];
        }
    }
    cout<<"decodeResult"<<decodeResult;
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
        cout<<"codeword:"<<l->codeword<<endl;
        cout<<"level:"<<l->level<<endl;
        cout<<"n:"<<l->n<<endl;
    }
}

void HuffmanTree::writeTree(const std::string& filename) {
    os.close();
    os.clear();
    os.open(filename, std::ios_base::out);
    if (!os.is_open()) {
        cout << "error: can not open file to write!" << endl;
    }
    Leaf* l;
    for (auto & leave : leaves) {
        l = leaves.at(leave.first);
        os<<l->key<<":"<<l->codeword<<":"<<l->level<<":"<<l->n<<endl;
    }
}
