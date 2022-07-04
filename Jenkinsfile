pipeline {
    agent any

    environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhub')
	}

    stages {
        stage('Source Code') {
            steps {
                git branch: 'main', changelog: false, credentialsId: 'github', poll: false, url: 'https://github.com/prinzjoseph/springboot-deployment.git'
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build -t princejoseph1k94/newsapp:${env.BUILD_NUMBER} ."
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push princejoseph1k94/newsapp:${env.BUILD_NUMBER}"
                sh "docker rmi princejoseph1k94/newsapp:${env.BUILD_NUMBER}"
            }
        }
        stage('Deploying to Minikube') {
            steps {
                sh '''
                    cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" > newdeployment.yaml
                    rsync -avz newdeployment.yaml prince@192.168.1.37:~
                    rsync -avz service.yaml prince@192.168.1.37:~
                    ssh prince@192.168.1.37 "kubectl apply -f newdeployment.yaml"
                    ssh prince@192.168.1.37 "kubectl apply -f service.yaml"
                '''
            }
        }
    }
}
