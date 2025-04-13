#include<bits/stdc++.h>

using namespace std; 
// m products and n cities m*n matrix for lower and upper bound
// each row represents distribution to all cities for a product

/*
	TRANSFORMATION OF GRAPH:
	1. Add a source node and a sink node and add edges with given upper limit for each prod and source.
		s --- > v e(s,v) = r[i]

	2. To convert this to demand with no lower bound, add flow[i,j] = lower[i,j] and check if it is feasible.
		if not, then create new same network with following changes:
			1. add demands to each node as fv(in) - fv(out)
			2. new cap[i,j] = upper[i,j] - lower[i,j]
	
	3. problem reduced to feasible flow with demands. 
	4. For each having positive demands (sinks) add superior sink + cap(t,t*) = |demand[t]|
		for negative demands, add superior source + cap(s*,s) = |demand[s]|
	5. Find max flow from s* to t* and check if all edges from s* are saturated 
	6. If yes, then feasible flow exists, else no feasible flow exists.
		because, if all edges from s* are saturated, then all demands of sources are met.

*/

class Graph{
	public:
	vector<vector<int>> adj;
	vector<vector<int>> cap;
	vector<vector<int>> low;
	vector<vector<int>> augmented_adj;

	vector<vector<int>> OrigCap;
	vector<int> demand;
	vector<int> parent;
	int n, lower_flow;
	int source,sink;
	Graph(int n){
		this->n = n;
		adj.resize(n);
		cap.resize(n, vector<int>(n, 0));
		low.resize(n, vector<int>(n, 0));
		OrigCap.resize(n, vector<int>(n,0));
		augmented_adj.resize(n);
		demand.resize(n, 0);
		parent.resize(n, -1);
		source = n-2;
		lower_flow=0;
		sink = n-1;
	}
	void addEdge(int u, int v, int c, int l){
		OrigCap[u][v] = c;
		adj[u].push_back(v);
		cap[u][v] = c;
		low[u][v] = l;
		augmented_adj[u].push_back(v);
		augmented_adj[v].push_back(u);
	}

	void printAdj(){
		for(int i=0; i<n; i++){
			cerr << i << " : ";
			for(auto j: adj[i]){
				cerr << j << ": " << cap[i][j] << "  ";
			}
			cerr << endl;
		}
			cerr<<endl;
	}

	int bfs(){
		vector<bool> visited(n, false);
		fill(parent.begin(), parent.end(), -1);
		queue<pair<int,int>> q;
		q.push({source, INT_MAX});
		visited[source] = true;
		parent[source] = -1;
		while(!q.empty()){
			auto f = q.front();
			int u = f.first;
			int curr_flow = f.second;
			q.pop();
			for(int v: augmented_adj[u]){
				if(!visited[v] && cap[u][v]){
					int new_flow = min(curr_flow, cap[u][v]);
					parent[v] = u;
					visited[v] = true;
					if(v == sink){
						return new_flow;
					}
					q.push({v,new_flow});
				}
			}
		}
		return 0;
	}
};

