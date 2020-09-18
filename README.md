# Continuous Integration for JQuery at LF

This repository has templates that generate jobs in the Linux Foundation Jenkins
instance using the Jenkins Job Builder. For more information about that tool
please see:

    https://docs.openstack.org/infra/system-config/jjb.html

## Template design

Jenkins jobs are generated from standard Global JJB templates and from
custom-to-project JJB templates.

## Global JJB templates

Global JJB jobs originated with the Open Daylight project and reflect CI/CD
design choices made there. Global JJB templates are used as much as possible in
JQuery. As of this writing this includes CLM, RST/RTD documentation, javadoc,
simple Maven/Java jar jobs and some Python jobs.

Documentation of Global JJB templates can be found here:

    http://global-jjb.releng.linuxfoundation.org/en/latest/index.html

## Get access to the Jenkins Sandbox

The Sandbox provides a testing/experimentation environment used before pushing
job templates to the production instance.

To access the Sandbox use: https://jenkins.openjsf.org/sandbox

The access to the Sandbox uses the same LFID used in the production Jenkins
instance, but in this case a new Helpdesk ticket needs creation to request the
sandbox access.

## LF Helpdesk / Service Desk

The service desk is a support platform for administrative and infrastructure
issues requiring input or action from members of the Linux Foundation IT staff.

To access the LF Helpdesk use: https://support.linuxfoundation.org

For help opening a support ticket use:
https://docs.releng.linuxfoundation.org/en/latest/helpdesk.html

## Testing the templates

These instructions explain how to test the JQuery templates using the Jenkins
sandbox. This catches errors before submitting the changes as Gerrit reviews.

Prerequisites:

Install the Jenkins job builder:

    pip install --user jenkins-job-builder

Check out the global JJB templates submodule within this repo:

    git submodule update --init

### Test Locally

Check sanity by running the Jenkins job-builder script in this directory:

    jenkins-jobs test -r jjb

### Deploy the templates to the Jenkins sandbox

Login (after requesting membership in group jquery-jenkins-sandbox-access) at
the Jenkins sandbox:

    https://jenkins.openjsf.org/sandbox

Get the authentication token from the sandbox:
a) click on your user name (top right)
b) click Configure (left menu)
c) click API Token (button)

Create a config file jenkins.ini using the following template and your
credentials

(user name and API token from above):

    [job_builder]
    ignore_cache=True
    keep_descriptions=False
    recursive=True

    [jenkins]
    query_plugins_info=False
    url=https://jenkins.openjsf.org/sandbox
    user=YOUR-USER-NAME
    password=YOUR-API-TOKEN

Build and deploy a specific job using the EXACT job name.

    jenkins-jobs --conf jenkins.ini update -j jjb your-job-name-here

Examples:

    jenkins-jobs --conf jenkins.ini update -j jjb <job_name>

In the sandbox visit the job page, then click the button
"Build with parameters" in left menu.
