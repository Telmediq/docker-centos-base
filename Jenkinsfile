properties([
    pipelineTriggers([
        [$class: "GitHubPushTrigger"]
    ])
])

// Set project name.
def projectName = 'docker-centos-base'
def buildLock = "${projectName}_${env.BRANCH_NAME}"

pipeline {

    options {
        ansiColor('xterm')
    }

    agent {
        label 'ec2'
    }

    environment {
        AWS = credentials('jenkins-docker-build')
        REGISTRY_URI = credential('master-ecr-repo-url`)
    }

    stages {

        stage ('Setup') {
            steps {
                sh '''
                    export REGISTRY_URI=$REGISTRY_URI
                    export AWS_ACCESS_KEY_ID=$AWS_USR
                    export AWS_SECRET_ACCESS_KEY=$AWS_PSW
                    make repo-login
                '''
            }
        }

        stage ('Build') {
            steps {
                lock(resource: buildLock, inversePrecedence: true) {
                    sh("make build-nc")
                    milestone(10)
                }
            }
        }

        stage ('Publish') {
            when {
                expression {
                    return env.BRANCH_NAME ==~ /(master)/
                }
            }
            steps {
                sh '''
                    export REGISTRY_URI=$REGISTRY_URI
                    export AWS_ACCESS_KEY_ID=$AWS_USR
                    export AWS_SECRET_ACCESS_KEY=$AWS_PSW
                    make publish
                '''
            }
        }

    }

    post {
        always {
            sh '''
                make clean
            '''
        }
    }
}