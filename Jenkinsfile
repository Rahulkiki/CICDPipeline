pipeline {
    agent any

    environment {
        MAVEN_HOME = '/Applications/apache-maven-3.9.5'
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
        WAR_PATH = 'target/javaapp.war'
        TOMCAT_URL = 'http://localhost:8080/manager/text'
        TOMCAT_USER = 'admin'
        TOMCAT_PASS = 'admin'
        CONTEXT_PATH = '/javaapp'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/Rahulkiki/CICDPipeline.git', branch: 'main'
            }
        }

        stage('Build with Maven') {
            steps {
                echo '📦 Building WAR with Maven...'
                sh 'mvn clean package'
            }
        }

        stage('Verify WAR Exists') {
            steps {
                script {
                    if (!fileExists("${WAR_PATH}")) {
                        error "❌ WAR file not found at ${WAR_PATH}"
                    }
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                echo "🚀 Deploying WAR to Tomcat at ${CONTEXT_PATH} ..."
                sh """
                    curl -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                         -T "${WAR_PATH}" \
                         "${TOMCAT_URL}/deploy?path=${CONTEXT_PATH}&update=true"
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete: http://localhost:8080${CONTEXT_PATH}/index.jsp"
        }
        failure {
            echo "❌ Build or deploy failed"
        }
    }
}