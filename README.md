# Jenkins Stuff

Install Jenkins and automate things.

**The purpose of this repository is to simulate an environment that uses Jenkins as the centralizer of the various automation present in the organization.**

## How the repository is structured

```
.
├── apps/
│   └── ...
├── pipelines/
│   └── ...
└── README.md

```

`apps` is the folder that contains the logic for deploying Jenkins and the other necessary tools (for example, NGINX and NeuVector). Take a look at the [README](apps/README.md) file to understand what files are in the directory, how to install them, etc.

`pipelines` instead contains the definition of Jenkins' pipelines (Jenkinsfile and config.xml). Each pipeline covers a possible use case.

## Use cases covered

#### Scan for vulnerabilities of a Docker image using the NeuVector plugin -> [jenkins-stuff/scan-a-specific-docker-image](pipelines/scan-a-specific-docker-image/Jenkinsfile)
