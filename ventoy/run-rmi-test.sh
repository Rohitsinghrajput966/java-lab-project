#!/usr/bin/env bash
# ==============================================================================
# shopsphere - Run Java Remote Method Invocation (RMI) Demo
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JDK_DIR="/home/devops-user/tools/jdk-21.0.12.1+1"

export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

RMI_CP="$SCRIPT_DIR/shopsphere-rmi/target/classes:$SCRIPT_DIR/shopsphere-dao/target/classes:$SCRIPT_DIR/shopsphere-common/target/classes:/home/devops-user/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar:/home/devops-user/.m2/repository/com/zaxxer/HikariCP/5.1.0/HikariCP-5.1.0.jar:/home/devops-user/.m2/repository/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-classic/1.5.3/logback-classic-1.5.3.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-core/1.5.3/logback-core-1.5.3.jar:/home/devops-user/.m2/repository/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar"

echo "=================================================================="
echo "  Starting shopsphere Java RMI Server & Registry on port 1099..."
echo "=================================================================="

# Start server in background
java -cp "$RMI_CP" com.shopsphere.rmi.server.RmiServerLauncher > /tmp/rmi_server.log 2>&1 &
RMI_PID=$!

# Ensure cleanup on exit
trap 'kill -9 $RMI_PID 2>/dev/null || true' EXIT

sleep 2

echo "Running Java RMI Client Test against localhost:1099..."
echo "------------------------------------------------------------------"
java -cp "$RMI_CP" com.shopsphere.rmi.client.RmiClientTest

echo ""
echo "=================================================================="
echo "  ✓ Java RMI Remote Service test completed successfully!"
echo "=================================================================="

