# Lab 3: other tools for troubleshooting Kubernetes

## Goal

Explore more tools for troubleshooting Kubernetes.

## Introduction

## Setup

### 1. Launch k8s-lab shell

`$ k8s-lab shell`

### 2. Install manifest for application

`$ kubectl apply -f k apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-3/manifest.yaml`

## Lab

### Verify your application deployed

From the k8s-lab shell, run `curl http://app.local`. You should 
receive a response from the application.

