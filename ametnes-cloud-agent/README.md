# Setting up an Ametnes Data Services Location

1. In your Ametnes Cloud account, create a Service Location and note the Location Id e.g. `8ea8b9823`
2. Create an EKS kubernetes cluster.
    ```
    export KUBECONFIG=~/.kube/ametnes-data-location-1-24
    eksctl create cluster -f eks-1-24.yml
    ```
3. Install the Ametnes Cloud Agent
    ```
    helm repo add ametnes https://ametnes.github.io/helm && helm repo update
    helm upgrade --install --create-namespace --namespace ametnes-system --set agent.config.location=8ea8b9823 ametnes-cloud-agent ametnes/cloud-agent
    ```
4. Create a network access resource
5. Create services attached to the network access resource
