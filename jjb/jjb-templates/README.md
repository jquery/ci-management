# JJB Templates

In this document we will explain the structure of each of our jjb templates
## jq-core-jobs.yaml

### Common Functions
#### job_boiler_plate
---
This anchor defines the basic structure to define a job:
* name: name for the job
* project-type: project type that will contain the job
* node: node where the job will be hosted
* branch: default branch name to download the source code
* submodule-recursive: this flag allows to traverse submodules recursively
* properties: this will contain more settings for the job like project name, amount of days to keep build logs and so on
* wrappers: more settings specifically for the infra wrapper
* publishers: define the publisher for this job