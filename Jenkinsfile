pipeline {
    agent any
    parameters {
            string(name: 'notify_id', defaultValue: '')
            string(name: 'resilience_score', defaultValue: '0')
        }
    environment {
           WORKFLOW_ID    = '9bd2855f-b822-464c-9906-0f9ebe824cc6' 
           EXPECTED_RESILIENCE_SCORE = 100
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
                     env.notify_id = sh(returnStdout: true, script: 'cat n_id.txt').trim()
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
                     env.resilience_score = sh(returnStdout: true, script: 'cat r_s.txt').trim()
                 }
            }
        }
        
        stage('Take Rollback Decision') {
            steps {
                script {
                    if (${resilience_score} < ${EXPECTED_RESILIENCE_SCORE}){
                        sh 'scripts/rollback-deploy.sh'
                    }
                }
            }
        }
    }
}
