pipeline {
    agent { 
        label "swarm"
    }

    environment {
        PROJECT_NAME = "dotnet"
        PROJECT_ENV = "dev"

        REPOSITORY_URL = "https://github.com/buxiaomo/dotnet.git"

        REGISTRY_HOST = "172.16.115.11:5000"

        DOTNET_CLI_HOME = "/tmp"
        XDG_DATA_HOME   = "/tmp"

        SONAR_HOST_URL = "http://172.16.115.11:32583"
        SONAR_LOGIN = "sqp_ceb96c869679965251ce40222d6963220f47dd35"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    stages {
        stage('checkout') {
            steps {
                retry(3) {
                    checkout scmGit(branches: [[name: "main"]], extensions: [[$class: 'CleanBeforeCheckout'],[$class: 'CloneOption', timeout: 120, shallow: true, noTags: true, depth: 1]], submoduleCfg: [], userRemoteConfigs: [[url: "${env.REPOSITORY_URL}"]])
                }
            }
        }

        stage('code review') {
            steps {
                withDockerContainer('sonarsource/sonar-scanner-cli:4') {
                    sh "sonar-scanner -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_LOGIN}"
                }
            }
        }

        stage('build package') {
            steps {
                withDockerContainer('mcr.microsoft.com/dotnet/sdk:6.0') {
                    sh "dotnet publish -c Release -o ./publish"
                }
            }
        }

        stage('build image') {
            steps {
                sh label: 'Build', script: "docker build -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/webapp:${BUILD_ID} -f Dockerfile ."
                sh label: 'Push', script: "docker push ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/webapp:${BUILD_ID}"
            }
        }
    }
}
