# Kubernetes Troubleshooting Workshop

## Setup

### 0. Prerequisites

This lab requires a working Kubernetes installation. The lab assumes you are using minikube.

Getting started directions live at https://minikube.sigs.k8s.io/docs/start/

Update your current Kubernetes context to be minikube

```sh
$ kubectl config use-context minikube 
```

### 1. Verify installation

Run `kubectl get nodes` from inside your lab shell. If 
two nodes are returned, your lab is configured correctly

### 2. Setup an `ingress`

```sh
$ minikube addons enable ingress
```

### 3. Setup metrics

In your shell, run `./lab-scripts/init-metrics.sh`. This 
command sets up a metrics server on your cluster.

### 4. Set up hosts

To make accessing the cluster easier, add `app.local` to your hosts file.

* windows: C:\Windows\System32\Drivers\etc\hosts
* others: /etc/hosts

You can get the IP with `minikube ip`

eg

```sh
172.16.55.222 app.local
```
