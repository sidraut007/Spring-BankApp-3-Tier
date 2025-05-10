# Spring-BankApp
## End-to-End Bank Application Deployment using DevSecOps on AWS EKS
- This is a multi-tier bank an application written in Java (Springboot).

![Login diagram](images/login.png)
![Transactions diagram](images/transactions.png)

### PRE-REQUISITES FOR THIS PROJECT:
- AWS Account
- AWS Ubuntu EC2 instance (t2.medium)
- Install Docker
- Install docker compose
#
### DEPLOYMENT:
| Deployments    | Paths |
| -------- | ------- |
| Deployment using Docker and Networking | <a href="#Docker">Click me </a>     |
| Deployment using Docker Compose | <a href="#dockercompose">Click me </a>     |
| Deployment using Kubernetes | <a href="#kubernetes">Click me </a>     |

#
### STEPS TO IMPLEMENT THE PROJECT
- **<p id="Docker">Deployment using Docker</p>**
  - Clone the repository
  ```bash
  git clone 
  ```
  #
  - Install docker, docker compose and provide neccessary permission
  ```bash
  sudo apt update -y

  sudo apt install docker.io docker-compose-v2 -y

  sudo usermod -aG docker $USER && newgrp docker
  ``` 
  #
  - Move to the cloned repository
  ```bash
  cd Springboot-BankApp
  ```
  #
  - Build the Dockerfile
  ```bash
  docker build -t sidraut007/spring-bankapp .
  ```
> [!Important]
> Make sure to change docker build command with your DockerHub username.
  #
  - Create a docker network
  ```bash
  docker network create bankapp
  ```
  #
  - Run MYSQL container
  ```bash
  docker run -itd --name mysql -e MYSQL_ROOT_PASSWORD=Test@123 -e MYSQL_DATABASE=BankDB --network=bankapp mysql:8.0
  ```
  #
  - Run Application container
  ```bash
  docker run -itd --name BankApp -e SPRING_DATASOURCE_USERNAME="root" -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql:3306/BankDB?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC" -e SPRING_DATASOURCE_PASSWORD="Test@123" --network=bankapp -p 8080:8080 sidraut007/spring-bankapp
  ```
  #
  - Verify deployment
  ```bash
  docker ps
  ```
  # 
  - Open port 8080 of your AWS instance and access your application
  ```bash
  http://<public-ip>:8080
  ```
  ### Congratulations, you have deployed the application using Docker 
  #
- **<p id="dockercompose">Deployment using Docker compose</p>**
 Install docker compose
```bash
sudo apt update
sudo apt install docker-compose-v2 -y
```
#
- Run docker-compose file present in the root directory of a project
```bash
docker compose up -d
```
#
- Access it on port 8080
```bash
  http://<public-ip>:8080
```
> [!Important]
> If you face issues with exiting docker container while running docker compose, run ``` docker compose down``` and then ``` docker compose up -d ```.
#

- **<p id="kubernetes">Deployment using kubernetes</p>**
  
  Move to the K8s/manifest
  ```bash
  cd Spring-BankApp-3-Tier/K8s/manifest
  ```

- Deploy PV & PVC

```bash
k apply -f pv.yaml

k apply -f pvc.yaml
```

- Deploy MYSQL Backend

```bash
kubectl apply -f mysql-secret.yaml

kubectl apply -f mysql-config.yaml

kubectl apply -f mysql-statefulset.yaml

kubectl apply -f mysql-service.yaml
```

- Deploy bankapp deployment

```bash
kubectl apply -f bankapp-secret.yaml

kubectl apply -f bankapp-config.yaml

kubectl apply -f bankapp-service.yaml

kubectl apply -f bankapp-deploy.yaml
```

## HOW TO ACCESS OVER INTERNET

### If you are using Laptop

- This steps is required only who are using everything on laptop

```bash
  kubectl get svc
  kubectl port-forward svc/bankapp-service 8080:80
```

 - http://localhost:8080


