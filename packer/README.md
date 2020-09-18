# CI Packer

[Packer][1] is a tool for automatically creating VM and container images,
configuring them and post-processing them into standard output formats.

## Building

You'll need to [install Packer][2]

The Packer configuration is divided into build-specific variables,
output-specific templates and a set of shared provisioning scripts. To do a
specific build, combine the template for the desired output artifact type with
a variable file. To build a new basebuild instance the following would be done:

```
packer build -var-file=vars/cloud-env.json -var-file=vars/centos.json templates/basebuild.json
```

**NOTE:** vars/cloud-env.json is a gitignored file as it contains private
information. There is a vars/cloud-env.json.example file that may be used as a
base for creating the one needed.

This would build a bootable image in the project's CI cloud environment.

### LF common-packer documentation

```
https://docs.releng.linuxfoundation.org/projects/common-packer/en/latest/index.html
```
