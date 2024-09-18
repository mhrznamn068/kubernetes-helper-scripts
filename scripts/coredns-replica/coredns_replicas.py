import math

def calculate_coredns_replicas(cores, coresPerReplica, nodes, nodesPerReplica):
    replicas_based_on_cores = math.ceil(cores / coresPerReplica)
    replicas_based_on_nodes = math.ceil(nodes / nodesPerReplica)

    replicas = max(replicas_based_on_cores, replicas_based_on_nodes)
    return replicas

cores = int(input("Enter the total number of cores: "))
coresPerReplica = int(input("Enter the desired cores per replica: "))
nodes = int(input("Enter the total number of nodes: "))
nodesPerReplica = int(input("Enter the desired nodes per replica: "))

replicas = calculate_coredns_replicas(cores, coresPerReplica, nodes, nodesPerReplica)
print(f"Desired CoreDNS replicas is {replicas}")
