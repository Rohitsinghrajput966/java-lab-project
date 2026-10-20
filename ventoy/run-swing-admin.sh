#!/usr/bin/env bash
# ==============================================================================
# shopsphere - Launch Desktop Swing Admin Application
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JDK_DIR="/home/devops-user/tools/jdk-21.0.12.1+1"

export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

SWING_CP="$SCRIPT_DIR/shopsphere-swing-admin/target/classes:$SCRIPT_DIR/shopsphere-dao/target/classes:$SCRIPT_DIR/shopsphere-common/target/classes:/home/devops-user/.m2/repository/com/h2database/h2/2.2.224/h2-2.2.224.jar:/home/devops-user/.m2/repository/com/zaxxer/HikariCP/5.1.0/HikariCP-5.1.0.jar:/home/devops-user/.m2/repository/org/slf4j/slf4j-api/2.0.12/slf4j-api-2.0.12.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-classic/1.5.3/logback-classic-1.5.3.jar:/home/devops-user/.m2/repository/ch/qos/logback/logback-core/1.5.3/logback-core-1.5.3.jar:/home/devops-user/.m2/repository/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar"

echo "=================================================================="
echo "  Starting shopsphere Desktop Swing Admin Application..."
echo "  DISPLAY: $DISPLAY"
echo "=================================================================="
echo "  Admin Credentials:"
echo "    - Email:    admin@shopsphere.com"
echo "    - Password: Admin@123"
echo "=================================================================="

exec java -cp "$SWING_CP" com.shopsphere.swing.MainSwingAdmin

