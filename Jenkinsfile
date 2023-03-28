pipeline {
    agent any
    
    environment {
           WORKFLOW_ID    = '9bd2855f-b822-464c-9906-0f9ebe824cc6'                    
    }

    stages {
        
        stage('Launch App') {
            steps {
                withKubeConfig([namespace: 'boutique']){
                    sh 'kubectl apply -f ../cartservice.yaml'
                }
            }
        }

        stage('Launch Chaos Experiment') {
            steps {
                 sh '''
                    echo ${PROJECT_ID}
                    sh scripts/launch-chaos.sh
                 '''
                 
//                  sh '''
//                     sh scripts/monitor-chaos.sh
//                  '''
                 
//                  sh '''
//                     sh scripts/verify-rr.sh
//                  '''
            }
        }
//         stage('Post-App-Check') {
//             steps {
//                  sh '''
//                     sh scripts/post-chaos-check-url.sh
//                  '''
//             }
//         }
    }
}
