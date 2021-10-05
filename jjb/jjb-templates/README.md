# JJB Templates

In this document, we will explain the structure of each of our jjb templates
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
* properties: this will contain more settings for the job like project name, amount of days to keep build logs, and so on
* wrappers: more settings specifically for the infra wrapper
* publishers: define the publisher for this job

### Common Template
#### verify_boiler_plate
---
This is a standard template to verify the structure of a job:

* name: name for the job
* concurrent: Boolean value to set whether or not Jenkins can run this job concurrently. Defaults to false.

#### Module: scm
The SCM module allows you to specify the source code location for the project.
It adds the scm attribute to the Job definition, which accepts any number of scm definitions. 
It is also possible to pass [] to the scm attribute. This is useful when a set of configs has a global default scm and you want to a particular job to override that default with no SCM.
#### Macro: scm
#### Entry Point: jenkins_jobs.scm

Parameters as listed below:-

* url: (str) – URL of the bzr branch (required)
* refspec: (str) – refspec to fetch (default ‘+refs/heads/*:refs/remotes/remoteName/*’)
* branch: (list(str)) – list of branch specifiers to build (default ‘**’)
* recursive-submodules:	(bool)- Recursively update submodules (default false)
* choosing-strategy: (string) - Jenkins class for selecting what to build. Can be one of default,`inverse`, or gerrit (default ‘default’)
* jenkins-ssh-credential: credentials-id (str) – ID of credentials to use to connect (optional)
 
submodule (dict): 
* disable (bool) - By disabling support for submodules you can still keep using basic git plugin functionality and just have Jenkins to ignore submodules completely as if they didn’t exist.
* timeout (int) - Specify a timeout (in minutes) for submodules operations (default 10).


#### Module: triggers
Triggers define what causes a Jenkins job to start building.
#### Macro: trigger
#### Entry Point: jenkins_jobs.triggers

github-pull-request
* Build pull requests in github and report results. Requires the Jenkins GitHub Pull Request Builder Plugin.

Parameters as listed below:-

* trigger-phrase: (string) – when filled, commenting this phrase in the pull request will trigger a build (optional)
* only-trigger-phrase: (bool) – only commenting the trigger phrase in the pull request will trigger a build (default false)
* permit-all: (bool) – build every pull request automatically without asking (default false)
* github-hooks:	(bool) – use github hook (default false)
* auto-close-on-fail: (bool) – close failed pull request automatically (default false)
* white-list-target-branches: (list) – Adding branches to this whitelist allows you to selectively test pull requests destined for these branches only. Supports regular expressions (e.g. ‘master’, ‘feature-.*’). (optional)
