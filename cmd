to coment all at once: "press CTRL /"

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# spin up an Ubuntu 18.04 server attach an IAM role with EC2 full access and administrator access and S.G open all port

####  Create IAM Role
Goto IAM, select Role, create role, select aws Sevice, for use cace select EC2 next add permission select Adminstrator Access
Name = Jenkins-cicd-Admin-Role, then create.
Now attache this role to Jenkins server
Select the running Jenkins server, click on action, click on security and modify IAM role, select the the role created from the dropdown and update.

# log in to the server 

# install unzip file
sudo apt install unzip 

# install aws CLI 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# check the aws version
aws --version

# make .aws directory to store user credentials
mkdir .aws 

# create a file for credential and vi into the file 
vi ~/.aws/credentials 

# paste a user credentials 
[kubernetes-Admin]
aws_access_key_id=XXXXXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXXXXXXXXXXX
region=us-east-1
output=json
#Escape and save
Esc & type :wq!  or the short cut is to hold down the SHIFT and press Z twice.

# run this cmd to download the eks cli utility
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

#move to bin
sudo mv /tmp/eksctl /usr/local/bin

# check the version
eksctl version

sudo apt-get update

# The code is used to install the "apt-transport-https" package on a system running the Debian-based operating 
# system using the APT package manager. The "sudo" command is used to run the command with administrative privileges, 
# and the "-y" option tells the APT package manager to assume yes and silently install the package without asking for 
# confirmation. The "apt-transport-https" package allows APT to securely download packages over HTTPS, providing an 
# encrypted connection to the package repository and ensuring the authenticity of the packages being installed.

sudo apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo touch /etc/apt/sources.list.d/kubernetes.list


#adding it to the list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# update again
sudo apt-get update -y

# install kubectl 
sudo apt-get install -y kubectl

# check the version 
kubectl version --short --client

# run kubectl to see if it's working
kubectl 

# copy the content of the yaml file "eks-cluster-setup.yaml"
mkdir workspace # in the terminalcreate the worspace and cd into it
cd workspace/
vi eks-cluster-setup.yaml    # paste the content of the copied file (eks-cluster-setup.yaml) inside the workspace/

cat eks-cluster-setup.yaml # to check the content copied

# create the cluster <eksctl create cluster -f cluster.yamlNAME>
eksctl create cluster -f eks-cluster-setup.yaml

# to see the workers nodes
kubectl get node 

#to see the cluster
eksctl get cluster --region us-east-2

 # describe the cluster, i.e details of the cluster <aws eks --region us-west-2 describe-cluster --name>
aws eks --region us-east-2 describe-cluster --name capital-express-cluster

# to get info abt the node group that are part of the cluster <eksctl get nodegroup --region us-east-2 --cluster CLUSTER_NAME>
eksctl get nodegroup --region us-east-2 --cluster capital-express-cluster

# cd out of the workspace and clone the voting-app

Day-2 #       create a ropsitory voting-web-app, clone it to both local and in the VM, download the codes from mbadi repo, 
#             escract, copy and paste it in the local repo.
# push it to your github repo. then pull it from you VM.
#  cd into the voting-app repository

   37  kubectl get node
   38  git clone https://github.com/olusegun45/voting-web-app.git
   39  git pull https://github.com/olusegun45/voting-web-app.git
   40  ls
   41  cd voting-web-app/
   42  git pull https://github.com/olusegun45/voting-web-app.git
   43  cd ..

# to get all resources runing within the cluster
        kubectl api-resources

# to get the specific configmap, show the user that have access to this cluster
    kubectl -n kube-system get cm
####   ubuntu@ip-172-31-11-197:~$ kubectl -n kube-system get cm
NAME                                 DATA   AGE
aws-auth                             2      22h
coredns                              1      22h
cp-vpc-resource-controller           0      22h
eks-certificates-controller          0      22h
extension-apiserver-authentication   6      22h
kube-proxy                           1      22h
kube-proxy-config                    1      22h
kube-root-ca.crt                     1      22h

#to display the specific configmap to define any aws identity, e.g Developer user and Kubernetes admin
kubectl -n kube-system get configmap aws-auth -o yaml  # this in yaml format
# result #  ubuntu@ip-172-31-11-197:~$ kubectl -n kube-system get configmap aws-auth -o yaml
#  or 
kubectl -n kube-system get configmap aws-auth -o json     # this in json format
# result #   ubuntu@ip-172-31-11-197:~$ kubectl -n kube-system get configmap aws-auth -o json

#   Run this comand outside of the cloned repository i.e cd out of the cloned repo voting-app:
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml


apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::875625576218:role/eksctl-capital-express-cluster-no-NodeInstanceRole-UJBVCF6Z27PA
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |           
    []                              # ~> map user is empty this is for yaml, we need to make use of it.
