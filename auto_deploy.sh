#!/bin/bash

echo "
Deploy Kind cluster and ArgoCD with terraform ..."
cd ci-cd-setup
terraform apply -auto-approve  & (sleep 180 && kubectl apply -f argocd_ingress.yaml)

# Change the password of the Jenkins admin user into "argocd-jenkins-app.yaml" if needed -> value: "admin123"
echo "
Deploing Jenkins ..."
sleep 20 && kubectl apply -f ./apps/jenkins/argocd-jenkins-app.yaml

echo "
Forwarding the port used by Jenkins to expose the service on port 32222 ..."
sleep 80 && kubectl port-forward port-forward svc/jenkins -n jenkins 32222:8080 > /dev/null 2>&1 &
echo "Done"

echo "
Getting initial ArgoCD password ... Password should be availbale below"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

echo "

Services are available and can be accessed from here:

# Jenkins http://localhost/32222
# ArgoCD  https://localhost/
"