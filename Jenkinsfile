pipeline { 
    agent any 

    stages {
        stage ('Checkout') {
            steps {
                checkout scm 
            }
        }
        stage ('Checkov Scan') {
            steps {
                sh '''
                set -euo pipefail 

                echo 'Running Checkov Scan...'
                
                docker run --rm \
                  -v $(pwd):/iac \
                  bridgecrew/checkov \
                  -d /iac \
                  --framework terraform,kubernetes \
                  --check HIGH \
                  --output json \
                  --output-file-path checkov-report.json
                '''
            }
        }
    stage ('Tfsec Scan') {
            steps {
                sh '''
                set -euo pipefail 

                echo 'Running Tfsec scan...'

                docker run --rm \
                  -v $(pwd):/iac \
                  aquasec/tfsec /iac \
                  --format json \
                  --out tfsec-report.json
                '''
            }
        }    
    }
    post { 
        success {
            echo 'Pipeline executed successful ✅'
        }
        failure {
            echo 'Pipeline failed, please check Jenkins logs 🚫'
        }
    }
}