kind: ConfigMap
metadata:
  creationTimestamp: "2022-12-09T02:53:37Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "2111"
  uid: 92c76b09-6cdd-4d6d-ba44-04f8836bb475

#  or 
kubectl -n kube-system get configmap aws-auth -o json
# result #   ubuntu@ip-172-31-11-197:~$ kubectl -n kube-system get configmap aws-auth -o json
{
    "apiVersion": "v1",
    "data": {
        "mapRoles": "- groups:\n  - system:bootstrappers\n  - system:nodes\n  rolearn: arn:aws:iam::875625576218:role/eksctl-capital-express-cluster-no-NodeInstanceRole-UJBVCF6Z27PA\n  username: system:node:{{EC2PrivateDNSName}}\n",
        "mapUsers": "[]\n"        # ~> map user is empty this is for jason, we need to make use of it.
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-12-09T02:53:37Z",
        "name": "aws-auth",
        "namespace": "kube-system",
        "resourceVersion": "2111",
        "uid": "92c76b09-6cdd-4d6d-ba44-04f8836bb475"
    }
}


 # do pwd to know where you are, you should be at the /home/ubuntu

 # vi into the file aws-auth-configmap.yaml 
        vi aws-auth-configmap.yaml 

#  to add the user to user kubernetes
- userarn: arn:aws:iam::875625576218:user/kubernetes-Admin
    username: kubernetes-Admin
    groups:
      - system:masters

# now to apply the config
kubectl apply -f aws-auth-configmap.yaml -n kube-system

kubectl -n kube-system get cm aws-auth

kubectl -n kube-system describe cm aws-auth

vi .aws/credentials
# edit to 
[kubernetes-Admin]
aws_access_key_id=XXXXXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
region=us-east-1
output=json

# aws s3 ls

# aws s3 ls --profile kubernetes-Admin        ----> this will not work because the user kubernetes-user has 
#                                                   not been granted access priviledge

# aws sts get-caller-identity                ~> this will tell the specific user or call id currently in use, 
#                                               this can be switch to the kubernetes user.


# export AWS_PROFILE="your_admin_name"        ~ > this is use to switch user.
export AWS_PROFILE="kubernetes-Admin"

ubuntu@ip-172-31-11-197:~$ aws s3 ls
2022-10-06 01:21:57 cf-templates-1hje4e3dplrzh-us-east-1
2022-09-29 03:16:06 cf-templates-1hje4e3dplrzh-us-east-2
2022-09-15 14:42:27 cf-templates-1hje4e3dplrzh-us-west-2
2022-10-20 00:49:50 ventura-cloudformation-nested-stack-94765
ubuntu@ip-172-31-11-197:~$ aws s3 ls --profile kubernetes-Admin



### thursday -15
# to change the caller id to point to the custome user name
export AWS_PROFILE="kubernetes-Admin"

# to confirm it is now pointing to the kubernetes-Admin
aws sts get-caller-identity

# cd into voting-web-app/
cd voting-web-app/

# do ls and voting-app-deployment.yml
voting-app-deployment.yml
#    result:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: voting-app-deployment
  labels:
    app: demo-voting-app
spec:
  replicas: 3
  selector:
    matchLabels:
      name: voting-app-pod
      app: demo-voting-app
  template:
    metadata:
      name: voting-app-pod
      labels:
        name: voting-app-pod
        app: demo-voting-app

    spec:
      containers:
      - name: voting-app
        image: kodekloud/examplevotingapp_vote:v1
        ports:
        - containerPort: 80

# cd out of the votting-app and create a name space production, and the developer access to see but not to make any change in that environmrnt
kubectl create namespace production

  ubuntu@ip-172-31-11-197:~$ kubectl create namespace production
  namespace/production created

# to see all the name space 
kubectl get name space or kubectl get ns

# ubuntu@ip-172-31-11-197:~$ kubectl get ns
# NAME              STATUS   AGE
# default           Active   6d22h
# kube-node-lease   Active   6d22h
# kube-public       Active   6d22h
# kube-system       Active   6d22h
# production        Active   76s

# create an nginx container or pod  in the prod name space
kubectl run nginx --image=nginx -n production
# if we did not provide the name of the name space production, it will deploy it in the default name space  (-n)
# to get the pod in a particular name space e.g production
kubectl get pod -n production

# To define the developer-user (Role binding is a fine grain access)
# Let create a role 
vi role.yaml
### copy this and paste it
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: production
  name: prod-viewer-role
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]  # can be further limited, e.g. ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch"]

#confirm by cat role.yaml

 kubectl apply -f role.yaml

#to create a role binding for developer-user to access a specific resouce wich is production name space
vi rolebinding.yaml
### copy this and paste it
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: prod-viewer-binding
  namespace: production
