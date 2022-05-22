#!/bin/sh -x

set -e

if [ $# != 4 ] ; then
  echo "Need 4 parameters, got: $*" >&2
  exit 1
fi

ga_file=$1
workflow_dir=$2
version=$3
jar_filename=$4

mkdir -p $workflow_dir
workflow_name=$(python3 -c 'import json; import sys; import shlex; data = json.load(open(sys.argv[1])); print(shlex.quote(data["name"]))' $ga_file) 

workflow-to-tools -l Workflow_tools -w /pipelines/$ga_file -o $workflow_dir/tools.yaml
/usr/lib/jvm/default-jvm/bin/jar uf $jar_filename $workflow_dir/tools.yaml
rm $workflow_dir/tools.yaml
num_files=`ls $workflow_dir | wc -l`
if [ $num_files -eq 0 ] ; then
  # remove empty workflow_dir
  rmdir $workflow_dir
fi
