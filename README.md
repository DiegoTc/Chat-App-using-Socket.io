# Chat-App-using-Socket.io
A simple chat app using socket.io
See it in action - [Kunal Chat App](https://kunal-chat-app.herokuapp.com)
The application code is of abkunal: https://github.com/abkunal/Chat-App-using-Socket.io

## What does this project does?
This is a chat application developed by [Kunal Yadav](https://github.com/abkunal) 
You can interact with another person just providing a url, simple as that. 

## What's the difference of this project? Why a fork?
This is part of the capstone project for Udacity Cloud DevOps Nano Degree Program.
The plus that it has this project you will be able to run it using:
* NPM
* Docker
* Kubernetes
    * EKS

## How do I run it?
### Running in NPM
```
npm install
npm start
```

This will generate the a similar message:
```
> chatapp@1.0.0 start /home/diego/Documents/Proyectos/Udacity/capstone/Chat-App-using-Socket.io
> node app.js

listening on port:  5000
```

Now you can go to http://localhost:5000/

### Running in Docker
For this step it assumes you had docker installed in your workstation.
If you don't have it, please use this [link](https://docs.docker.com/install/)

For creating the image and running the container, we have a script
that helps us with this located at: `scripts/run_docker.sh`

```
./scripts/run_docker.sh
```

When the script finishes, you will find  in the logs something like this:
```
listening on port:  5000
A user connected!
```
Now you can go to http://localhost:5000/


### Kubernetes / AWS EKS

**Prerequisites**
Please be sure to have installed the following, or you will have troubles:
* aws cli
* kubectl

For configuring aws cli, please follow Amazon's Documentation: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html

Create the infrastructure in AWS

`ansible-playbook -i inventory main.yml`

Configure aws EKS

`aws eks --region us-east-1 update-kubeconfig --name eks-example`

If you're planning to run this locally and deploy it to your EKS cluster.
You will need to modify the deployment-green-template.yml

You will need to replace the `image: diegotc/chat-channel:%BUILD_NUMBER%`
with the correct name and version
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chat-blue
  labels:
    app: chat-blue
spec:
  selector:
    matchLabels:
      app: chat-blue
  template:
    metadata:
      labels:
        app: chat-blue
    spec:
      containers:
      - name: chat-blue
        image: diegotc/chat-channel:%BUILD_NUMBER%
        ports:
        - containerPort: 5000


```

Run the commands for deploying and exposing the service
```
kubectl apply -f k8/deployment-green-template.yml 
kubectl apply -f k8/service-green.yml
```

Find the IP for testing
```
kubectl get services
```

Search for the external EXTERNAL-IP

**This is part of the capstone project for the Udacity Cloud DevOps Nanodegree**

## Capstone Project Requirements
```
Steps in Completing Your Project
Step 1: Propose and Scope the Project
Plan what your pipeline will look like.
Decide which options you will include in your Continuous Integration phase.
Use Jenkins.
Pick a deployment type - either rolling deployment or blue/green deployment.
For the Docker application you can either use an application which you come up with, or use an open-source application pulled from the Internet, or if you have no idea, you can use an Nginx “Hello World, my name is (student name)” application.
Step 2: Use Jenkins, and implement blue/green or rolling deployment.
Create your Jenkins master box with either Jenkins and install the plugins you will need.
Set up your environment to which you will deploy code.
Step 3: Pick AWS Kubernetes as a Service, or build your own Kubernetes cluster.
Use Ansible or CloudFormation to build your “infrastructure”; i.e., the Kubernetes Cluster.
It should create the EC2 instances (if you are building your own), set the correct networking settings, and deploy software to these instances.
As a final step, the Kubernetes cluster will need to be initialized. The Kubernetes cluster initialization can either be done by hand, or with Ansible/Cloudformation at the student’s discretion.
Step 4: Build your pipeline
Construct your pipeline in your GitHub repository.
Set up all the steps that your pipeline will include.
Configure a deployment pipeline.
Include your Dockerfile/source code in the Git repository.
Include with your Linting step both a failed Linting screenshot and a successful Linting screenshot to show the Linter working properly.
Step 5: Test your pipeline
Perform builds on your pipeline.
Verify that your pipeline works as you designed it.
Take a screenshot of the Jenkins pipeline showing deployment and a screenshot of your AWS EC2 page showing the newly created (for blue/green) or modified (for rolling) instances. Make sure you name your instances differently between blue and green deployments.

```

**Special thanks** 
Found this article that guides you how to begin this project: https://medium.com/@andresaaap/capstone-cloud-devops-nanodegree-4493ab439d48

For managing cloudformation and ansible I found this repo which is basically what 
I used for my code infrastructure. 
https://github.com/geerlingguy/ansible-for-kubernetes/tree/master/cluster-aws-eks

For running the infraestructure you will need this command
```
ansible-playbook -i inventory main.yml
```

The idea of using ansible and kubectl came thanks to this article: 
https://www.magalix.com/blog/create-a-ci/cd-pipeline-with-kubernetes-and-jenkins

File for replacing build number: https://learnk8s.io/templating-yaml-with-code