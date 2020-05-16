terraform apply --auto-approve
aws eks --region us-east-2 update-kubeconfig --name alexf-k8s-cluster

cd kubernetes
./deploy.sh
cd -
