# Adjust Web App Deployment on Kubernetes
This repository basically helps you to deploy an App written in Ruby to recieve and serve http requests on kubernetes. We use the minukube tool to deploy and test the application. Minikube is a tool that helps us to run the kubernetes cluster on the local machine. It's a single node kubernetes cluster that helps the local development of applications and k8 objects.

# Overview
The App which is written in Ruby will create a web server that listens to a specified port and serve the requests coming to it depends on the routing added to the application. The App here is a containerized one and it would listen to the port 80 in the container, when the path http://webapp.mydomain.com is requested. Note that the URL changes depends how we expose the app to the outside world or within kubernetes itself.

# Technologies
* minikube version v1.19.0
* Helm version v3.5.4
* Docker engine version 20.10.5-ce
* ruby version 3.0.1p64
* Ansible 2.10.9

# Prerequisites
In order to run and test the App on your local machine we need the below tools installed on your local machine depends on your Operating System flavor.

1. Install VirtualBox on your local machine which is necessary for running minikube, for apple silicon machines VirtualBox is not supported at the moment and you can use docker as minikube driver. feel free to skip the steps if you are already having minikube instaleld and running. Refer the link below for VirtualBox downloads: https://www.virtualbox.org/wiki/Downloads

2. Download and install docker desktop as we are using docker environment set up to run k8s and test the application, follow the link below for the same. https://docs.docker.com/desktop/

3. Download and install the Ansible for running onestep deployment playbook. follow the link for ansible installtion https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

4. Download and install helm which is a package manager for k8s and helps to make the deployment of apps on kubernetes easy. Install helm from the below link. https://helm.sh/docs/intro/install/

# Installation
The repository contains all the necessary Dockerfile, helmcharts and Ansible playbook to make the deployment easy.The Ansible playbook is used for onestep installtion method for docker building and helm chart installation for the ruby web application. Follow the steps below to run the app on kubernetes environment powered by minikube.

1. Open the terminal and run the below command to clone the repository to the local machine.
```
git clone https://github.com/liphinstanley/Adjust.git
```
2. Install the app using the below Ansible command from /Adjust
```
ansible-playbook -i inventory playbook.yml --connection=local
```
3. Update the /etc/hosts file with the hostname webapp.mydomain.com resolving to minikube IP
   Get the minikube ip with command, 
   ```
   minikube ip
   192.168.64.3
   ```

The Ansible playbook check the minikube cluster in host machine and starts cluste if not in running state using the Virtualbox as driver.The command may change according to the flavor of your operating system. (Apple silicon machine users edit the playbook to use docker as driver as Virtualbox driver not supported now). Playbook builds a Ruby web-app docker image and deploy it to minukube cluster using helm. An Ingress object is created for the external access of the web-app using a web browser. 
The URL that the service is exposed to:
According to the app, the route hostname/healthcheck will return "OK" result and hostname/ will return "Well, hello there!" Use the command below to test the application using a curl command.
```
curl http://<host-IP-address>:nodePort/healthcheck
curl http://<host-IP-address>:nodePort/
```

The desired output is shown below,

```
❯ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
web-app-75c975b45-wvd5q   1/1     Running   0          11h

❯ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        2d15h
web-app      NodePort    10.102.167.101   <none>        80:30001/TCP   11h

❯ kubectl get ing
NAME      CLASS    HOSTS                 ADDRESS        PORTS   AGE
web-app   <none>   webapp.mydomain.com   192.168.64.3   80      4m59s
```

# Web browser output
```
http://webapp.mydomain.com/healthcheck
OK
http://webapp.mydomain.com/
Well, hello there !
```

Alternetively for apple silicoon users ingress addon will not work currently and you can use below minikube local tunne method for testing. 
```
minikube service web-app --url
🏃  Starting tunnel for service web-app.
|-----------|---------|-------------|------------------------|
| NAMESPACE |  NAME   | TARGET PORT |          URL           |
|-----------|---------|-------------|------------------------|
| default   | web-app |             | http://127.0.0.1:59653 |
|-----------|---------|-------------|------------------------|
http://127.0.0.1:59653

❯ curl http://127.0.0.1:59653/healthcheck
OK%
❯ curl http://127.0.0.1:59653/
Well, hello there!%
```

