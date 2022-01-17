#!groovy

pipeline {


    agent any
    
    triggers{
        cron('0 0-23/2 * * *')
        //minuta 0 la fiecare 2 ore de la 0 la 23
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        //numarul de build loguri 
        timestamps()
    }
     
    parameters {
        booleanParam(name: "CLEAN_WORKSPACE", defaultValue: true, description: "Clean workspace at the end.")
        booleanParam(name: "TESTING_FRONTEND", defaultValue: false, description: "Check this option if you would like to test the frontend.")
    }

    environment {
        DB_ENGINE    = 'sqlite3'
        ON_SUCCESS_SEND_EMAIL = 'True'
        ON_FAILURE_SEND_EMAIL = 'True'
        DELETE_FOLDER_AFTER_STAGES = 'False'
    }

    stages() {


        stage("Procesul de Build") {
        
            steps {
                echo "Build number ${BUILD_NUMBER} and ${BUILD_TAG}"

                bat 'C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m venv "${BUILD_TAG}" && \
                ${BUILD_TAG}\\Scripts\\activate.bat && \
                C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m pip install --upgrade pip && \
                C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m pip install -r requirements.txt && \
                C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py makemigrations && \
                C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py migrate && \
                ${BUILD_TAG}\\Scripts\\deactivate.bat'
            }


        }

        stage("Testing backend") {
        
            steps {
                bat 'C:\\Users\\Scooby\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py test'
                junit '**/test-reports/unittest/*.xml'
                //cadru de testare pentru Java 
            }

        }
        
            stage("TEST_FRONTEND") {
        when {
            expression {
            return params.TESTING_FRONTEND;
            }
        }

        steps {
            echo "${params.TESTING_FRONTEND}"
            }
        }

        stage("Continuous Delivery") {
      steps {
        script {
          dockerimage = docker.build('rendrum/tidpp:latest')
        
          docker.withRegistry('https://registry-1.docker.io/v2/', 'docker-jenkins') {
            dockerimage.push()
          }
        }
      }
    }

    stage("Continuous Deployment") {
      steps {
        sh 'docker compose -f docker-compose.yml --env-file ./.env up --detach --force-recreate'
      }
    }

    stage("DEPLOY") {
      steps {
        echo "Deployment stage"
      }
    }
  }


    post {
        always {
            echo "${BUILD_TAG}"
            script {
                if (params.CLEAN_WORKSPACE == true) {
                    echo 'Cleaning workspace'
                    cleanWs()
                } else {
                    echo 'Not needing to clean workspace'
                }
            }
        }
     
        success {
            echo "Sending emails"
            emailext body: '$PROJECT_NAME',
                     subject: '$PROJECT_NAME',
                     to: 'testtidpp@gmail.com'
                     
            echo "Send email job name: ${JOB_NAME}, build number: ${BUILD_NUMBER}, build url: ${BUILD_URL} "
            emailext ( body: "Jenkins! job name: ${JOB_NAME}, build number: ${BUILD_NUMBER}, build url: ${BUILD_URL}",
                        subject: 'Build',
                        to: 'testtidpp@gmail.com')
                           
        }
     
         unstable {
              echo "The build is unstable. Try fix it"
         }

          failure {
             echo "Something happened"
          }
    }
}