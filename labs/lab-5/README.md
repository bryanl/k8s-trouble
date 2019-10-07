# Lab 3: 

## Goal

Explore situations where Kubernetes kills your pods

## Introduction

Kubernetes has resource management. It can limit the CPU and
memory used by a pod. How can you diagnose and fix pod limit
issues?

## Setup

### 1. Launch k8s-lab shell

`$ k8s-lab shell`

### 2. Install manifest for application

`$ kubectl apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-5/manifest.yaml`

## Lab

In this lab, you will see what happens when Kubernetes kills your pods.

### Verify your application deployed

From the k8s-lab shell, run `curl http://app.local`. It should not work.

### Clean up

When you are finish exploring, clean up your cluster:

`$ kubectl delete ns lab-5`
