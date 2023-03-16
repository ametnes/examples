# Setting up an Ametnes Data Services Location

## Creating resources
1. In your Ametnes Cloud account, create a Service Location and note the Location Id e.g. `8ea8b9823`
2. Create an kubernetes cluster.
    EKS
    ```
    export KUBECONFIG=~/.kube/ametnes-data-location-1-24
    eksctl create cluster -f eks-1-24.yml
    ```

    GKE
    ```
    SERVICE_ACCOUNT="<service-user-name>@<your-gcp-project>.iam.gserviceaccount.com"
    gcloud container clusters create ametnes-data-service-location-usc1 --machine-type e2-standard-4 --zone us-central1-a --spot --cluster-version=1.21.14-gke.15800 --service-account $SERVICE_ACCOUNT
    ```
3. Add the helm repository
    ```
    helm repo add ametnes https://ametnes.github.io/helm && helm repo update
    ```
4. Install the Ametnes Cloud Agent
    ```
    helm upgrade --install --create-namespace --namespace ametnes-system --set agent.config.location=8ea8b9823 ametnes-cloud-agent ametnes/cloud-agent
    ```
5. Create a network access resource
6. Create services attached to the network access resource


## Cleaning up resources
1. Delete the services you created in 5. above
2. Delete the network resource created in 4. above
3. Delete the EKS cluster with 
    ```
    eksctl delete cluster -f eks-1-24.yml --disable-nodegroup-eviction
    ```

    ```
    gcloud container clusters delete ametnes-data-service-location-usc1 --zone us-central1-a
    ```
