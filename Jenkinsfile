def gv
pipeline {
    agent any
    environment {
        REPO_URL="tma1314/docker-hub-repo"
        IMAGE_TAG="$BUILD_NUMBER"
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv= load "script.groovy"
                }
            }
        }
        stage("provision-server") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
                TF_VAR_env_prefix ='cloud-resume'
            }
            steps {
                script {
                    gv.provisionServer()
                }
            }
        }
        stage("buildImage") {
            steps {
                script {
                    gv.buildImage()
                }
            }
        }
        stage("pushImage") {
            steps {
                script {
                    gv.pushImage()
                }
            }
        }
        stage("deploy") {
            environment {
                DOCKER_CREDS=credentials('dockerhub-cred')
            }
            steps {
                script {
                    gv.deploy()
                }
            }
        }
    }
}

