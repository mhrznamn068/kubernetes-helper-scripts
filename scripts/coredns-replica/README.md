# CoreDNS Replica Calculator

This script calculates the desired number of CoreDNS replicas based on the number of CPU cores and nodes in a Kubernetes cluster. The calculation follows a formula that takes into account both CPU cores and node distribution.

## Formula

The script uses the following formula to calculate the required number of CoreDNS replicas:
```bash
replicas = max( ceil( cores / coresPerReplica ), ceil( nodes / nodesPerReplica ) )
```

**Where:**
- `cores`: Total number of CPU cores in the cluster.
- `coresPerReplica`: Desired number of cores per CoreDNS replica.
- `nodes`: Total number of nodes in the cluster (including master and worker nodes).
- `nodesPerReplica`: Desired number of nodes per CoreDNS replica.

## Usage

1. Clone the repository or download the script.

2. Ensure you have Python installed on your system. You can check the installation by running:

    ```bash
    python --version
    ```

3. Run the script:

    ```bash
    python coredns_replicas.py
    ```

4. You will be prompted to input the following values:
    - Total number of cores in the cluster (`cores`)
    - Desired number of cores per replica (`coresPerReplica`)
    - Total number of nodes in the cluster (`nodes`)
    - Desired number of nodes per replica (`nodesPerReplica`)

5. The script will calculate and print the desired number of CoreDNS replicas based on the input values.

## Example

Example interaction when running the script:

```bash
$ python coredns_replicas.py
Enter the total number of cores: 184
Enter the desired cores per replica: 256
Enter the total number of nodes: 23
Enter the desired nodes per replica: 6
Desired CoreDNS replicas is 2
```

### **Update the CoreDNS autoscaler ConfigMap**: Once the desired number of replicas is calculated, modify the autoscaler settings in the CoreDNS ConfigMap as follows:

```json
{
  "coresPerReplica": 256,
  "nodesPerReplica": 6,
  "preventSinglePointFailure": true,
  "min": 0,
  "max": 0,
  "includeUnschedulableNodes": false
}
```

## RKE2 Helm Configuration
To apply this configuration in an RKE2 Kubernetes cluster, create a Helm configuration to customize the autoscaler settings for CoreDNS. Use the following configuration:

```yaml
Copy code
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-coredns
  namespace: kube-system
spec:
  valuesContent: |-
    autoscaler:
      nodesPerReplica: 6
```

This will update the nodesPerReplica parameter in the CoreDNS autoscaler to ensure it is configured as required.
