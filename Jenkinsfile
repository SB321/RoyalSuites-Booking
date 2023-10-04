pipeline {
    agent any 
    
    stages{
        stage("GithubCode"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/SB321/RoyalSuites-Booking.git", branch: "master"
            }
        }
        stage("Build"){
            steps {
                echo "Building the image"
                sh "docker build -t royalsuites-app ."
            }
        }
        stage("Push to Docker Hub"){
            steps {
                echo "Pushing the image to Docker Hub"
                withCredentials([usernamePassword(credentialsId:"DockerHub",passwordVariable:"DockerHubPass",usernameVariable:"DockerHubUser")]){
                    sh "docker tag royalsuites-app ${env.DockerHubUser}/royalsuites-app:latest"
                    withDockerRegistry([ credentialsId: "DockerHub", url: "" ]) {
                    
                        sh "docker push ${env.DockerHubUser}/royalsuites-app:latest"
         
                    }
                
                }
            }
        }
        
        stage("Run Ansible Playbook"){
            steps {
                echo "Running Ansible"
                ansiblePlaybook credentialsId: 'Ansible', disableHostKeyChecking: true, installation: 'Ansible', inventory: '/etc/ansible/hosts', playbook: 'samplebook.yml'
                
            }
        }
        
    }
}
