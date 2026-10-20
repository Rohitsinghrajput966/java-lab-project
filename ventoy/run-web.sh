#!/usr/bin/env bash
# ==============================================================================
# shopsphere - Start Web Application (Apache Tomcat 10.1 + Jakarta EE 10)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOMCAT_DIR="/home/devops-user/tools/apache-tomcat-10.1.20"
JDK_DIR="/home/devops-user/tools/jdk-21.0.12.1+1"

export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

REBUILD=0
if [ "$1" = "--build" ] || [ "$1" = "--rebuild" ] || [ "$1" = "-b" ]; then
    REBUILD=1
fi

if [ $REBUILD -eq 1 ] || [ ! -f "$SCRIPT_DIR/shopsphere-web/target/shopsphere-web.war" ]; then
    echo "=================================================================="
    echo "  Building shopsphere Web Application (WAR) via Maven..."
    echo "=================================================================="
    cd "$SCRIPT_DIR"
    mvn package -DskipTests -pl shopsphere-web -am
    
    echo "Deploying WAR to Apache Tomcat 10.1 webapps/ROOT.war..."
    if curl -s -I http://localhost:8080/ > /dev/null 2>&1; then
        echo "Stopping active Tomcat instance for clean redeployment..."
        "$SCRIPT_DIR/stop-web.sh" > /dev/null 2>&1 || true
        sleep 2
    fi
    rm -rf "$TOMCAT_DIR/webapps/ROOT" "$TOMCAT_DIR/webapps/ROOT.war"
    cp "$SCRIPT_DIR/shopsphere-web/target/shopsphere-web.war" "$TOMCAT_DIR/webapps/ROOT.war"
    mkdir -p "$TOMCAT_DIR/webapps/ROOT"
    cd "$TOMCAT_DIR/webapps/ROOT"
    jar -xf ../ROOT.war
    cd "$SCRIPT_DIR"
fi

if curl -s -I http://localhost:8080/ > /dev/null 2>&1; then
    echo "=================================================================="
    echo "  shopsphere Web Application is ALREADY RUNNING!"
    echo "  Open in your web browser: http://localhost:8080/"
    echo "=================================================================="
    exit 0
fi

echo "Starting shopsphere Web Application on Tomcat 10.1..."
"$TOMCAT_DIR/bin/startup.sh"

echo "Waiting for server to initialize..."
for i in {1..20}; do
    if curl -s -I http://localhost:8080/ > /dev/null 2>&1; then
        echo ""
        echo "=================================================================="
        echo "  🎉 shopsphere is LIVE at: http://localhost:8080/"
        echo "=================================================================="
        echo "  Quick Logins:"
        echo "    - Admin Portal:   pooja@shopsphere.com  / Pooja@123"
        echo "    - Customer Store: priya@shopsphere.com  / Priya@123"
        echo "=================================================================="
        exit 0
    fi
    sleep 1
done

echo "Server started. Logs available at: $TOMCAT_DIR/logs/catalina.out"

