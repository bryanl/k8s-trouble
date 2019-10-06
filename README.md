# Kubernetes Troubleshooting Workshop

## Setup

### 0. Prerequisites

This lab requires Docker >= 1.19. 

### 1. Download k8s-lab

Download k8s-lab from https://github.com/bryanl/k8s-lab/releases/tag/v0.1.0.
Ensure you get the version that matches your computer's operating system.

### 2. Extract the archive into a directory

It doesn't matter where you extract the archive.

### 3. Initialize your lab environment

`$ k8s-lab init`

### 4. Start a shell using k8s-lab

`$ k8s-lab shell`

### 5. Verify installation

Run `kubectl get nodes` from inside your lab shell. If 
two nodes are returned, your lab is configured correctly

### 6. Setup an `ingress`

In your shell, run `./lab_scripts/init-ingress.sh`. This 
command allows you to send traffic to your cluster.

### 7. Setup metrics

In your shell, run `./lab_scripts/init-metrics.sh`. This 
command sets up a metrics server on your cluster.

## k8s-lab

`k8s-lab` creates local Kubernetes environment on your computer. It 
also contains utilities for interacting with Kubernetes.


## Removing k8s-lab

Run `$ k8s-lab delete` to remove the cluster from your computer.
