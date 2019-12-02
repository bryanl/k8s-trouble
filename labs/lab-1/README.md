# Lab 1: installing an application

## Goal

Install an application into a Kubernetes cluster and review all the
the objects. After this lab, the the user should understand the basic 
parts of a Kubernetes application.

## Introduction

Kubernetes is a platform for building platforms. Another way of
explaining Kubernetes is that is an API that provides support for 
managing APIs. The APIs in Kubernetes are declarative: when you call
an API, you are modifying the desired configuration and Kubernetes as
a whole figures out the changes required to make the cluster match
the desired configuration.

In this lab, we will be installing a hello world application. The 
application is a web service that listens on a port. When a user of
the hello world application wants to interact with it, they issue 
a HTTP GET request to the application's port.

This application is built with multiple Kubernetes objects:

* Namespace
* Deployment
* Service
* Ingress

A namespace is a logical grouping in Kubernetes. To keep related
objects together, you might put them in a namespace. We are using 
namespaces to separate the different labs we will be working with.

A deployment is a workload. Workloads are objects that ultimately 
create pods. Kubernetes runs your applications from container images.
To control and manage the container images, Kubernetes can group
one or more containers together as a pod. Pods share process space,
and file systems. There are multiple types of workloads that be
used depending on the type of application you are running. In 
this case we are using a Deployment. A deployment creates additional
objects called replica sets. Replica sets manage pods.

A service allows traffic to reach your pods. It is a load balancer.

An ingress allows traffic external to your cluster to reach a service. 

## Setup

### 1. Install manifest for application

`$ kubectl apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-1/manifest.yaml`


## Lab

### Verify your application deployed

Run `curl http://app.local` or visit it in your web browser. You should 
receive a response from the application.

### Review the objects that were created

`$ kubectl -n lab-1 get all`

You should see something similar to the following output:

```text
NAME                               READY   STATUS    RESTARTS   AGE
pod/hello-world-659b5dbc8d-d4pvc   1/1     Running   0          20m


NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/hello-world   ClusterIP   10.102.244.115   <none>        8080/TCP   22m
service/kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP    24m


NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-world   1/1     1            1           22m

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-world-659b5dbc8d   1         1         1       22m
```

**Note** Not all objects will be listed when you run `kubectl get all`

You can retrieve an object from the cluster using `kubectl get`

To see the configuration for the deployment we created:

`$ kubectl -n lab-1 get deployment hello-world`

You can edit an object in the cluster using `kubectl edit`

To edit our deployment:

`$ kubectl -n lab-1 edit deployment hello-world`

### Clean up

When you are finish exploring, clean up your cluster:

`$ kubectl delete ns lab-1`
