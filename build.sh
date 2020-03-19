terraform apply --auto-approve
aws eks --region us-east-2 update-kubeconfig --name alexf-k8s-cluster

cd ~/workspace/k8-cluster/kubernetes/helm
./deploy.sh
cd -
