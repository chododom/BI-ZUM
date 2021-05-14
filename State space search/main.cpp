#include <iostream>
#include <stdlib.h>
#include <vector>
#include <climits>
#include <queue>
#include <stack>
#include <cmath>
#include <thread>
#include <chrono>
#include <cstring>
#include <sstream>

#define RED "\033[1;31m"
#define YELLOW "\033[1;33m"
#define BLUE "\033[1;34m"
#define GREEN "\033[1;32m"
#define MAGENTA "\033[1;35m"
#define BLACK "\033[1;33m"
#define CYAN "\033[1;36m"
#define INVERSE "\033[7m"
#define DEFAULT "\033[0m"

using namespace std;
using namespace std::chrono;
using namespace std::this_thread;

void ClearScreen() {
    cout << "\033[2J\033[1;1H";// string(150, '\n');
}

enum State {
    UNDEFINED, START, END, WALL, FRESH, OPEN, CLOSED
};

class Position {
public:
    unsigned int x;
    unsigned int y;

    Position() : x(UINT_MAX), y(UINT_MAX) {}

    Position(unsigned int x_pos, unsigned int y_pos) : x(x_pos), y(y_pos) {}

    friend bool operator==(const Position &first, const Position &second) {
        return first.x == second.x && first.y == second.y;
    }

    friend bool operator!=(const Position &first, const Position &second) {
        return first.x != second.x || first.y != second.y;
    }
};

class Node {
public:
    Position position;
    State state;
    char s;
    Node *prevNode;
    double distanceFromStart = 0;
    double distanceToEnd = 0;
    double nextNodeDistance = 1;

    Node() : position(), state(UNDEFINED), prevNode(nullptr) {}

    Node(unsigned int x, unsigned int y, State st) : position(x, y), state(st), prevNode(nullptr) {}

    void getDistanceToEnd(Position end);
};

void Node::getDistanceToEnd(Position end) {
    distanceToEnd = sqrt((end.x - position.x) * (end.x - position.x) + (end.y - position.y) * (end.y - position.y));
}

class Map {
public:
    Position start;
    Position end;

    vector<vector<Node *>> graph;

    Map() : start(UINT_MAX, UINT_MAX), end(UINT_MAX, UINT_MAX) {}

    bool includedInPath(Position p, vector<Position> path);

    void print(bool withPath, vector<Position> path = vector<Position>());

    vector<Node *> getNeighbours(Node *current);

    void BFS(bool delay);

    void DFS(bool delay);

    void RandomSearch(bool delay);

    void Dijkstra(bool delay);

    void GreedySearch(bool delay);

    void AStar(bool delay);

    void setDistancesToINF();

    void CalculateDistances();

    void drawPath(bool delay);

};

void Map::drawPath(bool delay) {
    vector<Position> path;
    Node *tmp = graph[end.x][end.y];
    path.emplace_back(Position(tmp->position.x, tmp->position.y));

    while (tmp->position != start) {
        tmp = tmp->prevNode;
        path.emplace_back(Position(tmp->position.x, tmp->position.y));
    }
    /* for(auto &i : path) {
         cout << "[" << i.x << "][" << i.y << "]" << ", ";
     }*/

    vector<Position> tracking;
    for (unsigned long i = path.size() - 1; i != 0; --i) {
        tracking.emplace_back(path[i]);

        if(delay) {
            ClearScreen();
            print(true, tracking);
            sleep_for(nanoseconds(50000000));
        }
    }
    ClearScreen();
    print(true, tracking);
    cout << path.size() - 1 << endl;
}

void Map::CalculateDistances() {
    for (auto &m : graph) {
        for (auto &n : m) {
            n->getDistanceToEnd(end);
        }
    }
}

void Map::setDistancesToINF() {
    for (auto &row : graph) {
        for (const auto &node : row) {
            node->distanceFromStart = INT_MAX;
        }
    }
}

