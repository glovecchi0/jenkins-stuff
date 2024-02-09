# APPS directory

The folder contains:
- resources/jenkinsci/custom-helm-values.yaml.tpl -> the file that contains the [Jenkins Helm Chart](https://github.com/jenkinsci/helm-charts/blob/main/charts/jenkins/values.yaml) custom setups.
- resources/neuvector...
- Makefile -> the file contains a series of shortcuts for deploying NeuVector, NGINX, and Jenkins.

## Prerequisites

- a working Kubernetes cluster -> and consequently exports the [KUBECONFIG variable](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable)

**This configuration works perfectly in a Cloud environment with `containerd` container engines. This is because the NeuVector and NGINX services in LodaBalancer mode automatically create the LB on the Cloud platform used.**

**If you use a Kubernetes cluster with a different container engine, modify line 9 of the [Makefile](./Makefile). Ref. [here](https://github.com/neuvector/neuvector-helm/blob/master/charts/core/values.yaml#L545C1-L545C12)**

## How to install the tools

```bash
make install-neuvector
make install-ingress-nginx
make install-jenkins
```

## How to retrieve Jenkins admin password

```bash
make get-jenkins-admin-password
```

## How to update Jenkins configurations

```bash
make upgrade-jenkins
```

## How to delete the tools

```bash
make uninstall-jenkins
make uninstall-ingress-nginx
make uninstall-neuvector
```
