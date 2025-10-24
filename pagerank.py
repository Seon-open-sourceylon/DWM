# Simple Implementation of PageRank Algorithm 
def page_rank(graph, d=0.85, num_iterations=100): 
    """ 
    graph: dictionary where keys are nodes and values are list of outgoing links 
    d: damping factor (default 0.85) 
    num_iterations: number of iterations to run 
    """ 
    N = len(graph)  # number of nodes 
    ranks = {node: 1 / N for node in graph}  # initial equal rank 
    
    for _ in range(num_iterations): 
        new_ranks = {} 
        for node in graph: 
            # base rank from random jump 
            new_rank = (1 - d) / N   
            
            # add rank contributions from inbound links 
            for other_node in graph: 
                if node in graph[other_node]:  # if link exists
                    new_rank += d * (ranks[other_node] / len(graph[other_node])) 
            
            new_ranks[node] = new_rank 
        ranks = new_ranks 
    
    return ranks 
 
 
# Example Graph (Directed) 
graph = { 
    "A": ["B", "C"], 
    "B": ["C"], 
    "C": ["A"], 
    "D": ["C"] 
} 
 
print("Graph:", graph) 
 
# Run PageRank 
ranks = page_rank(graph, num_iterations=20) 
 
print("\nFinal PageRank Scores:")
for page, score in ranks.items(): 
    print(f"{page}: {score:.4f}") 