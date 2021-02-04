#!/bin/bash
set -e

if [ $# != 2 ] ; then
    echo "Usage: build_workflow.sh <workflow directory> <destination directory>" >&2
    exit 1
fi

WORKFLOW_NAME=$1
DESTINATION=$2

if [ ! -d $WORKFLOW_NAME ] ; then
    echo "ERROR: $WORKFLOW_NAME does not exist or is not directory" >&2
    exit 1
fi

if [ ! -d $DESTINATION ] ; then
    echo "ERROR: $DESTINATION does not exist or is not a directory" >&2
    exit 1
fi

docker run --workdir /pipelines/$WORKFLOW_NAME --rm -v $(pwd):/pipelines quay.io/combattb/irida-builder:21.01 mvn clean install
cp $WORKFLOW_NAME/target/*.jar $DESTINATION
docker run --workdir /pipelines/$WORKFLOW_NAME --rm -v $(pwd):/pipelines quay.io/combattb/irida-builder:21.01 mvn clean
