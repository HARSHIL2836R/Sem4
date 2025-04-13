#include <iostream>
#include <vector>
#include <fstream>

using namespace std;

struct Edge {
    int from, to;
    int lower, upper;
};

int main() {
    int m, n;
    cin >> m >> n;

    vector<vector<int>> L(m, vector<int>(n)); // Lower bounds
    vector<vector<int>> U(m, vector<int>(n)); // Upper bounds

    for (int i = 0; i < m; ++i)
        for (int j = 0; j < n; ++j)
            cin >> L[i][j];

    for (int i = 0; i < m; ++i)
        for (int j = 0; j < n; ++j)
            cin >> U[i][j];

    vector<int> row_l(m), row_u(m);
    for (int i = 0; i < m; ++i)
        cin >> row_l[i] >> row_u[i];

    vector<int> col_l(n), col_u(n);
    for (int j = 0; j < n; ++j)
        cin >> col_l[j] >> col_u[j];

    // Create output file for Graphviz
    ofstream dotFile("graph.dot");
    dotFile << "digraph BudgetGraph {\n";
    dotFile << "    rankdir=LR;\n";
    dotFile << "    node [shape=circle];\n";

    int source = 0;
    int sink = 1;
    int node_id = 2;

    vector<int> product_nodes(m), city_nodes(n);
    for (int i = 0; i < m; ++i) product_nodes[i] = node_id++;
    for (int j = 0; j < n; ++j) city_nodes[j] = node_id++;

    // Source to product nodes (row constraints)
    for (int i = 0; i < m; ++i) {
        dotFile << "    S -> P" << i << " [label=\"(" << row_l[i] << "," << row_u[i] << ")\"];\n";
    }

    // City nodes to sink (column constraints)
    for (int j = 0; j < n; ++j) {
        dotFile << "    C" << j << " -> T [label=\"(" << col_l[j] << "," << col_u[j] << ")\"];\n";
    }

    // Product to city (cell constraints)
    for (int i = 0; i < m; ++i)
        for (int j = 0; j < n; ++j)
            dotFile << "    P" << i << " -> C" << j << " [label=\"(" << L[i][j] << "," << U[i][j] << ")\"];\n";

    // Define nodes
    dotFile << "    S [label=\"Source\"];\n";
    dotFile << "    T [label=\"Sink\"];\n";
    for (int i = 0; i < m; ++i)
        dotFile << "    P" << i << " [label=\"P" << i << "\"];\n";
    for (int j = 0; j < n; ++j)
        dotFile << "    C" << j << " [label=\"C" << j << "\"];\n";

    dotFile << "}\n";
    dotFile.close();

    cout << "Graph saved to graph.dot. Use Graphviz to visualize (e.g., run: dot -Tpng graph.dot -o graph.png).\n";
    return 0;
}
