pipeline {
    agent any
    
    //environment {
    //        notify_id = ''
    //        resilience_score = ''
    //    }
    
    parameters {
           // https://app.harness.io/ng/account/cTU1lRSWS2SSRV9phKvuOA/chaos/orgs/default/projects/ChaosDev/experiments/d7c9d243-0219-4f7c-84c2-3004e59e4505/chaos-studio?tab=BUILDER&experimentName=boutique-cart-cpu-hog&infrastructureType=Kubernetes&experimentType=experiment&unsavedChanges=false
           string(name: 'WORKFLOW_ID', defaultValue: 'd7c9d243-0219-4f7c-84c2-3004e59e4505') 
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
                sh '''
                    echo ${resilience_score}
                    sh scripts/rollback-deploy.sh ${resilience_score}
                '''
            }
        }
    }
}
