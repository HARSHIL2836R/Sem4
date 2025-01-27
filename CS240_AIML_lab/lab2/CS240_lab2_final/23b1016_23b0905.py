import heapq
import json
from typing import List, Tuple


def check_valid(
    state: list, max_missionaries: int, max_cannibals: int
) -> bool:  # 10 marks
    """
    Graded
    Check if a state is valid. State format: [m_left, c_left, boat_position].
    """
    if ((state[0] > 0 and state[1] > state[0])
        or ((max_missionaries - state[0]) > 0 and (max_cannibals - state[1]) > (max_missionaries - state[0]))
        or state[0] > max_missionaries
        or state[0] < 0
        or state[1] > max_cannibals
        or state[1] < 0
        or state[2] < 0
        or state[2] > 1
        ):
        return False
    else:
        return True
    
    # raise ValueError("check_valid not implemented")


def get_neighbours(
    state: list, max_missionaries: int, max_cannibals: int
) -> List[list]:  # 10 marks
    """
    Graded
    Generate all valid neighbouring states.
    """
    # Possible cases on boat:
    #   mm, mc, cc, m, c
    # if not check_valid(state,max_missionaries,max_cannibals):
    #     raise ValueError("Input State not valid")
    
    possible_states = []
    m_lose = [2,1,0,1,0]
    c_lose = [0,1,2,0,1]
    if (state[2] == 1): # Boat is on left
        next_boat_pos = 0
    else:
        next_boat_pos = 1
    
    new_state = [None,None,None]
    # print(f"Original State {state}")
    for i in range(5):
        new_state[0] = next_boat_pos * (state[0] + m_lose[i]) + (1-next_boat_pos) * (state[0] - m_lose[i])
        new_state[1] = next_boat_pos * (state[1] + c_lose[i]) + (1-next_boat_pos) * (state[1] - c_lose[i])
        new_state[2] = next_boat_pos
        # print(f"New States {new_state}")
        if check_valid(new_state,max_missionaries,max_cannibals):
            # print(f"States Appended {new_state}")
            possible_states.append(new_state.copy())
    
    # print(f"Poss {possible_states}")
    return possible_states
    # raise ValueError("get_neighbours not implemented")


def gstar(state: list, new_state: list) -> int:  # 5 marks
    """
    Graded
    The weight of the edge between state and new_state, this is the number of people on the boat.
    """
    left=state[0]+state[1]
    left_new=new_state[0]+new_state[1]
    return abs(left-left_new)
    # raise ValueError("gstar not implemented")


def h1(state: list) -> int:  # 3 marks
    """
    Graded
    h1 is the number of people on the left bank.
    """
    return state[0]+state[1]
    # raise ValueError("h1 not implemented")

def h2(state: list) -> int:  # 3 marks
    """
    Graded
    h2 is the number of missionaries on the left bank. 
    """
    return state[0]
    # raise ValueError("h2 not implemented")


def h3(state: list) -> int:  # 3 marks
    """
    Graded
    h3 is the number of cannibals on the left bank.
    """
    return state[1]
    # raise ValueError("h3 not implemented")


def h4(state: list) -> int:  # 3 marks
    """
    Graded
    Weights of missionaries is higher than cannibals.
    h4 = missionaries_left * 1.5 + cannibals_left
    """
    ' <2,2,1> to <1,1,0> transition shows it is not MR'
    return state[0] * 1.5 + state[1]
    # raise ValueError("h4 not implemented")


def h5(state: list) -> int:  # 3 marks
    """
    Graded
    Weights of missionaries is lower than cannibals.
    h5 = missionaries_left + cannibals_left*1.5
    """
    ' <2,2,1> to <1,1,0> transition shows it is not MR'
    return state[0] + state[1] * 1.5
    # raise ValueError("h5 not implemented")

class node:
    def __init__(self,state,h,g):
        self.state = state
        self.g = g
        self.h = h
        self.cost = h(state) + g
        # self.parent = None
        
    def __lt__(self, other):
        return self.cost < other.cost
    
    # def update_parent(self, other):
    #     self.parent = other # {State : g}

    # def update_g(self):
    #     self.g = self.parent.g + gstar(self.parent.state,self.state)
    
    def update_cost(self):
        self.cost = self.h(self.state) + self.g

def compute_path(final_state,init_state,parent): # Function to Backtrack and get path as list
    path = []
    state = tuple(final_state)
    # print(init_state)
    while (state != tuple(init_state)):
        # print(state," ",init_state)
        path.append(state)
        state = parent[tuple(state)]
    
    path.append(state)
    path = reversed(path)
    return list(path)

