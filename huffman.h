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
    int num;//节点标号,在构建完树之后不要轻易使用这个变量做任何逻辑运算
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
    static bool swap(Node* p_nodeA, Node* p_nodeB);
    static bool addNode(Node* p_parent, Node* p_child, Brother brotherState);
    void deleteNode(Node *p_node);
    Node* getRoot() {return p_root;}
    static Brother getBrotherState(Node *p_node);
    bool isAncestor(Node* p_nodeChild, Node* p_nodeAncestor);
private:
    Node *p_root;
};

struct Leaf{
    unsigned char key;
    int level;
    int n;
    std::string codeword;
    Node* p;
};

class HuffmanTree{
public:
    HuffmanTree();
    ~HuffmanTree();
    bool ReadFile(const std::string& str);
    bool encode(const std::string& str1,const std::string& str2);
    bool decodeWithMap();
    bool buildTree();
    void removeNYT(Node* nyt);
    void printMap();
    bool writeTree(const std::string& filename);
    bool readTree(const std::string& filename);

    std::unordered_map<unsigned char,Leaf*> leaves;//所有现存的叶子
    std::unordered_map<std::string,unsigned char> codewordMap;
    std::string encodeResult;
    std::string decodeResult;
    BinaryTree* tree;
private:
    void weightAdd(Node* p_node);
    std::string getHuffmanCode(Node *p) const;
    Node * findLarge(Node *) const;
    void getCodewordMap();
    void setLevelAndN();
    bool writeEncodeResultAsBinaryStream(const std::string& filepath, const std::string& filename);
    static int getLocate(int level, int n);
    static int sum;
    std::unordered_map<int,Node*> allRebuildNewNodes;
    std::unordered_map<int,Leaf*> allRebuildLeafNodes;

    ifstream is;
    ofstream os;
};

//class Controller{
//public:
//    Controller();
//    HuffmanTree huff;
//
//};