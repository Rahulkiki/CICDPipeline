pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        WAR_PATH = 'target/javaapp.war'
        TOMCAT_URL = 'http://localhost:8081'
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

        stage('Deploy to Tomcat') {
            steps {
                script {
                    if (!fileExists("${WAR_PATH}")) {
                        error "❌ WAR file not found at ${WAR_PATH}"
                    }
                }

                sh '''
                    echo "🚀 Deploying WAR to Tomcat (8081)..."
                    curl -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                         -T "${WAR_PATH}" \
                         "${TOMCAT_URL}/manager/text/deploy?path=${CONTEXT_PATH}&update=true"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployed to http://13.203.104.217:8081${CONTEXT_PATH}/index.jsp"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}