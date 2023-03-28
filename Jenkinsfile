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
                 nid_output = sh (script: 'sh scripts/launch-chaos.sh', returnStdout: true).trim()
                 env.notify_id = nid_output
            }   
        }
        
        stage('Monitor Chaos Experiment') {
            steps {
                sh '''
                    sh scripts/monitor-chaos.sh ${env.notify_id}
                '''
            }
        }
        
        stage('Verify Resilience Score') {
            steps {
                rs_output = sh (script: 'sh scripts/verify-rr.sh ${env.notify_id}', returnStdout: true).trim()
                env.resilience_score = rs_output
            }
        }
        
        stage('Take Rollback Decision') {
            steps {
                if (env.resilience_score.toInteger() < ${EXPECTED_RESILIENCE_SCORE}){
                    sh '''
                        sh scripts/rollback-deploy.sh
                    '''
                }
            }
        }
    }
}
