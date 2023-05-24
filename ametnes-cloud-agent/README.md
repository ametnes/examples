# Setting up an Ametnes Data Services Location

## Creating resources
1. Create an kubernetes cluster.

    EKS
    ```
    export KUBECONFIG=~/.kube/ametnes-data-location-1-24
    eksctl create cluster -f eks-1-24.yml
    ```

    GKE
    ```
    SERVICE_ACCOUNT="<service-user-name>@<your-gcp-project>.iam.gserviceaccount.com"
    gcloud container get-server-config --flatten="channels" --filter="channels.channel=RAPID"  --format="yaml(channels.channel,channels.validVersions)"
    gcloud container clusters create ametnes-data-service-location-usc1 --machine-type e2-standard-4 --zone us-central1-a --spot --cluster-version=1.21.14-gke.15800 --service-account $SERVICE_ACCOUNT --no-user-output-enabled
    ```


    AZURE
    ```
    az group create --name ametnes-data-location --location eastus
    
    az aks create -g ametnes-data-location -n ametnes-az-use-dsl1 --enable-managed-identity --node-count 1 --enable-addons monitoring --enable-msi-auth-for-monitoring
    az aks get-credentials --resource-group ametnes-data-location --name ametnes-az-use-dsl1
    kubectl patch storageclass azurefile -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    kubectl patch default azurefile -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
    ```

2. Add the helm repository.
    ```
    helm repo add ametnes https://ametnes.github.io/helm && helm repo update
    ```
3. Generate a UUID on your command line.
    ```
    $ uuidgen
    > 26F522B3-E412-44D0-9992-F47F03F3192B
    ```
4. Install the Ametnes Cloud Agent.
    ```
    helm upgrade --install --create-namespace --namespace ametnes-system ametnes-cloud-agent ametnes/cloud-agent --set agent.config.location=26F522B3-E412-44D0-9992-F47F03F3192B
    ```
5. In your Ametnes Cloud account, create a Data Service Location with a **_User Supplied Id_**: `26F522B3-E412-44D0-9992-F47F03F3192B`
6. Create a network access resource in your Data Service Location.
7. Create services attached to the network access resource.


## Cleaning up resources
1. Delete the services you created in 7. above.
2. Delete the network resource created in 6. above.
3. Delete the kubernetes cluster with.

    EKS
    ```
    eksctl delete cluster -f eks-1-24.yml --disable-nodegroup-eviction
    ```

    GCP
    ```
    gcloud container clusters delete ametnes-data-service-location-usc1 --zone us-central1-a
    ```

    AKS
    ```
    az aks delete -g ametnes-data-location -n ametnes-az-use-dsl1
    ```
