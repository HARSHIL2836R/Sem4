#include <bits/stdc++.h>
using namespace std;

struct Graph
{
	vector<vector<int>> adj;
	vector<vector<int>> high;
	vector<vector<int>> low;
	vector<vector<int>> path_adj;

	vector<int> demand;
	vector<int> parent;

	int n, source, sink;

	Graph(int n)
	{
		this->n = n;
		adj.resize(n);
		high.resize(n, vector<int>(n, 0));
		low.resize(n, vector<int>(n, 0));

		path_adj.resize(n);
		demand.resize(n, 0);
		parent.resize(n, -1);
		source = n - 2;
		sink = n - 1;
	}

	void add_edge(int u, int v, int h, int l)
	{
		adj[u].emplace_back(v);
		high[u][v] = h;
		low[u][v] = l;
		path_adj[u].push_back(v);
		path_adj[v].push_back(u);
	}

	int bfs()
	{
		vector<bool> visited(n, false);
		fill(parent.begin(), parent.end(), -1);
		queue<pair<int, int>> pq;
		pq.push({source, INT_MAX});
		visited[source] = true;
		parent[source] = -1;
		while (!pq.empty())
		{
			auto node = pq.front();
			pq.pop();
			int u = node.first;
			int curr_flow = node.second;

			for (int v : path_adj[u])
			{
				if (!visited[v] && high[u][v])
				{
					int new_flow = min(curr_flow, high[u][v]);
					parent[v] = u;
					visited[v] = true;
					if (v == sink)
					{
						return new_flow;
					}
					pq.push({v, new_flow});
				}
			}
		}
		return 0;
	}
};

Graph *make_graph(
	vector<vector<int>> &lower,
	vector<vector<int>> &upper,
	vector<int> &rowL,
	vector<int> &rowU,
	vector<int> &colL,
	vector<int> &colU)
{
	int m = lower.size();
	int n = lower[0].size();
	int total_nodes = m + n + 2;

	Graph *g = new Graph(total_nodes);

	int i;
	for (i = 0; i < m; i++)
	{
		g->add_edge(g->source, i, rowU[i], rowL[i]);
	}
	for (i = 0; i < n; i++)
	{
		g->add_edge(m + i, g->sink, colU[i], colL[i]);
	}
	for (i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			g->add_edge(i, m + j, upper[i][j], lower[i][j]);
		}
	}

	// Edge betweeen sink and source
	int totalL = max(accumulate(rowL.begin(), rowL.end(), 0), accumulate(colL.begin(), colL.end(), 0));
	int totalU = min(accumulate(rowU.begin(), rowU.end(), 0), accumulate(colU.begin(), colU.end(), 0));

	g->add_edge(g->sink, g->source, totalU, totalL);

	return g;
}

Graph *make_super_source(Graph *g)
{
	int total_nodes = g->n;

	Graph *g2 = new Graph(total_nodes + 2);
	int super_source = total_nodes;
	int super_sink = total_nodes + 1;

	// Calculate demands and adjust capacities
	for (int u = 0; u < total_nodes; u++)
	{
		for (int v : g->adj[u])
		{
			int lower_bound = g->low[u][v];
			int upper_bound = g->high[u][v];

			// Add edge with adjusted capacity
			g2->add_edge(u, v, upper_bound - lower_bound, 0);

			// Update demands
			g2->demand[u] += lower_bound;
			g2->demand[v] -= lower_bound;
		}
	}

	// Add edges from super source and to super sink
	for (int i = 0; i < total_nodes; i++)
	{
		if (g2->demand[i] < 0)
		{
			g2->add_edge(super_source, i, -g2->demand[i], 0);
		}
		else if (g2->demand[i] > 0)
		{
			g2->add_edge(i, super_sink, g2->demand[i], 0);
		}
	}

	return g2;
}

bool is_feasible(Graph *g)
{
	int flow = 0;
	while (true)
	{
		int new_flow = g->bfs();
		if (new_flow == 0)
			break;

		flow += new_flow;
		int curr = g->sink;
		while (curr != g->source)
		{
			int prev = g->parent[curr];
			g->high[prev][curr] -= new_flow;
			g->high[curr][prev] += new_flow;
			curr = prev;
		}
	}

	int total_demand = 0;
	for (int i = 0; i < g->n; i++)
	{
		if (g->demand[i] > 0)
			total_demand += g->demand[i];
	}

	return flow == total_demand;
}

int maximise_flow(Graph *g, Graph *g2)
{
	Graph *g3 = new Graph(g->n);

	for (int u=0;u<g->n;u++)
	{
		for (int v: g->adj[u])
		{
			g3->add_edge(u,v,g->high[u][v] - g2->high[v][u] - g->low[u][v],0);
		}
	}

	int flow = 0;
	while (true)
	{
		int new_flow = g3->bfs();
		if (new_flow == 0)
			break;

		flow += new_flow;
		int curr = g3->sink;
		while (curr != g3->source)
		{
			int prev = g3->parent[curr];
			g3->high[prev][curr] -= new_flow;
			g3->high[curr][prev] += new_flow;
			curr = prev;
		}
	}

	return flow;
}

int main()
{
	int m, n;
	cin >> m >> n;

	vector<vector<int>> lower(m, vector<int>(n));
	vector<vector<int>> upper(m, vector<int>(n));
	vector<int> rowL(m), rowU(m), colL(n), colU(n);

	for (int i = 0; i < m; i++)
		for (int j = 0; j < n; j++)
			cin >> lower[i][j];

	for (int i = 0; i < m; i++)
		for (int j = 0; j < n; j++)
			cin >> upper[i][j];

	for (int i = 0; i < m; i++)
		cin >> rowL[i] >> rowU[i];

	for (int j = 0; j < n; j++)
		cin >> colL[j] >> colU[j];

	// Make original Graph similar to network flow between products and cities
	// This is a circulation flow graph
	// Source and sink are added to capture the R and C constraint
	auto g = make_graph(lower, upper, rowL, rowU, colL, colU);
	// Make another graph which checks whether the demands of circulation flow
	// in previous graph are staistfiable or not
	auto g_sss = make_super_source(g);
	// Check
	bool feasible = is_feasible(g_sss);

	
	if (feasible)
	{
		// If demands are satisfiable, the minimum flow will be the lower bound
		// from sink to source in Original graph plus the flow acquired to satisfy
		// the network demands
		int min_flow = g->low[g->sink][g->source] + g_sss->high[g->source][g->sink];
	
		// Maximum flow is obtained by applying max flow algo on a duplicate graph with
		// capacities as constraints so that the new flow does not surpass the high value
		int max_flow = maximise_flow(g,g_sss)+min_flow;


		cout << 1 << endl;
		cout<<max_flow<<endl;
		cout << min_flow <<endl;
	}
	else
	{
		cout << 0 << endl;
	}

	return 0;
}
