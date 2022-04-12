pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION='us-east-1'
        REGION = 'us-east-1'
        ACCOUNT = '711439543033'
        DOCKER_REPO_NAME = 'docker-web-app'
    }
    stages {
        stage('build') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "my-aws-credentials",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                bat 'aws ecr get-login-password --region %REGION% | docker login --username AWS --password-stdin %ACCOUNT%.dkr.ecr.%REGION%.amazonaws.com'
                bat 'docker build -t %DOCKER_REPO_NAME% .'
                bat 'docker tag %DOCKER_REPO_NAME%:latest %ACCOUNT%.dkr.ecr.%REGION%.amazonaws.com/%DOCKER_REPO_NAME%:latest'
                bat 'docker push %ACCOUNT%.dkr.ecr.%REGION%.amazonaws.com/%DOCKER_REPO_NAME%:latest'
                }
            }
        }
        stage('deploy') {
            steps {
                sshPublisher(
                    publishers: 
                    [sshPublisherDesc(configName: 'webapp', transfers: [sshTransfer(cleanRemote: false, excludes: '',
                     execCommand: '''sudo sh execute-commands.sh''',
                    execTimeout: 0, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
    }
}