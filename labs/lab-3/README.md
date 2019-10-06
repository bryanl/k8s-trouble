# Lab 3: other tools for troubleshooting Kubernetes

## Goal

Explore more tools for troubleshooting Kubernetes.

## Introduction

Previously, we worked with`kubectl get` and `kubectl describe` to find information about 
cluster. In this lab, we'll explore `kubectl logs` and `kubectl exec`.

Sometimes, Kubernetes can't tell how your application is doing. Perhaps the issue
is actually in the code itself. 

## Setup

### 1. Launch k8s-lab shell

`$ k8s-lab shell`

### 2. Install manifest for application

`$ kubectl apply -f k apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-3/manifest.yaml`

## Lab

In this lab, your application isn't broken, but it is a bit temperamental. You will 
troubleshoot and attempt to fix the issues.

### Verify your application deployed

From the k8s-lab shell, run `curl http://app.local`. You should 
receive a response from the application. Your application will be happy or not. Try
the `curl` command a few times to see the different outputs.

### Working to make your application happy

Your application is temperamental and is backed by a deployment with two replicas.
According to your users, approximately 25% of the time, your application says it
is not happy. An unhappy application is not productive. How can you know what your
application is thinking?

You can view your application's logs using `kubectl logs`. These logs are created
from your container's STDOUT. Kubernetes will track these logs, so you can review
them later. There are also ways to forward your logs off a log service, but that
is beyond the scope of this workshop.

List your pods so you can know their names:

`$ kubectl -n lab-3 get pods`

```text
NAME                            READY   STATUS    RESTARTS   AGE
temperamental-8bd696687-54dnz   1/1     Running   0          12m
temperamental-8bd696687-8glzc   1/1     Running   0          12m
``` 

There are two pods running, so it isn't possible to know which pod will receive
traffic. To make it easier to debug this problem, you can use `kubectl` to scale
the replicas back to 1.

`$ kubectl -n lab-3 scale --replicas 1 deployment/temperamental`

Now when you list your pods, you should only see one:

`$ kubectl -n lab-3 get pods`

```text
NAME                            READY   STATUS    RESTARTS   AGE
temperamental-8bd696687-8glzc   1/1     Running   0          14m
```

Test your application to make sure it still returns traffic.

`$ curl http://app.local`

You can now view your pod's logs.

`$ kubectl -n lab-3 logs temperamental-8bd696687-8glzc`

You should see something similar to:

```text
time="2019-10-06T20:41:21Z" level=error msg="I'm not happy" status=0
time="2019-10-06T20:56:46Z" level=error msg="I'm not happy" status=1
time="2019-10-06T20:56:47Z" level=error msg="I'm not happy" status=1
```

It looks like your application is generating errors. 


### Interacting with a container using exec

Since you are an expert of this temperamental application, you know that you can 
stop the errors by giving it a pacifier. The pacifier in this case is an empty 
file at `/pacifier`.

The `kubectl exec` command allows you to run a command in a container. Let's create
the pacifier to sooth the temperamental application.

`$ kubectl -n lab-3 exec -it temperamental-8bd696687-8glzc touch /pacifier` 

Next, if you test your application, you should see that it is always happy.

`$ curl http://app.local`

**Exactly what happened?**

`kubectl exec` can tunnel a connection right into a container. You can run a
command, or if the pod has a shell, you can create a shell session. 

`$ kubectl -n lab-3 exec -it temperamental-8bd696687-8glzc sh`

You can navigate through the pod's filesystem, inspect network connections,
and processes using this shell. When you are done with the shell, exit with
`exit` or `<ctrl>-d`

### Logs from multiple pods

`kubectl` does not support logs from multiple containers at once, but there 
is a solution. You can use [stern](https://github.com/wercker/stern) to view
multiple containers at once.

First, scale your deployment up to multiple pods

`$ kubectl -n lab-3 scale --replicas 3 deployment/temperamental`

In another terminal, launch another k8s-lab shell. 

`$ k8s-lab shell`

In the second shell, launch stern:

`$ stern -n lab-3 temperamental`

This command views all logs in all containers in pods that start with
`temperamental`

Back in your first shell, send requests to your app:

`$ curl http://app.local`

Stern is a great tool for getting access to your logs. There are multiple 
options and flags you can use to customize it to your needs.

### Clean up

When you are finish exploring, clean up your cluster:

`$ kubectl delete ns lab-3`
