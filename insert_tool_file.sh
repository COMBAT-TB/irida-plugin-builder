#!/bin/sh -x

if [ $# != 4 ] ; then
  echo "Need 4 parameters, got: $*" >&2
  exit 1
fi

ga_file=$1
workflow_dir=$2
version=$3
jar_filename=$4

workflow-to-tools -w /pipelines/$ga_file -o $workflow_dir/tools_$version.yaml
/usr/lib/jvm/default-jvm/bin/jar uf $jar_filename $workflow_dir/tools_$version.yaml
rm $workflow_dir/tools_$version.yaml