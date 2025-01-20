import numpy as np
from collections import deque
import heapq
from typing import List, Tuple, Set, Dict
"""
Do not import any other package unless allowed by te TAs in charge of the lab.
Do not change the name of any of the functions below.
"""

none_array = np.array([[0,0,0],[0,0,0],[0,0,0]])
class node:
    def __init__(self, matrix, moves, cost_to_start,cost_to_goal):
        # self.parent = parent
        self.matrix = matrix
        self.moves = moves
        self.blank = (np.where(matrix == 0)[0][0],np.where(matrix == 0)[1][0])
        self.cost_to_start = cost_to_start #g
        self.cost_to_goal = cost_to_start #h
        self.cost = cost_to_start + cost_to_goal #f = g + h

    # def successor(self, move):
    #     suc=self.mat
    #     # x, y=self.blank
    #     if move=='R':
    #         suc[i][j]

    def update_cost(self, type, goal):
        if type == 'bfs':
            self.cost_to_start+=1
            self.cost=self.cost_to_start
            
        elif type == 'dfs':
            if self.cost_to_start == 0: 
                self.cost_to_start = 1
            else:
                self.cost_to_start=1/(1+1/self.cost_to_start)
            self.cost=self.cost_to_start

        elif type=='dt':
            self.cost_to_start+=1
            self.cost_to_goal = np.sum(self.matrix!=goal) - 1
            self.cost=self.cost_to_start+self.cost_to_goal

        elif type=='md':
            self.cost_to_start+=1
            md_cost=0
            for i in range(9):
                x1, y1 = np.where(self.matrix == i)[0][0],np.where(self.matrix == i)[1][0]
                x2, y2 = np.where(goal == i)[0][0],np.where(goal == i)[1][0]
                md_cost+=(abs(x1-x2)+abs(y1-y2))
            self.cost_to_goal= md_cost
            self.cost=self.cost_to_start+self.cost_to_goal
            
    def move(self, direction):
        next=self.matrix.copy()
        x, y=self.blank
        if direction == 'U':
            if x==0 :
                return none_array
            else:
                next[x-1][y], next[x][y]=next[x][y], next[x-1][y]
        elif direction == 'D':
            if x==2 :
                return none_array
            else:
                next[x+1][y], next[x][y]=next[x][y], next[x+1][y]
        elif direction == 'L':
            if y==0 :
                return none_array
            else:
                next[x][y-1], next[x][y]=next[x][y], next[x][y-1]
        elif direction == 'R':
            if y==2 :
                return none_array
            else:
                next[x][y+1], next[x][y]=next[x][y], next[x][y+1]
        return next
    
    def __lt__(self, other):
        return self.cost < other.cost

def bfs(initial: np.ndarray, goal: np.ndarray) -> Tuple[List[str], int]:
    """
    Implement Breadth-First Search algorithm to solve 8-puzzle problem.
    
    Args:
        initial (np.ndarray): Initial state of the puzzle as a 3x3 numpy array.
                            Example: np.array([[1, 2, 3], [4, 0, 5], [6, 7, 8]])
                            where 0 represents the blank space
        goal (np.ndarray): Goal state of the puzzle as a 3x3 numpy array.
                          Example: np.array([[1, 2, 3], [4, 5, 6], [7, 8, 0]])
    
    Returns:
        Tuple[List[str], int]: A tuple containing:
            - List of moves to reach the goal state. Each move is represented as
              'U' (up), 'D' (down), 'L' (left), or 'R' (right), indicating how
              the blank space should move
            - Number of nodes expanded during the search

    Example return value:
        (['R', 'D', 'R'], 12) # Means blank moved right, down, right; 12 nodes were expanded
              
    """
    # TODO: Implement this function
    open = []
    closed = set()
    num_expansions = 0
    heapq.heappush(open, node(initial, [], 0, 0))

    while not len(open) == 0:
        # curr_node = open.pop(-1)
        curr_node = heapq.heappop(open)
        closed.add(tuple(curr_node.matrix.flatten()))


        # print(curr_node.matrix, "\n", goal,"\n")

        if (curr_node.matrix == goal).all():
            return (curr_node.moves, num_expansions)
        
        else:
            num_expansions += 1
            dirns = ('U','R','D','L')
            for dirn in dirns:
                new_mat = curr_node.move(dirn)
                if not (new_mat == none_array).all():
                    # print(curr_node.matrix, "\n",dirn, "\n",new_mat)
                    # print(new_mat)
                    next_node = node(curr_node.move(dirn),curr_node.moves.copy(),curr_node.cost_to_start,curr_node.cost_to_goal)
                    next_node.moves.append(dirn)
                    if tuple(next_node.matrix.flatten()) not in closed:
                        next_node.update_cost('bfs', goal)
                        # open.append(next_node)
                        heapq.heappush(open, next_node)
        
        # heapq.heapify(open)
        # print(len(open))
        # print(len(closed))
        # print("\n")
        
    return ([],0)

