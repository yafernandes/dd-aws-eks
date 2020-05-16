kubectl create ns datadog

kubectl create secret generic dd --from-env-file=secrets.txt -n datadog

helm install datadog stable/datadog -f datadog-values-eks.yaml -n datadog

kubectl create ns fargate

kubectl create secret generic dd --from-env-file=secrets.txt -n fargate

kubectl apply -f rbac.yaml

kubectl apply -f app-java.yaml
