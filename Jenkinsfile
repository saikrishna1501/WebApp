pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION='us-east-1'
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
                bat 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 711439543033.dkr.ecr.us-east-1.amazonaws.com'
                bat 'docker build -t docker-web-app .'
                bat 'docker tag docker-web-app:latest 711439543033.dkr.ecr.us-east-1.amazonaws.com/docker-web-app:latest'
                bat 'docker push 711439543033.dkr.ecr.us-east-1.amazonaws.com/docker-web-app:latest'
                }
            }
        }
        stage('deploy') {
            steps {
                sshPublisher(
                    publishers: 
                    [sshPublisherDesc(configName: 'webapp', transfers: [sshTransfer(cleanRemote: false, excludes: '',
                     execCommand: '''cd /home/ec2-user
                                    touch test.txt
                                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 711439543033.dkr.ecr.us-east-1.amazonaws.com
                                    docker run -p 80:80 -d 711439543033.dkr.ecr.us-east-1.amazonaws.com/docker-web-app''',
                    execTimeout: 0, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
    }
}