void Map::AStar(bool delay) {
    if (start == end) drawPath(delay);
    Node *end = nullptr;

    CalculateDistances();

    auto cmp = [](const Node *first, const Node *second) {
        return first->distanceFromStart + first->distanceToEnd > second->distanceFromStart + second->distanceToEnd;
    };
    priority_queue<Node *, vector<Node *>, decltype(cmp)> pQ(cmp);

    setDistancesToINF();
    Node *first = graph[start.x][start.y];
    first->distanceFromStart = 0;
    pQ.push(first);

    while (!pQ.empty()) {
        Node *current = pQ.top();
        pQ.pop();

        /*
         * we can end the algorithm after END has been poped from queue, because at that point, it had the shortest distance in the priority queue, so it won't change

        if(current->state == END) {
            drawPath(delay);
            return;
        }

        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == FRESH || neighbour->state == OPEN || neighbour->state == END) {
                if (neighbour->distanceFromStart > current->distanceFromStart + current->nextNodeDistance) {
                    neighbour->distanceFromStart = current->distanceFromStart + current->nextNodeDistance;
                    if(neighbour->state != END) neighbour->state = OPEN;
                    neighbour->prevNode = current;
                    pQ.push(neighbour);
                }

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }
            }
        }

        current->state = CLOSED;
    }
}

void Map::GreedySearch(bool delay) {
    if (start == end) drawPath(delay);

    CalculateDistances();

    auto cmp = [](const Node *first, const Node *second) {
        return first->distanceToEnd > second->distanceToEnd;
    };
    priority_queue<Node *, vector<Node *>, decltype(cmp)> pQ(cmp);

    Node *first = graph[start.x][start.y];
    first->distanceToEnd = 0;
    pQ.push(first);

    while (!pQ.empty()) {
        Node *current = pQ.top();
        pQ.pop();
        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == END) {
                neighbour->prevNode = current;
                drawPath(delay);
                return;
            }
            if (neighbour->state == FRESH) {
                neighbour->state = OPEN;
                neighbour->prevNode = current;
                pQ.push(neighbour);

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }
            }
        }
        current->state = CLOSED;
    }
}

void Map::Dijkstra(bool delay) {
    if (start == end) drawPath(delay);
    Node *end = nullptr;


    auto cmp = [](const Node *first, const Node *second) {
        return first->distanceFromStart > second->distanceFromStart;
    };
    priority_queue<Node *, vector<Node *>, decltype(cmp)> pQ(cmp);

    setDistancesToINF();
    Node *first = graph[start.x][start.y];
    first->distanceFromStart = 0;
    pQ.push(first);

    while (!pQ.empty()) {
        Node *current = pQ.top();
        pQ.pop();

        /*
         * we can end the algorithm after END has been poped from queue, because at that point, it had the shortest distance in the priority queue, so it won't change
         */
        if(current->state == END) {
            drawPath(delay);
            return;
        }

        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == FRESH || neighbour->state == OPEN || neighbour->state == END) {
                if (neighbour->distanceFromStart > current->distanceFromStart + current->nextNodeDistance) {
                    neighbour->distanceFromStart = current->distanceFromStart + current->nextNodeDistance;
                    if(neighbour->state != END) neighbour->state = OPEN;
                    neighbour->prevNode = current;
                    pQ.push(neighbour);
                }

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }
            }
        }

        current->state = CLOSED;
    }
}

void Map::RandomSearch(bool delay) {
    if (start == end) drawPath(delay);

    vector<Node *> nodes;
    nodes.emplace_back(graph[start.x][start.y]);

    while (!nodes.empty()) {
        unsigned long int index = rand() % nodes.size();
        Node *current = nodes[index];
        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == END) {
                neighbour->prevNode = current;
                drawPath(delay);
                return;
            } else if (neighbour->state == FRESH) {
                neighbour->prevNode = current;
                neighbour->state = OPEN;
                nodes.emplace_back(neighbour);

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }
            }
        }
        current->state = CLOSED;
    }
}

void Map::DFS(bool delay) {
    if (start == end) drawPath(delay);

    stack<Node *> s;
    s.push(graph[start.x][start.y]);

    while (!s.empty()) {
        Node *current = s.top();
        s.pop();

        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == END) {
                neighbour->prevNode = current;
                drawPath(delay);
                return;
            } else if (neighbour->state == FRESH) {
                neighbour->prevNode = current;
                neighbour->state = OPEN;
                s.push(neighbour);

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }

            }
        }
        current->state = CLOSED;
    }
}

void Map::BFS(bool delay) {
    if (start == end) drawPath(delay);

    queue<Node *> q;
    q.push(graph[start.x][start.y]);

    while (!q.empty()) {
        Node *current = q.front();
        q.pop();
        for (Node *neighbour : getNeighbours(current)) {
            if (neighbour->state == END) {
                neighbour->prevNode = current;
                drawPath(delay);
                return;
            } else if (neighbour->state == FRESH) {
                neighbour->prevNode = current;
                neighbour->state = OPEN;
                q.push(neighbour);

                if(delay) {
                    ClearScreen();
                    print(false);
                    sleep_for(nanoseconds(50000000));
                }
            }
        }
        current->state = CLOSED;
    }
}

