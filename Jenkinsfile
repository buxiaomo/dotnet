pipeline {
    agent { 
        label "swarm"
    }

    environment {
        PROJECT_NAME = "ruoyi"
        PROJECT_ENV = "dev"

        REPOSITORY_URL = "https://github.com/buxiaomo/dotnet.git"

        REGISTRY_HOST = "172.16.115.11:5000"

        DOTNET_CLI_HOME = "/tmp"
        XDG_DATA_HOME   = "/tmp"
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

        stage('build package') {
            steps {
                withDockerContainer('mcr.microsoft.com/dotnet/sdk:6.0') {
                    sh "dotnet publish -c Release -o ./publish"
                }
            }
        }

        // stage('build image') {
        //     steps {
        //         withDockerContainer('mcr.microsoft.com/dotnet/sdk:6.0') {
        //             sh "dotnet publish -c Release -o /publish"
        //         }
        //     }
        // }
    }
}
