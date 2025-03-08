#include<bits/stdc++.h>

using namespace std; 

// Creating shortcut for an integer pair 
typedef pair<int, int> iPair;

struct UnionFind
{
	vector<int> parent,size;

	UnionFind(){}

	UnionFind(int V)
	{
		parent = vector<int>(V,-1);
		size = vector<int>(V,0);
	}
	
	void make_set(int v)
	{
		parent[v] = v;
		size[v] = 1;
	}

	int find_set(int v)
	{
		if (parent[v] != v)
			parent[v] = find_set(parent[v]);
		return parent[v];
	}

	void _union(int u, int v)
	{
		u = find_set(u);
		v = find_set(v);
		if (size[u]<size[v])
		{
			u = u + v;
			v = u - v;
			u = u - v;
		}
		parent[v] = u;
		size[u] = size[u] + size[v];
	}
};

// Structure to represent a graph 
struct Graph 
{ 
	int V, E;
	vector< pair<int, iPair> > redges,bedges;
	UnionFind UF;

	// Constructor 
	Graph(int V) 
	{ 
		this->V = V; 
		this->E = 0; 
		this->UF = UnionFind(V);
		for (int i=0;i<V;i++)
			UF.make_set(i);
	} 

	// Utility function to add an edge  // red=1 means red
	void addEdge(int u, int v, int w, int red) 
	{ 
		if (red)
			redges.push_back({w,{u,v}});
		else
			bedges.push_back({w,{u,v}});
		
		E++;

		UF._union(u,v);
	}

	void print()
	{
		cout<<"---\n";
		for (auto edge: redges)
		{
			cout<<edge.second.first<<" --- "<<edge.second.second<<"\tw:"<<edge.first<<"\tr:1"<<endl;
		}
		for (auto edge: bedges)
		{
			cout<<edge.second.first<<" --- "<<edge.second.second<<"\tw:"<<edge.first<<"\tr:0"<<endl;
		}
		cout<<"---\n";
	}

	int connected(int u, int v)
	{
		if (UF.find_set(u) == UF.find_set(v))
			return 1;
		else
			return 0;
	}

	int get_weight()
	{
		int w=0;
		for (auto edge: redges)
		{
			w+=edge.first;
		}
		for (auto edge: bedges)
		{
			w+=edge.first;
		}
		// cout<<"Total weight: "<<w<<endl;
		return w;
	}
}; 

void make_mst(Graph &mst, Graph &g)
{
	// cout<<"test 1\n";
	for (int i=0;i<2;i++)
	{
		vector< pair<int, iPair> > *edges;
		if (i==0) edges = & g.bedges;
		if (i==1) edges = & g.redges;
		// cout<<"test 2\n";
		sort(edges->begin(),edges->end(),[](pair<int, iPair> a, pair<int, iPair> b)
		{
			return a.first < b.first;
		});
		for (auto edge: *edges)
		{
			if (mst.connected(edge.second.first,edge.second.second) == 0){
				if (i==0)
					mst.addEdge(edge.second.first,edge.second.second,edge.first,0);
				else if (i==1)
					mst.addEdge(edge.second.first,edge.second.second,edge.first,1);
				else
					cout<<i<<" Error!!\n";
			}
		}
	}
}

void swap_blue_with_red(Graph &st, Graph g)
{
	auto biggest_blue_edge = st.bedges.back();
	// cout<<biggest_blue_edge.first<<endl;

}

int main()
{ 
	int V, E; 
	int threshold;  

	cin >> V;
	cin >> E;
	cin >> threshold;
	Graph g(V);

	int u, v, w, r;

	for (int i=0; i< E; i++){
		cin >> u;
		cin >> v;
		cin >> w;
		cin >> r;
		g.addEdge(u, v, w, r);
	}

	// cout << 0 << endl;
	// cout << 0 << endl;

	g.print();
	Graph spanning_tree(V);
	make_mst(spanning_tree,g);
	// cout<<"ONEDONE\n";
	spanning_tree.print();
	// cout<<"Finish printing\n";
	int wt = spanning_tree.get_weight();

	// while (wt > threshold)
	// {
	// 	swap_blue_with_red(spanning_tree,g);
	// }

	cout<< spanning_tree.redges.size()<<endl;
	cout<<wt<<endl;
	return 0;
}