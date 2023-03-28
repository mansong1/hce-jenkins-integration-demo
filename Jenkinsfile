pipeline {
    agent any
    
    environment {
           WORKFLOW_ID    = '9bd2855f-b822-464c-9906-0f9ebe824cc6'                    
    }

    stages {
        
        stage('Launch App') {
            steps {
                git url: "https://github.com/ksatchit/hce-jenkins-integration-demo"
                step([$class: 'KubernetesEngineBuilder', 
                        projectId: "lucid-timing-371211",
                        clusterName: "cluster-1",
                        zone: "us-central1-c",
                        manifestPattern: 'cartservice.yaml',
                        credentialsId: "My First Project",
                        verifyDeployments: true])
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