subjects:
- kind: User
  name: Developer-user
  apiGroup: ""
roleRef:
  kind: Role
  name: prod-viewer-role
  apiGroup: ""

#apply it
kubectl apply -f rolebinding.yaml

# ubuntu@ip-172-31-11-197:~$ kubectl apply -f role.yaml
# role.rbac.authorization.k8s.io/prod-viewer-role created
# ubuntu@ip-172-31-11-197:~$ kubectl apply -f rolebinding.yaml
# rolebinding.rbac.authorization.k8s.io/prod-viewer-binding created

# Run this comand to create a file on the flight
  kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
  # do ls

# vi into aws-auth-configmap.yaml
vi aws-auth-configmap.yaml


- userarn: arn:aws:iam::875625576218:user/Developer-user
      username: Developer-user
      groups:
        - prod-viewer-role

# Now apply the change to the configmap i.g with the addition of the new user
kubectl apply -f aws-auth-configmap.yaml

#  Adding the new user credentials (Developer-user)
vi ~/.aws/credentials

[Developer-user]
aws_access_key_id=XXXXXXXXXXXXXX
aws_secret_access_key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
region=us-east-1
output=json

# switch the profile from Kubernetes-admin to Developer-user
export AWS_PROFILE="Developer-user"

#get the caller id
aws sts get-caller-identity

#after this run the kubectl get node, the developer should not be able to get the nodes but if we run kubectl get pod, it will only be able to get the pod within the name space it was binded to.
# if we did not specify name space it will go to the default name space.
kubectl get node    #  -> it will give Error
kubctl get pod     # -> it will give Error
kubctl get pod  -n production    # -> it will give nginx since it was binded to production name space


#clone this repo 
https://github.com/awanmbandi/Containerization-Microservices-Projects.git

# Checkout
git checkout k8s-nginx-web-app
# do ls
cat nginx-pod.yaml 

# do ls, if you are not inside the containirazation-microserces-project, cd into it, then cd into pod-manifesr
# then Run: if you can't find the configmap, exit and log back in and run this comand
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml

# then switch user to kubernetes-Admin
export AWS_PROFILE="kubernetes-Admin"

aws sts get-caller-identity

# then create the pod by running the nginx-pod.yaml file
kubectl apply -f nginx-pod.yaml

#    range of portport to selet for the node port service: https://kubernetes.io/docs/reference/networking/ports-and-protocols/
#  To map the IPs by using service, cd back to the service file
cd ../service-manifest/
# do ls
cat nginx-np-service.yaml

# from service-manifest cat into  ../pod-manifest/nginx-pod.yaml and compare the label with the selector :nginx-app
cat ../pod-manifest/nginx-pod.yaml

#  since the label match the run:
kubectl apply -f nginx-np-service.yaml 

kubectl get svc 
# NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
# kubernetes                   ClusterIP   10.100.0.1       <none>        443/TCP        4h6m
# myapp-pod-nodeport-service   NodePort    10.100.247.198   <none>        80:31231/TCP   89s

# link for node port service range : https://kubernetes.io/docs/reference/networking/ports-and-protocols
Next go to the SG of any of the Node and edit it, provide a fine gine for node pod service ip (30000-32767)
go to ur browser with the pub ip:30000-32767 and you get access to the website running in the pod 

# to run the next one replica srt delete the pod that running
kubectl delete pod my-nginx-app

# go to replicaset
cd ../replicaset-manifest/
# do ls
# then cat nginx-replicaset.yaml and compare label to the nginx-pod.yaml in ur pod manifest (cat ../pod-manifest/nginx-pod.yaml)
    pod-manifest                               replicaset-manifest 
labels: # Dictionary                           labels:
    app: nginx-app                                app: nginx-app
#  Since it's the same the run this comand :
kubectl apply -f nginx-replicaset.yaml

kubectl get pod
# NAME                 READY   STATUS    RESTARTS   AGE
# my-nginx-app-444ph   1/1     Running   0          42s
# my-nginx-app-mbkwd   1/1     Running   0          42s
# my-nginx-app-xclb2   1/1     Running   0          42s

kubectl delete pod my-nginx-app-444ph

kubectl get pod
# NAME                 READY   STATUS    RESTARTS   AGE
# my-nginx-app-4jck7   1/1     Running   0          8s
# my-nginx-app-mbkwd   1/1     Running   0          95s
# my-nginx-app-xclb2   1/1     Running   0          95s

# to delete the cluster
eksctl delete cluster --name capital-express-cluster --region us-east-2


HISTORY

