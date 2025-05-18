#!/bin/bash

# === CONFIGURATION ===
PROJECT_DIR="/Users/rahulkumar/Downloads/CICDPipeline"
TOMCAT_PATH="/Users/rahulkumar/Downloads/apache-tomcat-9.0.104"
WAR_NAME="javaapp"

echo "🔨 Step 1: Building project with Maven..."
cd "$PROJECT_DIR" || { echo "❌ Project directory not found"; exit 1; }
mvn clean install || { echo "❌ Maven build failed. Exiting."; exit 1; }

echo "🛑 Step 2: Stopping Tomcat..."
"$TOMCAT_PATH/bin/shutdown.sh"

echo "🧹 Step 3: Cleaning old WAR and folder..."
rm -rf "$TOMCAT_PATH/webapps/$WAR_NAME"
rm -f "$TOMCAT_PATH/webapps/$WAR_NAME.war"

echo "📦 Step 4: Copying new WAR to Tomcat..."
cp "$PROJECT_DIR/target/$WAR_NAME.war" "$TOMCAT_PATH/webapps/"

echo "🚀 Step 5: Starting Tomcat..."
"$TOMCAT_PATH/bin/startup.sh"

echo "✅ Deployment complete!"
echo "🌐 Visit: http://localhost:8080/$WAR_NAME"