
# Automated Infrastructure Provisioning and Deployment

This project showcases automated infrastructure provisioning and deployment workflow of my personal website [Aravind.live](https://www.aravind.live/) using CI/CD principles. Leveraging GitHub Actions as the CI/CD pipeline, the project seamlessly integrates with AWS and utilizes Terraform for infrastructure provisioning, Docker for containerization, and AWS for hosting.


## Architecture

![CI_CD_Archiecture](https://github.com/aravind1314/cloud-resume/blob/main/CI_CD_Archiecture.png?raw=true)


## Tech Stack

**Website:** Html, Css, Js, Node.js, Express

**CI/CD:** Github Actions

**Cloud platform:** AWS

**Infrastructure as code:** Terraform

**Containerization:** Docker

**Web server:** Nginx

**SSL:** Certbot

## Workflow

With each push to the code repository, the CI/CD pipeline is triggered. 

- Initiating the provisioning of infrastructure resources on AWS using Terraform, ensuring consistent and reproducible deployments. 

- The website, which is Dockerized, is then pushed to Docker Hub for easy access and version management.

- Once the infrastructure is provisioned, the project deploys the Dockerized website onto EC2 instances, providing a scalable and reliable hosting environment. 

By automating the entire process, this project eliminates manual intervention . It empowers developers to focus on writing code while seamlessly deploying and managing their applications on AWS using modern CI/CD practices.



### Website

Frontend of the website is based on a free template available at [Themewagon](https://themewagon.com/themes/best-quality-free-portfolio-resume-bootstrap-template-download-profile/)  , it has been modified to match the project requirements . Node.js with Express is used to serve the webpage at port 3000.

Run the website locally

```bash
cd app

node server.js
```

Acess the website locally

```
localhost:3000/
```

### CI / CD

New workflow is created in Github Actions to implement CI/CD for this project. The workflow is triggered with every push to the code repository.

Push code to the Remote repository from local repository
```bash
git add .

git commit -m "message"

git push
```
Successful workflow runs indicate that the deployment is completed successfully.

### Infrastructure as code

Terraform is used to automate the provisioning of Infrastructure. Github provides Actions to setup and execute Terraform .

example

```
  - name: Setup Terraform
    env:
     AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
     AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    uses: hashicorp/setup-terraform@v2
    with:
      terraform_wrapper: false

```

**Steps**

- **Terraform Setup:** The necessary environment variables, AWS access key, and secret access key are set. The hashicorp/setup-terraform action is used to install Terraform without the wrapper script.
- **Terraform Init:** The Terraform is initialized by running terraform init inside the ./terraform directory.
- **Terraform Apply:** The workflow applies the Terraform configuration and provisions the required infrastructure resources on AWS. The -auto-approve flag is used for a non-interactive deployment.
- **Set IP:** The Elastic IP associated with the public IP of provisioned EC2 instance is obtained and stored as an environment variable. This variable can be utilized at a later stage to access the EC2 instance..

Resources created in AWS using Terraform

- VPC
- subnet
- Route table
- Internet gateway
- Security group
- Elastic Ip 
- EC2 Instance

Terraform state file is stored remotely in S3 bucket for better state management .

## Containerization

Docker is used to containerize the website.

**Steps**
- **Build & Push Docker Image:** The Docker image for the website is built using the mr-smithers-excellent/docker-build-push action. The image is built using the Dockerfile and then pushed to Docker Hub registry. The Docker Hub credentials are fetched from the GitHub Secrets.

**Intermediate steps before deployment** 
- **Check if File Exists:** An SSH connection is made to the EC2 instance using the retrieved public EIP. The workflow checks if a docker-compose.yaml file exists on the server.
- **Remove Existing Files:** If the docker-compose.yaml file exists, the workflow removes any existing Docker containers, images, and the file itself on the EC2 instance.
- **Copy Docker Compose file via SSH:** The docker-compose.yaml file is copied from the repository to the EC2 instance using the appleboy/scp-action action.
- **Copy Script Commands file via SSH:** The script-cmnds.sh file, containing necessary commands for deploying the Docker image, is copied to the EC2 instance.

## Deployment

- **Deploy Docker Image to EC2:** The Docker image is deployed to the EC2 instance by executing the script-cmnds.sh file. This includes setting the execution permissions, logging in to Docker Hub using the provided credentials, and running the necessary Docker commands. 

```
  - name: Deploy Docker Image to EC2
    env:
     IMAGE_TAG: ${{ github.sha }}
    uses: appleboy/ssh-action@master
    with:
      host: ${{ env.SERVER_PUBLIC_EIP }}
      username: ubuntu
      key: ${{ secrets.KEY }}
      script: |
       sudo chmod +x script-cmnds.sh

       echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin

       sudo bash script-cmnds.sh
```

## Configuring Web server

SSH in to EC2 instance

```
ssh -i (priv-key) ubuntu@EIP
```
Check if the container is running on host port 3000

```
Docker ps
```
Acess website

```
http://EIP:3000
```
**DNS**

AWS Route 53 is used to associate the Domain [Aravind.live](https://www.aravind.live/) to EIP  


**Install Nginx**
 
 Nginx is used as a reverse proxy for the container running on port 3000 .

 ```
 sudo apt update

 sudo apt install nginx 

 ```
 check if nginx is running

 ```
 sudo systemctl status nginx

```

**Configure Nginx**

Edit /etc/nginx/sites-available/default to configure the reverse proxy

```
server {
    listen 80;
    server_name aravind.live www.aravind.live;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

```

Access website

```
http://aravind.live

```

**SSL**

certbot is used to secure the website

install certbot

```
sudo snap install --classic certbot

sudo ln -s /snap/bin/certbot /usr/bin/certbot

```

check installation

```
sudo certbot --version

```

install certificates 

```
sudo certbot --nginx

```

Access website

```
https://Aravind.live

```