Graph* createGraph(vector<vector<int>> &lower, vector<vector<int>> &upper,
 vector<int> &rowL, vector<int> &rowU, vector<int> &colL, vector<int> &colU){
	int m = lower.size();
	int n = lower[0].size();
	int total_nodes = m + n + 2;
	Graph* g = new Graph(total_nodes);

	for(int i=0; i<m; i++){
		g->addEdge(g->source, i, rowU[i], rowL[i]);
	}
	for(int j=0; j<n; j++){
		g->addEdge(m+j, g->sink, colU[j], colL[j]);
	}
	for(int i=0; i<m; i++){
		for(int j=0; j<n; j++){
			g->addEdge(i, m+j, upper[i][j], lower[i][j]);
		}
	}
	// add edge between sink and source 
	int lower_total = max(accumulate(rowL.begin(), rowL.end(), 0),accumulate(colL.begin(), colL.end(), 0));
	int upper_total = min(accumulate(rowU.begin(), rowU.end(), 0),accumulate(colU.begin(), colU.end(), 0));

	g->addEdge(g->sink, g->source, upper_total, lower_total);

	return g;
 }

 Graph* AddSuperSourceSink(Graph* g){
	int total_nodes = g->n;
	Graph* g2 = new Graph(total_nodes+2);
	for(int i=0; i<total_nodes; i++){
		for(auto j: g->adj[i]){
			g2->addEdge(i, j, g->cap[i][j]-g->low[i][j], 0);
			g2->demand[i] += g->low[i][j];
			g2->demand[j] -= g->low[i][j];
		}
	}
	// g2->demand[g->source] = 0;
	// g2->demand[g->sink] = 0;
	int total_demand = 0;
	for(int i=0; i<total_nodes; i++){
		if(g2->demand[i] < 0){
			g2->addEdge(total_nodes, i, -g2->demand[i], 0);
			total_demand += -g2->demand[i];
		}
		else if(g2->demand[i] > 0){
			// total_demand += g2->demand[i];
			g2->addEdge(i, total_nodes+1, g2->demand[i], 0);
		}
	}
	// cerr << "Total Demand: " << total_demand << endl;
	g2->printAdj();
	return g2;
 }

 bool isFeasible(Graph* g){
	int flow = 0;
	while(true){
		int new_flow = g->bfs();
		if(new_flow == 0){
			break;
		}
		flow += new_flow;
		int curr = g->sink;
		while(curr != g->source){
			int prev = g->parent[curr];
			g->cap[prev][curr] -= new_flow;
			g->cap[curr][prev] += new_flow;
			curr = prev;
		}
	}
	for(int i=0; i<g->n; i++){
		cerr << g->demand[i] << " ";
	}
	cerr <<endl;
	int total_demand = 0;
	for(int i=0; i<g->n; i++){
		if(g->demand[i] > 0){
			total_demand += g->demand[i];
		}
	}
	cerr << "Total Demand: " << total_demand << endl;
	cerr << "Flow: " << flow << endl;
	if(flow != total_demand){
		return false;
	}
	return true;

 }

int maxFlow(Graph* g){

}

 int main() 
{
	freopen("input4", "r", stdin);
	freopen("output", "w", stdout); 

	int m,n; 

	cin >> m;
	cin >> n;
    std::vector<std::vector<int> >lower;
	std::vector<std::vector<int> >upper;

 	std::vector<int>rowL;
 	std::vector<int>rowU;
 	std::vector<int>colL;
 	std::vector<int>colU;

	int temp;

	for (int i=0; i< m; i++){
		std::vector<int>tempVector;
		for (int j=0; j< n; j++){
			cin >> temp;
			tempVector.push_back(temp);
		}
		lower.push_back(tempVector);
 	}

	for (int i=0; i< m; i++){
		std::vector<int>tempVector;
		for (int j=0; j< n; j++){
			cin >> temp;
			tempVector.push_back(temp);
		}
		upper.push_back(tempVector);
 	}


 	for (int i=0; i< m; i++){
		cin >> temp;
		rowL.push_back(temp);
		cin >> temp;
		rowU.push_back(temp);
	}

	for (int j=0; j< n; j++){
		cin >> temp;
		colL.push_back(temp);
		cin >> temp;
		colU.push_back(temp);
	}

	auto g = createGraph(lower, upper, rowL, rowU, colL, colU);
	auto g_new = AddSuperSourceSink(g);
	bool feasible = isFeasible(g_new);
	if(feasible){
		cerr << g_new->cap[g->source][g->sink] + g->low[g->sink][g->source] << endl;
	    
	}
	else{
		cout << "Feasible Flow does not exist" << endl;
	}



	return 0; 
} 

/*
	for (int i=0; i< m; i++){
		for (int j=0; j< n; j++){
			cout << lower[i][j] << " ";
		}
		cout << endl;
 	}
	for (int i=0; i< m; i++){
		for (int j=0; j< n; j++){
			cout << upper[i][j] << " ";
		}
		cout << endl;
 	}
	for (int i=0; i< m; i++){
		cout << rowL[i] << " ";
		cout << rowU[i] << " ";
	}

	cout << endl;

	for (int j=0; j< n; j++){
		cout << colL[j] << " ";
		cout << colU[j] << " ";
	}

 
*/