def dfs(initial: np.ndarray, goal: np.ndarray) -> Tuple[List[str], int]:
    """
    Implement Depth-First Search algorithm to solve 8-puzzle problem.
    
    Args:
        initial (np.ndarray): Initial state of the puzzle as a 3x3 numpy array
        goal (np.ndarray): Goal state of the puzzle as a 3x3 numpy array
    
    Returns:
        Tuple[List[str], int]: A tuple containing:
            - List of moves to reach the goal state
            - Number of nodes expanded during the search
    """
    # TODO: Implement this function
    open = []
    closed = set()
    num_expansions = 0
    heapq.heappush(open, node(initial, [], 0, 0))

    while not len(open) == 0:
        # curr_node = open.pop(-1)
        curr_node = heapq.heappop(open)
        closed.add(tuple(curr_node.matrix.flatten()))

        if (curr_node.matrix == goal).all():
            return (curr_node.moves, num_expansions)
        
        else:
            num_expansions += 1
            dirns = ('U','R','D','L')
            for dirn in dirns:
                new_mat = curr_node.move(dirn)
                if not (new_mat == none_array).all():
                    # print(curr_node.matrix, "\n",dirn, "\n",new_mat)
                    # print(new_mat)
                    next_node = node(curr_node.move(dirn),curr_node.moves.copy(),curr_node.cost_to_start,curr_node.cost_to_goal)
                    next_node.moves.append(dirn)
                    if tuple(next_node.matrix.flatten()) not in closed:
                        next_node.update_cost('dfs', goal)
                        # open.append(next_node)
                        heapq.heappush(open, next_node)
        print(len(open))
        print(len(closed))
        print("\n")
        
    return ([],0)

def dijkstra(initial: np.ndarray, goal: np.ndarray) -> Tuple[List[str], int, int]:
    """
    Implement Dijkstra's algorithm to solve 8-puzzle problem.
    
def heuristic_dt():
    Args:
        initial (np.ndarray): Initial state of the puzzle as a 3x3 numpy array
        goal (np.ndarray): Goal state of the puzzle as a 3x3 numpy array
    
    Returns:
        Tuple[List[str], int, int]: A tuple containing:
            - List of moves to reach the goal state
            - Number of nodes expanded during the search
            - Total cost of the path for transforming initial into goal configuration
            
    """
    # TODO: Implement this function

    open = []
    closed = set()
    num_expansions = 0
    heapq.heappush(open, node(initial, [], 0, 0))

    while not len(open) == 0:
        # curr_node = open.pop(-1)
        curr_node = heapq.heappop(open)
        closed.add(tuple(curr_node.matrix.flatten()))

        if (curr_node.matrix == goal).all():
            return (curr_node.moves, num_expansions, len(curr_node.moves))
        
        else:
            num_expansions += 1
            dirns = ('U','R','D','L')
            for dirn in dirns:
                new_mat = curr_node.move(dirn)
                if not (new_mat == none_array).all():
                    # print(curr_node.matrix, "\n",dirn, "\n",new_mat)
                    # print(new_mat)
                    next_node = node(curr_node.move(dirn),curr_node.moves.copy(),curr_node.cost_to_start,curr_node.cost_to_goal)
                    next_node.moves.append(dirn)
                    if tuple(next_node.matrix.flatten()) not in closed:
                        next_node.update_cost('bfs', goal)
                        # open.append(next_node)
                        heapq.heappush(open, next_node)
        
    return ([],0,0)