vector<Node *> Map::getNeighbours(Node *current) {
    vector<Node *> v;
    unsigned int x = current->position.x;
    unsigned int y = current->position.y;
    v.emplace_back(graph[x][y - 1]);
    v.emplace_back(graph[x + 1][y]);
    v.emplace_back(graph[x][y + 1]);
    v.emplace_back(graph[x - 1][y]);
    return v;
}

bool Map::includedInPath(Position p, vector<Position> path) {
    for (auto &n : path) {
        if (p == n) return true;
    }
    return false;
}

void Map::print(bool withPath, vector<Position> path) {
    int expanded = 0;
    for (unsigned int x = 0; x < graph.size(); ++x) {
        for (unsigned int y = 0; y < graph[0].size(); ++y) {
            if (x == start.x && y == start.y) {
                cout << RED << "S" << DEFAULT;
                ++expanded;
            } else if (x == end.x && y == end.y) {
                cout << RED << "E" << DEFAULT;
                ++expanded;
            } else if (graph[x][y]->state == OPEN) {
                if (withPath && includedInPath(Position(x, y), path)) cout << RED << "O" << DEFAULT;
                else cout << CYAN << "#" << DEFAULT;
                ++expanded;
            } else if (graph[x][y]->state == CLOSED) {
                if (withPath && includedInPath(Position(x, y), path)) cout << RED << "O" << DEFAULT;
                else cout << BLUE << "#" << DEFAULT;
                ++expanded;
            } else cout << graph[x][y]->s;
        }
        cout << endl;
    }

    if (!withPath) {
        cout << "start[" << start.x << "][" << start.y << "]" << endl;
        cout << "end[" << end.x << "][" << end.y << "]" << endl;
    } else {
        cout << endl << endl << "Nodes expanded: " << expanded << endl << "Path lenght: ";
    }
}

State getState(char c) {
    switch (c) {
        case 'X':
            return WALL;
        case ' ':
            return FRESH;
        default:
            return UNDEFINED;
    }
}

void readInput(Map *map) {
    unsigned int x = 0, y = 0;
    string line;
    bool next = false;

    //read whole map
    while (cin.peek() != 's' && getline(cin, line)) {
        vector<Node *> row;

        //read next row
        for (char &c : line) {
            if (c == '\n') break;
            Node *newNode = new Node(y, x, getState(c));
            newNode->s = c;
            row.emplace_back(newNode);
            ++x;
        }
        map->graph.emplace_back(row);
        ++y;
        x = 0;
    }

    //read start
    string word, comma;
    unsigned int a = UINT_MAX, b = UINT_MAX;
    cin >> word >> b >> comma >> a;
    map->start = Position(a, b);
    map->graph[a][b]->state = START;

    //read end
    cin >> word >> b >> comma >> a;
    map->end = Position(a, b);
    map->graph[a][b]->state = END;
}

int main(int argc, char **argv) {
    Map *map = new Map();
    readInput(map);
    //map->print(false);

    stringstream ss(argv[1]);
    stringstream ss2(argv[2]);

    bool delay;
    if (ss2.str() == "delay") {
        delay = true;
    }
    else if (ss2.str() == "nodelay") delay = false;

    if (ss.str() == "BFS") {
        map->BFS(delay);
        cout << RED << " -> Breadth First Search" << DEFAULT << endl;
    } else if (ss.str() == "DFS") {
        map->DFS(delay);
        cout << RED << " -> Depth First Search" << DEFAULT << endl;
    } else if (ss.str() == "Random") {
        map->RandomSearch(delay);
        cout << RED << " -> Random Search" << DEFAULT << endl;
    } else if (ss.str() == "Dijkstra") {
        map->Dijkstra(delay);
        cout << RED << " -> Dijkstra" << DEFAULT << endl;
    } else if (ss.str() == "Greedy") {
        map->GreedySearch(delay);
        cout << RED << " -> Greedy Search" << DEFAULT << endl;
    } else if (ss.str() == "A*") {
        map->AStar(delay);
        cout << RED << " -> A*" << DEFAULT << endl;
    } else cout << RED << "invalid argument" << DEFAULT << endl;

    return 0;
}
