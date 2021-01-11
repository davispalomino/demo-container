#!groovy
pipeline {
    agent any
    options {
        ansiColor('xterm')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '180', numToKeepStr: '10')
        skipDefaultCheckout true
        disableConcurrentBuilds()
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Image') {
            steps {
                script {
                    sh "make image"
                }
            }
        }
        stage('Build build') {
            steps {
                script {
                    sh "make release"
                }
            }
        }
        stage('Build Postman') {
            steps {
                script {
                    sh "make newmantest"
                }
            }
        }
    }
    post {
        always {
            deleteDir()
            ws(pwd() + "@tmp") {
                step([$class: 'WsCleanup'])
            }
            ws(pwd() + "@script") {
                step([$class: 'WsCleanup'])
            }
            ws(pwd() + "@script@tmp") {
                step([$class: 'WsCleanup'])
            }
        }
    }
}