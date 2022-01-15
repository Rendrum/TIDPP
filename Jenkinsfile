#!groovy

pipeline {


    agent any
    
    triggers{
        cron('0 0-23/2 * * *')
    }

     options {
          buildDiscarder(logRotator(numToKeepStr: '10'))
          timestamps()
     }
     
     parameters {
        booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: false, description: 'Clean workspace at the end.')
    }

    

     environment {
         ON_SUCCESS_SEND_EMAIL = 'true'
         ON_FAILURE_SEND_EMAIL = 'true'
         DELETE_FOLDER_AFTER_STAGES = 'false'
         DB_ENGINE    = 'sqlite3'
     }

    stages() {


        stage("Procesul de Build") {
        
            steps {
                echo "Build number ${BUILD_NUMBER} and ${BUILD_TAG}"

                bat 'C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m venv "${BUILD_TAG}" && \
                ${BUILD_TAG}\\Scripts\\activate.bat && \
                C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m pip install --upgrade pip && \
                C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe -m pip install -r requirements.txt && \
                C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py makemigrations && \
                C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py migrate && \
                ${BUILD_TAG}\\Scripts\\deactivate.bat'
            }


        }


         stage("Testing backend") {
        
            steps {
                bat 'C:\\Users\\Daniel\\AppData\\Local\\Programs\\Python\\Python310\\python.exe manage.py test'
                junit '**/test-reports/unittest/*.xml'
            }

        }
        
        stage("Testing frontend") {
            environment { 
                TESTING_FRONTEND=false
            }
            steps {
                bat 'IF "%TESTING_FRONTEND%"=="true" echo "running frontend %TESTING_FRONTEND%"'
            }
}
        stage("Delivery/Deployment") {
        
            steps {
                echo "Deployment stage"
            }

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
                     to: 'gredet200@gmail.com'
                     
            echo "Send email job name: ${JOB_NAME}, build number: ${BUILD_NUMBER}, build url: ${BUILD_URL} "
            emailext ( body: "Jenkins! job name: ${JOB_NAME}, build number: ${BUILD_NUMBER}, build url: ${BUILD_URL}",
                        subject: 'Build',
                        to: 'cevdar.daniel@isa.utm.md')
        }

         unstable {
              echo "The build is unstable. Try fix it"
         }

          failure {
             echo "Something happened"
          }

      }
    }

