# IRIDA Plugin builder

The [build_workflow.sh](build_workflow.sh) script uses Docker and the
`quay.io/combattb/irida-builder:21.05` builder to build an IRIDA workflow
and copy the resulting jar to the output directory as specified
on the command line.

## Procedure for updating an IRIDA plugin

The Galaxy workflow `.ga` file can be converted to a IRIDA workflow format using [irida-wf-ga2xml](https://github.com/phac-nml/irida-wf-ga2xml). An example command is:

```bash

java -jar irida-wf-ga2xml-1.2.0-standalone.jar -n TBSampleReport -t VARIANT_CALLING -W 0.4.1 -o /tmp/wf -i Galaxy-Workflow.ga
```

This will create a `/tmp/wf` directory with a subdirectory named after the version number. Put the version-numbered directory in
`src/main/resources/workflows` of your workflow repository and take note of the UUID-style `<id>`. Copy the ID to the 
relevant Java file in `src/main/main/java/ca/corefacility/bioinformatics/irida/plugins` and copy the version number to the
`pom.xml` file in both the `<version>` and `<plugin.version>` fields. Note that the `irida-wf-ga2xml` will only create a 
`<sequenceReadsPaired>` input section in the `irida_workflow.xml` if you have an input of type `list:paired` in your
Galaxy workflow. If you are using single ended input, you need to manually put a `<sequenceReadsSingle>` section in the
`irida_workflow.xml`. E.g. `<sequenceReadsSingle>input_sequence</sequenceReadsSingle>` where `input_sequence` is the label
of your `list` type collection input for the Galaxy workflow. For more help, read the [IRIDA Pipeline Development docs](https://phac-nml.github.io/irida-documentation/developer/tools/pipelines/).

## Integrating the plugin builder with your workflow repository

To integrate this into a Github repository storing an IRIDA plugin, add this repository as a submodule called build in your repository, i.e. run:

```bash
git submodule add https://github.com/COMBAT-TB/irida-plugin-builder.git build
```

in the top level directory of your IRIDA plugin repository. Then add a Github Action like this [example](https://github.com/COMBAT-TB/irida-plugin-tb-sample-report/blob/main/.github/workflows/tb-sample-report-pipeline-plugin.yml). See the [TB Sample Report plugin](https://github.com/COMBAT-TB/irida-plugin-tb-sample-report) for a complete working example.

This will build a new release jar file of your workflow each time you push a tag to your Github repository.