def astar_dt(initial: np.ndarray, goal: np.ndarray) -> Tuple[List[str], int, int]:
    """
    Implement A* Search with Displaced Tiles heuristic to solve 8-puzzle problem.
    
    Args:
        initial (np.ndarray): Initial state of the puzzle as a 3x3 numpy array
        goal (np.ndarray): Goal state of the puzzle as a 3x3 numpy array
    
    Returns:
        Tuple[List[str], int, int]: A tuple containing:
            - List of moves to reach the goal state
            - Number of nodes expanded during the search
            - Total cost of the path for transforming initial into goal configuration
              
    
    """
    # TODO: Implement this function
    open = []
    closed = set()
    num_expansions = 0
    heapq.heappush(open, node(initial, [], 0, 0))

    while not len(open) == 0:
        # curr_node = open.pop(-1)
        curr_node = heapq.heappop(open)
        closed.add(tuple(curr_node.matrix.flatten()))

        if (curr_node.matrix == goal).all():
            return (curr_node.moves, num_expansions, len(curr_node.moves))
        
        else:
            num_expansions += 1
            dirns = ('U','R','D','L')
            for dirn in dirns:
                new_mat = curr_node.move(dirn)
                if not (new_mat == none_array).all():
                    # print(curr_node.matrix, "\n",dirn, "\n",new_mat)
                    # print(new_mat)
                    next_node = node(curr_node.move(dirn),curr_node.moves.copy(),curr_node.cost_to_start,curr_node.cost_to_goal)
                    next_node.moves.append(dirn)
                    if tuple(next_node.matrix.flatten()) not in closed:
                        next_node.update_cost('dt', goal)
                        # open.append(next_node)
                        heapq.heappush(open, next_node)
        
    return ([],0,0)

def astar_md(initial: np.ndarray, goal: np.ndarray) -> Tuple[List[str], int, int]:
    """
    Implement A* Search with Manhattan Distance heuristic to solve 8-puzzle problem.
    
    Args:
        initial (np.ndarray): Initial state of the puzzle as a 3x3 numpy array
        goal (np.ndarray): Goal state of the puzzle as a 3x3 numpy array
    
    Returns:
        Tuple[List[str], int, int]: A tuple containing:
            - List of moves to reach the goal state
            - Number of nodes expanded during the search
            - Total cost of the path for transforming initial into goal configuration
    """
    # TODO: Implement this function
    open = []
    closed = set()
    num_expansions = 0
    heapq.heappush(open, node(initial, [], 0, 0))

    while not len(open) == 0:
        # curr_node = open.pop(-1)
        curr_node = heapq.heappop(open)
        closed.add(tuple(curr_node.matrix.flatten()))

        if (curr_node.matrix == goal).all():
            return (curr_node.moves, num_expansions, len(curr_node.moves))
        
        else:
            num_expansions += 1
            dirns = ('U','R','D','L')
            for dirn in dirns:
                new_mat = curr_node.move(dirn)
                if not (new_mat == none_array).all():
                    # print(curr_node.matrix, "\n",dirn, "\n",new_mat)
                    # print(new_mat)
                    next_node = node(curr_node.move(dirn),curr_node.moves.copy(),curr_node.cost_to_start,curr_node.cost_to_goal)
                    next_node.moves.append(dirn)
                    if tuple(next_node.matrix.flatten()) not in closed:
                        next_node.update_cost('md', goal)
                        # open.append(next_node)
                        heapq.heappush(open, next_node)
        
    return ([],0,0)

# Example test case to help verify your implementation
if __name__ == "__main__":
    # Example puzzle configuration
    initial_state = np.array([
        # [1, 2, 3],
        # [4, 0, 5],
        # [6, 7, 8]
        [1,3,2],
        [4,5,6],
        [7,0,8]
    ])
    
    goal_state = np.array([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
    ])
    
    # Test each algorithm
    # print("Testing BFS...")
    # bfs_moves, bfs_expanded = bfs(initial_state, goal_state)
    # print(f"BFS Solution: {bfs_moves}")
    # print(f"Nodes expanded: {bfs_expanded}")
    
    print("\nTesting DFS...")
    dfs_moves, dfs_expanded = dfs(initial_state, goal_state)
    print(f"DFS Solution: {dfs_moves}")
    print(f"Nodes expanded: {dfs_expanded}")
    
    print("\nTesting Dijkstra...")
    dijkstra_moves, dijkstra_expanded, dijkstra_cost = dijkstra(initial_state, goal_state)
    print(f"Dijkstra Solution: {dijkstra_moves}")
    print(f"Nodes expanded: {dijkstra_expanded}")
    print(f"Total cost: {dijkstra_cost}")
    
    print("\nTesting A* with Displaced Tiles...")
    dt_moves, dt_expanded, dt_fscore = astar_dt(initial_state, goal_state)
    print(f"A* (DT) Solution: {dt_moves}")
    print(f"Nodes expanded: {dt_expanded}")
    print(f"Total cost: {dt_fscore}")
    
    print("\nTesting A* with Manhattan Distance...")
    md_moves, md_expanded, md_fscore = astar_md(initial_state, goal_state)
    print(f"A* (MD) Solution: {md_moves}")
    print(f"Nodes expanded: {md_expanded}")
    print(f"Total cost: {md_fscore}")