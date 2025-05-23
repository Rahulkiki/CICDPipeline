pipeline {
    agent any

    tools {
        maven 'Maven'  // Set up in Global Tool Config
    }

    environment {
        WAR_PATH = 'target/javaapp.war'
        TOMCAT_URL = 'http://localhost:8080'
        TOMCAT_USER = 'admin'
        TOMCAT_PASS = 'admin'
        CONTEXT_PATH = '/javaapp'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Rahulkiki/CICDPipeline.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                echo '📦 Building WAR with Maven...'
                sh 'mvn clean package'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (!fileExists("${WAR_PATH}")) {
                        error "❌ WAR file not found at ${WAR_PATH}"
                    }
                }
                sh '''
                    echo "🔐 Fetching Jenkins crumb..."
                    CRUMB=$(curl -s -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                      "${TOMCAT_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

                    echo "🚀 Deploying WAR with crumb..."
                    curl -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                         -H "$CRUMB" \
                         -T "${WAR_PATH}" \
                         "${TOMCAT_URL}/manager/text/deploy?path=${CONTEXT_PATH}&update=true"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployed to http://13.203.104.217:8080${CONTEXT_PATH}/index.jsp"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}