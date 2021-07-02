#!/bin/sh

ga_file=$1
workflow_dir=$2
version=$3
jar_file=$4

mkdir -p $workflow_dir
workflow-to-tools -w /pipelines/$ga_file -o $workflow_dir/tools_$version.yaml
/usr/lib/jvm/default-jvm/bin/jar uf $jar_filename $workflow_dir/tools_$version.yaml
rm -rf $workflow_dir
