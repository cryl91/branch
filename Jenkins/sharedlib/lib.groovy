pipeline {
    agent any //To run on different agent = agent { node { label 'agent1' } }
    environment {
    user = 'abc'
    }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
        }
    
    stages {
        stage('Build') {
            steps {
                //Use triple double quotes (""") instead of single quotes (''') 
                //to allow Groovy to evaluate variables before passing them to the shell.
                sh """ 
                echo "Hello ${params.PERSON}"
                """
            } 
        }
    }

        post {
            always {
                echo "I will run everytime"
            }

            success {
                echo "I will run only on success"
            }
            failure {
                echo "I will run only on failure"
            }
        }
    
} 