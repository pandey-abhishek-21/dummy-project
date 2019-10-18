#!/bin/bash
set -e

CURRENT_DIR=`pwd`
cd $(dirname $0)

# Source common config
#. ../../../config/sonar-config.sh > /dev/null 2>&1



qualityGateid=$(curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/show?name=JetsCustomQualityGate" | awk -F\: '{print $2}'|awk -F\, '{print $1}')
echo "Quality Gate ${qualityGateid}"

# Checking if quality gate with the name exists?

if echo "$qualityGateid" | egrep -q '^\-?[0-9]+$'; then
    echo "qualilityGate JetsCustomQualityGate already exists"
    exit 0
else
    # Creating a quality Gate
    qualityGateid=$(curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create?name=JetsCustomQualityGate" | awk -F\: '{print $2}'|awk -F\, '{print $1}')

    #Setting the quality gate as default
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/set_as_default?id=${qualityGateid}"
    #Creating Conditions for quality Gates
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=blocker_violations&op=GT&warning=0&error=5"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=coverage&op=LT&error=90"
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=new_coverage&op=LT&error=50"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=SMELL_COUNT&op=GT&error=10"
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=SMELL_COUNT_MISSING_TEST&op=GT&error=70"
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=tests&op=LT&error=40"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=test_success_density&op=LT&error=100"
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=test_errors&op=GT&error=5"
    #curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=test_failures&op=GT&error=5"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=critical_severity_vulns&op=GT&error=0"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=high_severity_vulns&op=GT&error=1"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=medium_severity_vulns&op=GT&error=1"
    curl -X POST -v -u $SONAR_USER:$SONAR_PASS  "${SONAR_HOST}/api/qualitygates/create_condition?gateId=${qualityGateid}&metric=low_severity_vulns&op=GT&error=1"
    
fi

cd $CURRENT_DIR
