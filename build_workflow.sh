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

IRIDA_BUILD_VERSION=21.05
docker run --workdir /pipelines/$WORKFLOW_NAME --rm -v $(pwd):/pipelines quay.io/combattb/irida-builder:$IRIDA_BUILD_VERSION mvn clean install
jar_count=$(ls $WORKFLOW_NAME/target/*.jar |wc -l)
if [ $jar_count -gt 1 ] ; then
  echo "WARNING: more than one output jar, some build steps will not run" >& 2
else
  jar_filename=$(ls $WORKFLOW_NAME/target/*.jar)
  version=$(grep '<plugin.version>' $WORKFLOW_NAME/pom.xml  |sed -r 's/.*>([^<]*)<.*/\1/')
  ga_file=$WORKFLOW_NAME/src/main/resources/workflows/$version/irida_workflow_structure.ga
  workflow_dir=$WORKFLOW_NAME/workflows/$version
  docker run --workdir /pipelines/$WORKFLOW_NAME --rm -v $(pwd):/pipelines quay.io/combattb/irida-builder:$IRIDA_BUILD_VERSION sh /insert_tool_file.sh $ga_file $workflow_dir $version $jar_filename
fi

cp $WORKFLOW_NAME/target/*.jar $DESTINATION
docker run --workdir /pipelines/$WORKFLOW_NAME --rm -v $(pwd):/pipelines quay.io/combattb/irida-builder:$IRIDA_BUILD_VERSION mvn clean
