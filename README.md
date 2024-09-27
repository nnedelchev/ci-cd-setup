# ci-cd-setup
Repo containing the test cicd setup
Please, read the entire describtion to understand what and how it is done (make any changes you require).

## To run everything just execute  auto_deploy.sh, otherwise follow the steps below

./ci-cd-setup/auto_deploy.sh



### Deploy Kind cluster with ArgoCD set on it
terraform apply -auto-approve
sleep 120 && kubectl apply -f argocd_ingress.yaml

### Change the password of the Jenkins admin user into "argocd-jenkins-app.yaml" if needed -> value: "admin123"
### Deploy Jenkins
sleep 20 && kubectl apply -f ./apps/jenkins/argocd-jenkins-app.yaml

### Forward the port used by Jenkins to expose the service on port 32222
sleep 80 && kubectl port-forward port-forward svc/jenkins -n jenkins 32222:8080 > /dev/null 2>&1 &

### Get initial ArgoCD password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


### Services are available here:

### Jenkins http://localhost/32222
### ArgoCD  https://localhost/
