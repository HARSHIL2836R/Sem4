#include<bits/stdc++.h>

using namespace std; 

// Creating shortcut for an integer pair 
typedef pair<int, int> iPair;
typedef pair<int, iPair> edg;

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
			// return find_set(parent[v]);
		return parent[v];
	}

	void _union(int u, int v)
	{
		u = find_set(u);
		v = find_set(v);
		if (size[u]<size[v])
		{// SWAP
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
	vector<edg> redges,bedges;
	UnionFind UF;
	vector<vector<int>> adj;
	map<edg,bool> valid;

	// Constructor 
	Graph(int V) 
	{ 
		this->V = V; 
		this->E = 0; 
		this->UF = UnionFind(V);
		for (int i=0;i<V;i++)
			UF.make_set(i);
		this->adj.resize(V);
	}

	// Utility function to add an edge  // red=1 means red
	void addEdge(int u, int v, int w, int red) 
	{ 
		if (red)
			redges.push_back({w,{u,v}});
		else
			bedges.push_back({w,{u,v}});
		adj[u].push_back(v);
		adj[v].push_back(u);

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

	void removeEdge(edg edge) {
		auto it = find(bedges.begin(), bedges.end(), edge);
		if (it != bedges.end()) bedges.erase(it);
	
		it = find(redges.begin(), redges.end(), edge);
		if (it != redges.end()) redges.erase(it);
	
		auto& vec1 = adj[edge.second.first];
		auto& vec2 = adj[edge.second.second];
	
		auto it1 = find(vec1.begin(), vec1.end(), edge.second.second);
		if (it1 != vec1.end()) vec1.erase(it1);
	
		auto it2 = find(vec2.begin(), vec2.end(), edge.second.first);
		if (it2 != vec2.end()) vec2.erase(it2);
	
		E--;
	}
	
}; 

void make_mrst(Graph &mst, Graph &g)
{
	// cout<<"test 1\n";
	for (int i=0;i<2;i++)
	{
		vector< edg > *edges;
		if (i==0) edges = & g.bedges;
		if (i==1) edges = & g.redges;
		// cout<<"test 2\n";
		sort(edges->begin(),edges->end(),[](edg a, edg b)
		{
			return a.first < b.first;
		});
		for (auto edge: *edges)
		{
			if (mst.connected(edge.second.first,edge.second.second) == 0){
				mst.valid[edge] = true;
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

void dfs(Graph &st, vector<int>& parent,int p, int u,vector<bool>& visited, vector<int>& cycle_edges){
	visited[u] = true;
	parent[u] = p;
	// cerr<<p<<u<<"dfsing\n";

	for(int i=0;i<st.adj[u].size(); i++){
		int v = st.adj[u][i];
		// cerr<<u<<","<<v<<"\n";
		if(!visited[v]){
			// cerr<<u<<v<<"dfsing\n";		
			dfs(st,parent,u,v,visited,cycle_edges);
		}
		else if(v != p){
			// cerr<<"in here\n";
			// extract cycle using parent pointers.
			cycle_edges.push_back(v);
			while(u != v){
				// cerr<<"cycle add "<<u<<endl;
				cycle_edges.push_back(u);
				u = parent[u];
			}
			throw "cycle detected";
		}
	}
}

vector<int> get_cycle(Graph &st)
{
	vector<int> parent(st.V,-1);
	vector<bool> visited(st.V,false);
	vector<int> cycle_edges;

	try{
		dfs(st,parent,-1,0,visited,cycle_edges);
	}
	catch(const char* msg){
		return cycle_edges;
	}
	return cycle_edges;
}

edg get_bedge(Graph &st, edg edge)
{
	// cerr<<"HERE\n";
	st.addEdge(edge.second.first,edge.second.second,edge.first,1);
	vector<int> cycle_edges = get_cycle(st);
	st.removeEdge(edge);
	// cerr<<"GOT CYCLEs"<<edge.second.first<<edge.second.second<< "\n";
	// for (int i=0;i<cycle_edges.size();i++)
	// 	cerr<<cycle_edges[i]<<", ";
	// cerr<<'\n';

	// sort(st.bedges.begin(),st.bedges.end(),[](edg a, edg b)
	// 	{
	// 		return a.first < b.first;
	// 	});
	for (int i = st.bedges.size()-1;i >= 0; i--)
	{
		auto it = find(cycle_edges.begin(),cycle_edges.end(),st.bedges[i].second.first);
		if (it!=cycle_edges.end())
		{
			if ((next(it) == cycle_edges.end() && cycle_edges[0] == st.bedges[i].second.second)
				|| (it == cycle_edges.begin() && cycle_edges[cycle_edges.size()-1] == st.bedges[i].second.second)
				|| (*next(it) == st.bedges[i].second.second)
				|| (*prev(it) == st.bedges[i].second.second))
				return st.bedges[i];
		}
	}
	perror("WHY HERE!!");
	return edge;
}

void swaps(Graph&st,Graph&g,priority_queue<pair<int,pair<edg,edg>>> &max_diff)
{
	for (int i=0; i<g.redges.size();i++)
	{
		if (!st.valid[g.redges[i]])
		{
			auto bedge = get_bedge(st,g.redges[i]);
			max_diff.push({bedge.first-g.redges[i].first,{bedge,g.redges[i]}});
		}
	}
}

void swap_blue_with_red(Graph &st, priority_queue<pair<int,pair<edg,edg>>> &max_diff)
{
	// cerr<<"YAYY\n";
	auto top = max_diff.top();
	max_diff.pop();

	auto old_edge = top.second.first;
	auto new_edge = top.second.second;

	if (!st.valid[old_edge])
	{
		auto bedge = get_bedge(st,new_edge);
		max_diff.push({bedge.first-new_edge.first,{bedge,new_edge}});
		return;
	}
	if (top.first > 0)
	{
		st.addEdge(new_edge.second.first,new_edge.second.second,new_edge.first,1);
		st.removeEdge(old_edge);

		auto cycle_edges = get_cycle(st);
		if (cycle_edges.size()>0)
		{
			st.removeEdge(new_edge);
			st.addEdge(old_edge.second.first,old_edge.second.second,old_edge.first,0);
			auto t = get_bedge(st,new_edge);
			max_diff.push({t.first-new_edge.first,{t,new_edge}});
			return;
		}

		st.valid[old_edge] = false;
		st.valid[new_edge] = true;
	}

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

	// g.print();
	Graph spanning_tree(V);
	make_mrst(spanning_tree,g);
	// cout<<"ONEDONE\n";
	// spanning_tree.print();
	// cout<<"Finish printing\n";
	int wt = spanning_tree.get_weight();

	if (wt > threshold)
	{
		priority_queue<pair<int,pair<edg,edg>>> max_diff;
		swaps(spanning_tree,g,max_diff);
		while (wt > threshold)
		{
			// cerr<<"here\n";
			swap_blue_with_red(spanning_tree,max_diff);
			wt = spanning_tree.get_weight();
		}
	}

	cout<< spanning_tree.redges.size()<<endl;
	cout<<wt<<endl;
	return 0;
}