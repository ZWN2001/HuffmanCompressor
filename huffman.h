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
    void deleteNode(Node *p_node);
    Node* getRoot() {return p_root;}
    static Brother getBrotherState(Node *p_node);
    bool isAncestor(Node* p_nodeChild, Node* p_nodeAncestor);
private:
    Node *p_root;
};

class HuffmanTree
{
public:

    HuffmanTree();
    ~HuffmanTree();
    bool ReadFile(const std::string& str);

    bool encode(const std::string& str);
    bool buildTree();
    void setLevelAndN();
    void printMap();
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

    std::string getHuffmanCode(Node *p);
    Node * findLarge(Node *);

    ifstream is;
    ofstream os;

    std::unordered_map<char,Leaf*> leaves;//所有现存的叶子
};