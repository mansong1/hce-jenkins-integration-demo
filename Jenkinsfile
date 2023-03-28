pipeline {
    agent any
    
    environment {
            notify_id = ''
            resilience_score = ''
        }
    
    parameters {
           string(name: 'WORKFLOW_ID', defaultValue: '9bd2855f-b822-464c-9906-0f9ebe824cc6') 
           string(name: 'EXPECTED_RESILIENCE_SCORE', defaultValue: '100')
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
                    sh scripts/launch-chaos.sh > n_id.txt
                 '''
                 script {
                     //env.notify_id = sh(returnStdout: true, script: 'cat n_id.txt').trim()
                     notify_id = sh(returnStdout: true, script: 'cat n_id.txt').trim()
                 }   
            }   
        }
        
        stage('Monitor Chaos Experiment') {
            steps {
                sh '''
                    sh scripts/monitor-chaos.sh ${notify_id}
                '''
            }
        }
        
        stage('Verify Resilience Score') {
            steps {
                sh '''
                    sh scripts/verify-rr.sh ${notify_id} > r_s.txt
                '''
                script {
                     //env.resilience_score = sh(returnStdout: true, script: 'cat r_s.txt').trim()
                    resilience_score = sh(returnStdout: true, script: 'cat r_s.txt').trim()
                 }
            }
        }
        
        stage('Take Rollback Decision') {
            steps {
                sh '''
                    echo ${resilience_score}
                    sh scripts/rollback-deploy.sh ${resilience_score}
                '''
            }
        }
    }
}
