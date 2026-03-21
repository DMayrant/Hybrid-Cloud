pipeline { 
    agent any 

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }
 
    parameters {
        choice(
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
        stage ('Check Terraform files') {
            steps {
                sh '''
                echo "Terraform files:"
                find . -name "*.tf"
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
         stage ('Checkov Scan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh '''
                set -euo pipefail

                echo 'Running Checkov Scan...'
                echo "PWD=$(pwd)"
                find . -type f -name "*.tf" -print

                docker run --rm \
                  --workdir /iac \
                  -u "$(id -u):$(id -g)" \
                -v "$(pwd):/iac" \
                bridgecrew/checkov:latest \
                -d /iac \
                --framework terraform \
                --download-external-modules true \
                --evaluate-variables true \
                --output cli \
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
                set -euo pipefail

                echo 'Running Tfsec scan...'
                echo "PWD=$(pwd)"
                find . -type f -name "*.tf" -print

                docker run --rm \
                  --workdir /iac \
                  -u "$(id -u):$(id -g)" \
                  -v "$(pwd):/iac" \
                  aquasec/tfsec /iac \
                  --format json \
                  --out /iac/tfsec-report.json
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
                expression { params.ACTION == 'apply' || params.ACTION == 'plan' }
                
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
        stage ('Archive Reports') {
            steps {
                sh '''
                echo "=== VERIFY ARTIFACTS ==="
                pwd
                ls -lah
                find . -name "*.json" || true
                '''
                archiveArtifacts artifacts: '**/*.json', allowEmptyArchive: true
                archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
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