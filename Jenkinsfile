pipeline { 
    agent any 
    
    parameters {
        choice (
             name: 'ACTION',
             choices: ['apply', 'destroy', 'plan'],
             description: 'Choose Terraform action'
        )
    }

    stages {
        stage ('Checkout') {
            steps {
                checkout scm 
            }
        }
        stage ('Checkov Scan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Running Checkov Scan...'
                
                docker run --rm \
                  -u $(id -u):$(id -g) \
                  -v "$(pwd)":/iac \
                  bridgecrew/checkov \
                  -d /iac \
                  --framework terraform \
                  --output json \
                  --output-file-path /iac/checkov-report.json
                '''
            }
        }
        stage ('Tfsec Scan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Running Tfsec scan...'
                docker run --rm \
                  -u $(id -u):$(id -g) \
                  -v "$(pwd)":/iac \
                  aquasec/tfsec /iac \
                  --format json \
                  --out /iac/tfsec-report.json
                '''
            }
        }
        stage ('Debug Workspace') {
            steps {
                sh '''
                echo '==DEBUG=='
                echo 'PWD:'
                pwd

                echo 'FILES'
                ls -lah
                '''
            }
        }
        stage ('Debug Files') {
            steps {
                sh '''
                echo "=== CURRENT DIR ==="
                pwd

                echo "=== FILES ==="
                ls -lah

                echo "=== RECURSIVE ==="
                find . -name "*.json"
                '''
            }
        }
        stage ('Terraform Version') {
            steps {
                sh '''
                terraform version
                '''
            }
        }
        stage ('Terraform format') {
            when {
                expression { params.ACTION == 'apply' }
            }    
            steps {
                sh '''
                set -euo pipefail 

                echo 'Adjusting terraform format...'
                terraform fmt -check -recursive
                '''
            }
        }
        stage ('Terraform init') {
            steps {
                sh '''
                set -euo pipefail 

                echo 'Running Terraform init...'
                terraform init 
                '''
            }
        }
        stage ('Terraform validate') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Validating Terraform configuration...'

                terraform validate
                '''
            }
        } 
        stage ('Terraform plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Checking terraform infrastructure...'
                terraform plan -out=tfplan
                '''
            }
        }
        stage ('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Applying terraform infrastructure'
                terraform apply -auto-approve tfplan
                '''
            }
        }
        stage ('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                sh '''
                set -euo pipefail 

                echo 'Destroying terraform infrastructure and resources...'
                terraform init 
                terraform destroy -auto-approve
                '''
            }
        }
    }
    post { 
        always {
            archiveArtifacts artifacts: '**/*.json', allowEmptyArchive: true
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline executed successful ✅'
        }
        failure {
            echo 'Pipeline failed, please check Jenkins logs 🚫'
        }
    }
}