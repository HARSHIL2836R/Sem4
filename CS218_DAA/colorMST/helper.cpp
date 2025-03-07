#include<bits/stdc++.h>
  
using namespace std; 

// Creating shortcut for an integer pair 
typedef pair<int, int> iPair;

// Structure to represent a graph 
struct Graph 
{ 
	int V, E;
 	vector< pair<int, iPair> > edges; 
	vector<int> isred; // If index is 1, corresponding edge is red

	// Constructor 
	Graph(int V, int E) 
	{ 
		this->V = V; 
		this->E = E; 
 	} 

	// Utility function to add an edge  // red=1 means red
	void addEdge(int u, int v, int w, int red) 
	{ 
		edges.push_back({w, {u, v}});
		isred.push_back(red);
	} 

	void sort_edges(char param)
	{
		if (param == 'w'){
			sort(edges.begin(),edges.end(),[](pair<int, iPair> a, pair<int, iPair> b){
				return a.first < b.first;
			});
		}
		if (param == 'e'){
			sort(edges.begin(),edges.end(),[](pair<int, iPair> a, pair<int, iPair> b){
				return a.second.first < b.second.first;
			});
		}
	}

	void print()
	{
		sort_edges('e');
		for (auto edge: edges)
		{
			cout<<edge.second.first<<" --- "<<edge.second.second<<"\tw:\t"<<edge.first<<endl;
		}
	}

	int check_cycle(pair<int, iPair> edge)
	{
		edges.push_back(edge);
		E++;
		vector <int> visited(E,0);
		vector <int> parent(E,-1);
		if (DFSrec(this,0,visited,parent))
			return 1;
		else
		{
			edges.pop_back();
			E--;
			return 0;
		}
	}

	int DFSrec(Graph *g, int i, vector<int> &visited, vector<int> &parent)
	{ // i is index of vertex
		visited[i] = 1;
		for (int j =0; j<g->E;j++)
		{
			auto vp = g->edges[j].second;
			if (vp.first == i){
				if (parent[i] == vp.second) continue;
				if (visited[vp.second]) return 1;
				parent[vp.second] = vp.first;
				return DFSrec(g,vp.second, visited, parent);
			}
			else if (vp.second == i){
				if (parent[i] == vp.first) continue;
				if (visited[vp.first]) return 1;
				parent[vp.first] = vp.second;
				return DFSrec(g,vp.first, visited, parent);
			}
		}
		return 0;
	}
}; 

void make_mst(Graph &mst, Graph &g)
{
	g.sort_edges('w');
	for (int i=0; i<g.E;i++)
	{
		auto edge = g.edges[i];
		cout<<edge.second.first<<" "<<edge.second.second<<endl;
		if (mst.check_cycle(edge))
			continue;
		else
		{
			mst.addEdge(edge.second.first,edge.second.second,edge.first,g.isred[i]);
			mst.E++;
		}
	}
}

 int main() 
{ 
	int V, E; 
	int threshold;  

	cin >> V;
	cin >> E;
	cin >> threshold;
	Graph g(V, E); 
 

	int u, v, w, r;

	for (int i=0; i< E; i++){
		cin >> u;
		cin >> v;
		cin >> w;
		cin >> r;
		g.addEdge(u, v, w, r); 
 	}

 	cout << 0 << endl;
	cout << 0 << endl;

	// g.print();
	Graph spanning_tree(V,E);
	make_mst(spanning_tree, g);
	cout<<"FUCK"<<endl;
	spanning_tree.print();

	return 0; 
} 

