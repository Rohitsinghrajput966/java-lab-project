#!/usr/bin/env bash
# ==============================================================================
# shopsphere - Run Java Socket Networking Demo (java.net Server & Client)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JDK_DIR="/home/devops-user/tools/jdk-21.0.12.1+1"

export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

NETWORK_CP="$SCRIPT_DIR/shopsphere-network/target/classes:$SCRIPT_DIR/shopsphere-dao/target/classes:$SCRIPT_DIR/shopsphere-common/target/classes:/home/devops-user/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar:/home/devops-user/.m2/repository/com/zaxxer/HikariCP/5.1.0/HikariCP-5.1.0.jar:/home/devops-user/.m2/repository/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-classic/1.5.3/logback-classic-1.5.3.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-core/1.5.3/logback-core-1.5.3.jar:/home/devops-user/.m2/repository/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar"

echo "=================================================================="
echo "  Starting shopsphere java.net Inventory Server on port 9090..."
echo "=================================================================="

# Start server in background
java -cp "$NETWORK_CP" com.shopsphere.network.server.InventoryServer > /tmp/inventory_server.log 2>&1 &
SERVER_PID=$!

# Ensure cleanup on exit
trap 'kill -9 $SERVER_PID 2>/dev/null || true' EXIT

sleep 2

echo "Running java.net Inventory Client against localhost:9090..."
echo "------------------------------------------------------------------"
java -cp "$NETWORK_CP" com.shopsphere.network.client.InventoryClient

echo ""
echo "=================================================================="
echo "  ✓ java.net Socket Server & Client test completed successfully!"
echo "=================================================================="