ubuntu@ip-172-31-25-68:~/Containerization-Microservices-Projects/replicaset-manifest$ history
    1  clear
    2  sudo apt install unzip
    3  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    4  unzip awscliv2.zip
    5  sudo ./aws/install
    6  mkdir .aws
    7  vi ~/.aws/credentials
    8  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    9  sudo mv /tmp/eksctl /usr/local/bin
   10  eksctl version
   11  sudo apt-get update
   12  sudo apt-get install -y apt-transport-https
   13  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
   14  sudo touch /etc/apt/sources.list.d/kubernetes.list
   15  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
   16  sudo apt-get update -y
   17  sudo apt-get install -y kubectl
   18  mkdir workspace
   19  cd workspace/
   20  vi eks-cluster-setup.yaml
   21  eksctl create cluster -f eks-cluster-setup.yaml
   22  kubectl get node
   23  cd ..
   24  git clone https://github.com/olusegun45/voting-web-app.git
   25  cd voting-web-app/
   26  kubectl get node
   27  kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
   28  ls
   29  mv aws-auth-configmap.yaml ..
   30  cd ..
   31  ls
   32  pwd
   33  vi aws-auth-configmap.yaml
   34  cat aws-auth-configmap.yaml
   35  kubectl apply -f aws-auth-configmap.yaml -n kube-system
   36  kubectl -n kube-system get cm aws-auth
   37  kubectl -n kube-system describe cm aws-auth
   38  vi .aws/credentials
   39  aws s3 ls
   40  aws s3 ls --profile kubernetes-Admin
   41  export AWS_PROFILE="kubernetes-Admin"
   42  aws sts get-caller-identity
   43  kubectl get node
   44  ls
   45  cd voting-web-app/
   46  ls -al
   47  voting-app-deployment.yml
   48  cat voting-app-deployment.yml
   49  cd ..
   50  kubectl create namespace production
   51  kubectl get ns
   52  kubectl run nginx --image=nginx -n production
   53  kubectl get pod -n production
   54  vi role.yaml
   55  vi rolebinding.yaml
   56  kubectl apply -f role.yaml
   57  kubectl apply -f rolebinding.yaml
   58  kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
   59  ls
   60  vi aws-auth-configmap.yaml
   61  kubectl apply -f aws-auth-configmap.yaml
   62  cat aws-auth-configmap.yaml
   63  vi ~/.aws/credentials
   64  export AWS_PROFILE="Developer-user"
   65  aws sts get-caller-identity
   66  kubectl get node
   67  kubctl get pod
   68  kubctl get pod  -n production
   69  kubectl get pod -n production
   70  kubectl run nginx-dev --image=nginx -n production
   71  git clone https://github.com/awanmbandi/Containerization-Microservices-Projects.git
   72  ls
   73  cd Containerization-Microservices-Projects/
   74  ls
   75  git checkout k8-nginx-we-app
   76  git checkout k8s-nginx-web-app
   77  ls
   78  cd to pod-manifest/
   79  cd pod-manifest/
   80  ls
   81  cat nginx-pod.yaml
   82  export AWS_PROFILE="kubernetes-admin"
   83  kubectl apply -f nginx-pod.yaml
   84  aws sts get-caller-identity
   85  export AWS_PROFILE="kubernetes-admin"
   86  aws sts get-caller-identity
   87  vi aws-auth-configmap.yaml
   88  kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
   89  exit
   90  vi aws-auth-configmap.yaml
   91  ls
   92  cd Containerization-Microservices-Projects/
   93  ls
   94  cd pod-manifest/
   95  aws sts get-caller-identity
   96  export AWS_PROFILE="kubernetes-admin"
   97  kubectl apply -f nginx-pod.yaml
   98  aws sts get-caller-identity
   99  exit
  100  ls
  101  cd Containerization-Microservices-Projects/
  102  ls
  103  cd pod-manifest/
  104  aws sts get-caller-identity
  105  vi aws-auth-configmap.yaml
  106  kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
  107  vi aws-auth-configmap.yaml
  108  aws sts get-caller-identity
  109  export AWS_PROFILE="kubernetes-Admin"
  110  aws sts get-caller-identity
  111  kubectl apply -f nginx-pod.yaml
  112  kubectl get pod
  113  cd ../service-manifest/
  114  ls
  115  cat nginx-np-service.yaml
  116  cat ../pod-manifest/nginx-pod.yaml
  117  kubectl apply -f nginx-np-service.yaml
  118  kubectl get svc
  119  kubectl get pod
  120  kubectl delete pod my-nginx-app
  121  cd ../replicaset-manifest/
  122  ls
  123  cat nginx-replicaset.yaml
  124  cat ../pod-manifest/nginx-pod.yaml
  125  kubectl apply -f nginx-replicaset.yaml
  126  kubectl get pod
  127  kubectl delete pod my-nginx-app-444ph
  128  kubectl get pod
  129  clear
  130  history
  
# to delete the cluster
eksctl delete cluster --name capital-express-cluster --region us-east-2
