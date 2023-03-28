pipeline {
    agent any
    parameters {
            string(name: 'resilience_score', defaultValue: '0')
        }
    environment {
           WORKFLOW_ID    = '9bd2855f-b822-464c-9906-0f9ebe824cc6'                    
    }

    stages {
        
        stage('Checkout') {
            steps {
                // Check out code from Git
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [], 
                      submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/ksatchit/hce-jenkins-integration-demo.git']]])
            }
         }
        
        stage('Deploy Carts Microservice') {
            steps {
                 sh '''
                    sh scripts/deploy-app.sh
                 '''
            }
        }

        stage('Launch Chaos Experiment') {
            steps {
                 sh '''
                    sh scripts/launch-chaos.sh
                 '''
                 
                 //sh '''
                 //   sh scripts/monitor-chaos.sh
                 //'''
                 
                 //sh '''
                 //   sh scripts/verify-rr.sh
                 //'''
            }
        }
    }
}
