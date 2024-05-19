pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                //git branch: 'main', url: 'https://github.com/gurd1t/terraform-jenkins-eks.git'
                echo 'Done through Git SCM..'
            }
        }
      
        stage('Initializing Terraform') {
            steps {
                sh 'cd eks && terraform init'
            }
        }
      
        stage('Validating Terraform') {
            steps{
                sh 'cd eks && terraform validate'
            }
        }
      
        stage('Creating/Destroying EKS Cluster') {
            steps{
                sh 'cd eks && terraform $action --auto-approve'
            }
        }
      
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('eks') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}
