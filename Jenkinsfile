pipeline {

    agent {
        docker {
            image '009543623063.dkr.ecr.eu-west-2.amazonaws.com/jenkins-docker-ci:latest'
            alwaysPull true
            args '-v /var/run/docker.sock:/var/run/docker.sock '
        }
    }

    environment {
        DOCKER_REGISTRY = '009543623063.dkr.ecr.eu-west-2.amazonaws.com'
        DOCKER_IMAGE_NAME = "${env.JOB_NAME.split('/')[-2]?.replaceFirst('docker-', '')}"
        DOCKER_TAG = "${env.BRANCH_NAME == 'master' ? 'latest' : env.BRANCH_NAME}"
        DOCKER_OPTS = '--pull --compress --no-cache=true --force-rm=true --progress=plain '
        ARTIFACTORY=credentials("devtools/jfrog-mca-bot")
        DOCKER_BUILDKIT = '1'
    }

    triggers{
        // run once a week between the hours of 1 and 6 on sunday
        cron('H H(1-6) * * 0')
        upstream(upstreamProjects: 'Docker/docker-jenkins-base/master')
    }

    options{
        ansiColor('xterm')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
    }

    stages {

        stage('build'){
            steps{
                sh '''
                    docker build ${DOCKER_OPTS} -t "${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}" .
                '''
            }
        }

        stage('publish') {
            steps{
                // need to find a way to inject the url
                sh '''
                    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                '''
            }
        }
    }
}
