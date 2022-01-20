#pragma once
#include <fstream>
#include <map>
#include <unordered_map>

using std::ifstream;
using std::ofstream;
using std::cout;
using std::cin;
using std::endl;

struct Node {
    int weight;
    int num;//节点标号
    Node* p_left;
    Node* p_right;
    Node* p_parent;
    Node(Node* p_left, Node* p_right, Node* p_parent) : p_left(p_left), p_right(p_right), p_parent(p_parent) {};
};


class BinaryTree{
public:

    enum Brother{LeftChild, RightChild};
    BinaryTree(int num = 0,int weight = 0);
    ~BinaryTree();
    bool swap(Node* p_nodeA, Node* p_nodeB);
    static bool addNode(Node* p_parent, Node* p_child, Brother brotherState);
//    Node* findNode(Node *p);
    void deleteNode(Node *p_node);
    Node* getRoot() {return p_root;}
//    bool setNodeNum(Node* p_node,int num);
    Brother getBrotherState(Node *p_node);
    bool isAncestor(Node* p_nodeChild, Node* p_nodeAncestor);
private:
    Node *p_root;

};




class HuffmanTree
{
public:

    HuffmanTree();
    ~HuffmanTree();
    bool ReadFile(char * filename);

    bool encode(char * out_filename);
private:
    void weightAdd(Node* p_node);

    static int sum;
    BinaryTree tree;

    struct Leaf{
        char key;
        int level;
        int n;
        std::string codeword;
        Node* p;
    };

    //存储已存在字符的哈夫曼编码的结构
//    struct charMap{
//        char key;
//        std::string value;
//        Node* p;
//    };
    std::string getHuffmanCode(Node *p);
    Node * findLarge(Node *);

    //一个存储哪些字符已经存在于树中的缓冲
//    std::vector<charMap> buffers;
    ifstream is;
    ofstream os;

    std::unordered_map<char,Leaf*> leaves;//所有现存的叶子
};