def astar(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int, h, mr: bool
) -> Tuple[List[list], bool]:
    open=[]
    closed=dict() # States as Key and g values as value
    parent = dict() # State : State

    heapq.heappush(open, node(init_state,h,0))
    # print("HI")
    # print(f"Start: {init_state} End: {final_state} total_m {max_missionaries} total_c {max_cannibals}")
    while not len(open) == 0:
        # print("HI2")
        curr_node = heapq.heappop(open)
        closed.update({tuple(curr_node.state): curr_node.g})
        
        if curr_node.state == final_state:
            return compute_path(final_state, init_state,parent), mr
        
        nbrs=get_neighbours(curr_node.state, max_missionaries, max_cannibals)
        # print(nbrs)
        for new_state in nbrs:
            # print("NGBR")
            if tuple(new_state) not in closed: # Make a new node not already present in graph
                # print("NOT CLOSED")
                new_node = node(new_state,h,curr_node.g+gstar(curr_node.state,new_state))
                # new_node.update_parent({tuple(curr_node.state),curr_node.g})
                parent[tuple(new_node.state)] = tuple(curr_node.state)
                heapq.heappush(open,new_node)

            else:
                if (new_state == parent[tuple(curr_node.state)]):
                    continue
                else: # Update Parent pointer if required
                    if (curr_node.cost > closed[tuple(new_state)] + gstar(new_state,curr_node.state)):
                        # curr_node.update_parent({tuple(new_state): closed[new_state]})
                        parent[tuple(curr_node.state)] = tuple(new_state)
                        curr_node.g = closed[tuple(new_state)] + gstar(new_state,curr_node.state)
                        curr_node.update_cost()

    return ([],mr)


def astar_h1(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int
) -> Tuple[List[list], bool]:  # 28 marks
    """
    Graded
    Implement A* with h1 heuristic.
    This function must return path obtained and a boolean which says if the heuristic chosen satisfes Monotone restriction property while exploring or not.
    """
    return astar(init_state,final_state,max_missionaries,max_cannibals,h1,True) # is Monotone
    
    # raise ValueError("astar_h1 not implemented")


def astar_h2(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int
) -> Tuple[List[list], bool]:  # 8 marks
    """
    Graded
    Implement A* with h2 heuristic.
    """
    return astar(init_state,final_state,max_missionaries,max_cannibals,h2,True)
    # raise ValueError("astar_h2 not implemented")


def astar_h3(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int
) -> Tuple[List[list], bool]:  # 8 marks
    """
    Graded
    Implement A* with h3 heuristic.
    """
    return astar(init_state,final_state,max_missionaries,max_cannibals,h3,True)
    # raise ValueError("astar_h3 not implemented")

def astar_h4(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int
) -> Tuple[List[list], bool]:  # 8 marks
    """
    Graded
    Implement A* with h4 heuristic.
    """
    return astar(init_state,final_state,max_missionaries,max_cannibals,h4,False)
    # raise ValueError("astar_h4 not implemented")


def astar_h5(
    init_state: list, final_state: list, max_missionaries: int, max_cannibals: int
) -> Tuple[List[list], bool]:  # 8 marks
    """
    Graded
    Implement A* with h5 heuristic.
    """
    return astar(init_state,final_state,max_missionaries,max_cannibals,h5,False)
    # raise ValueError("astar_h5 not implemented")


def print_solution(solution: List[list],max_mis,max_can):
    """
    Prints the solution path. 
    """
    if not solution:
        print("No solution exists for the given parameters.")
        return
        
    print("\nSolution found! Number of steps:", len(solution) - 1)
    print("\nLeft Bank" + " "*20 + "Right Bank")
    print("-" * 50)
    
    for state in solution:
        if state[-1]:
            boat_display = "(B) " + " "*15
        else:
            boat_display = " "*15 + "(B) "
            
        print(f"M: {state[0]}, C: {state[1]}  {boat_display}" 
              f"M: {max_mis-state[0]}, C: {max_can-state[1]}")


def print_mon(ism: bool):
    """
    Prints if the heuristic function is monotone or not.
    """
    if ism:
        print("-" * 10)
        print("|Monotone|")
        print("-" * 10)
    else:
        print("-" * 14)
        print("|Not Monotone|")
        print("-" * 14)


def main():
    # try:
        testcases = [{"m": 3, "c": 3}]

        for case in testcases:
            max_missionaries = case["m"]
            max_cannibals = case["c"]
            
            init_state = [max_missionaries, max_cannibals, 1] #initial state 
            final_state = [0, 0, 0] # final state
            
            if not check_valid(init_state, max_missionaries, max_cannibals):
                print(f"Invalid initial state for case: {case}")
                continue
                
            path_h1,ism1 = astar_h1(init_state, final_state, max_missionaries, max_cannibals)
            path_h2,ism2 = astar_h2(init_state, final_state, max_missionaries, max_cannibals)
            path_h3,ism3 = astar_h3(init_state, final_state, max_missionaries, max_cannibals)
            path_h4,ism4 = astar_h4(init_state, final_state, max_missionaries, max_cannibals)
            path_h5,ism5 = astar_h5(init_state, final_state, max_missionaries, max_cannibals)
            print_solution(path_h1,max_missionaries,max_cannibals)
            print_mon(ism1)
            print("-"*50)
            print_solution(path_h2,max_missionaries,max_cannibals)
            print_mon(ism2)
            print("-"*50)
            print_solution(path_h3,max_missionaries,max_cannibals)
            print_mon(ism3)
            print("-"*50)
            print_solution(path_h4,max_missionaries,max_cannibals)
            print_mon(ism4)
            print("-"*50)
            print_solution(path_h5,max_missionaries,max_cannibals)
            print_mon(ism5)
            print("="*50)

    # except KeyError as e:
    #     print(f"Missing required key in test case: {e}")
    # except Exception as e:
    #     print(f"An error occurred: {e}")


if __name__ == "__main__":
    main()
