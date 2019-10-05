# Lab 2: troubleshooting applications running in Kubernetes

## Goal

Learn about common tools available to help you troubleshoot your
applications

## Introduction

Kubernetes has a command `kubectl` to allow you to work with your 
Kubernetes clusters. This tool contains many functions, but for 
troubleshooting, you'll be most interested in these three:
* get
* describe
* logs

## Setup

### 1. Launch k8s-lab shell

`$ k8s-lab shell`

### 2. Install manifest for application

`$ kubectl apply -f k apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-2/manifest.yaml`


## Lab

In this lab, your application is broken. You will troubleshoot and 
fix the issues.

### Verify your application deployed

From the k8s-lab shell, run `curl http://app.local`. This time,
the application is broken? But where?  

### Review the objects that were created

`$ kubectl -n lab-2 get all`

You should see something similar to the following output:

```text
NAME                               READY   STATUS             RESTARTS   AGE
pod/hello-world-7b994b6bcf-9h4sj   0/1     ImagePullBackOff   0          23s


NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/hello-world   ClusterIP   10.109.57.215   <none>        8080/TCP   15m


NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-world   0/1     1            0           15m

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-world-5fb5fc4557   0         0         0       15m
replicaset.apps/hello-world-7b994b6bcf   1         1         0       23s
```

**Note** Not all objects will be listed when you run `kubectl get all`

### Figure out what to do next


```text
┌────────────┐      ┌────────────┐     
│            │      │            │     
│  Ingress   │─────▶│  Service   │     
│            │      │            │     
└────────────┘      └────────────┘     
                          │            
                  ┌───────┘            
                  ▼                    
           ┌────────────┐              
           │            │              
        ┌─▶│    Pods    │              
        │  │            │              
        │  └────────────┘              
        │                              
        │                              
 ┌─────────────┐         ┌────────────┐
 │             │         │            │
 │ Replica Set │◀────────│ Deployment │
 │             │         │            │
 └─────────────┘         └────────────┘
```

In `Lab 1`, we learned that deployments create pods through 
replica sets, and pods run the containers which comprise our 
application. First, let's ensure application is running.

You'll notice the pod has an `ImagePullBackOff` status. This means that
Kubernetes was not able to retrieve your image. Let's take a closer
look:

`$ kubectl -n lab-2 get pod/hello-world-7b994b6bcf-9h4sj`

```text
NAME                           READY   STATUS             RESTARTS   AGE
hello-world-7b994b6bcf-9h4sj   0/1     ImagePullBackOff   0          2m6s
```

This view is a summary, but there are ways to get more detail:

`$ kubectl -n lab-2 get pod/hello-world-7b994b6bcf-9h4sj -o wide`

```text
NAME                           READY   STATUS             RESTARTS   AGE     IP            NODE             NOMINATED NODE   READINESS GATES
hello-world-7b994b6bcf-9h4sj   0/1     ImagePullBackOff   0          4m30s   10.244.1.11   k8s-lab-worker   <none>           <none>
```

You can use `-o wide` to retrieve more details from `kubectl get`

This still doesn't show us what the problem is. `kubectl get`
can output YAML as well. The actual object in the cluster may
give us more clues on why this is failing.

`$ kubectl -n lab-2 get pod/hello-world-7b994b6bcf-9h4sj -o yaml`

```text
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2019-10-05T15:57:28Z"
  generateName: hello-world-7b994b6bcf-
  labels:
    lab: lab-2
    pod-template-hash: 7b994b6bcf
  name: hello-world-7b994b6bcf-9h4sj
  namespace: lab-2
  ownerReferences:
  - apiVersion: apps/v1
    blockOwnerDeletion: true
    controller: true
    kind: ReplicaSet
    name: hello-world-7b994b6bcf
    uid: d1730f8e-4bfa-496c-8ee1-699902988a97
  resourceVersion: "8116"
  selfLink: /api/v1/namespaces/lab-2/pods/hello-world-7b994b6bcf-9h4sj
  uid: 9654bf37-103d-40e1-9668-3813b1896731
spec:
  containers:
  - image: docker.io/bryanl/k8st-hello-world:missing
    imagePullPolicy: Always
    name: app
    ports:
    - containerPort: 8080
      name: http
      protocol: TCP
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: default-token-k9d46
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: k8s-lab-worker
  priority: 0
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: default-token-k9d46
    secret:
      defaultMode: 420
      secretName: default-token-k9d46
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    message: 'containers with unready status: [app]'
    reason: ContainersNotReady
    status: "False"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    message: 'containers with unready status: [app]'
    reason: ContainersNotReady
    status: "False"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - image: docker.io/bryanl/k8st-hello-world:missing
    imageID: ""
    lastState: {}
    name: app
    ready: false
    restartCount: 0
    state:
      waiting:
        message: Back-off pulling image "docker.io/bryanl/k8st-hello-world:missing"
        reason: ImagePullBackOff
  hostIP: 172.17.0.2
  phase: Pending
  podIP: 10.244.1.11
  qosClass: BestEffort
  startTime: "2019-10-05T15:57:28Z"
``` 

This is the raw object as maintained by the Kubernetes API. There is 
lots of information in here. Most objects contain a status stanza:

```text
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    message: 'containers with unready status: [app]'
    reason: ContainersNotReady
    status: "False"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    message: 'containers with unready status: [app]'
    reason: ContainersNotReady
    status: "False"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2019-10-05T15:57:28Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - image: docker.io/bryanl/k8st-hello-world:missing
    imageID: ""
    lastState: {}
    name: app
    ready: false
    restartCount: 0
    state:
      waiting:
        message: Back-off pulling image "docker.io/bryanl/k8st-hello-world:missing"
        reason: ImagePullBackOff
  hostIP: 172.17.0.2
  phase: Pending
  podIP: 10.244.1.11
  qosClass: BestEffort
  startTime: "2019-10-05T15:57:28Z"
```

The status stanza typically contains the current status for the object.
These are fields are general object specific, so this output is pod
specific. This output is not made for humans. It does contain a clue
of why our pod isn't starting, but is not the best view.

You can also use `kubectl describe` to describe an object in a format
that is easier for humans to understand

`$ kubectl -n lab-2 describe pod/hello-world-7b994b6bcf-9h4sj`

```text
Name:           hello-world-7b994b6bcf-9h4sj
Namespace:      lab-2
Priority:       0
Node:           k8s-lab-worker/172.17.0.2
Start Time:     Sat, 05 Oct 2019 15:57:28 +0000
Labels:         lab=lab-2
                pod-template-hash=7b994b6bcf
Annotations:    <none>
Status:         Pending
IP:             10.244.1.11
Controlled By:  ReplicaSet/hello-world-7b994b6bcf
Containers:
  app:
    Container ID:
    Image:          docker.io/bryanl/k8st-hello-world:missing
    Image ID:
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-k9d46 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-k9d46:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-k9d46
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason     Age                     From                     Message
  ----     ------     ----                    ----                     -------
  Normal   Scheduled  9m49s                   default-scheduler        Successfully assigned lab-2/hello-world-7b994b6bcf-9h4sj to k8s-lab-worker
  Normal   Pulling    8m17s (x4 over 9m48s)   kubelet, k8s-lab-worker  Pulling image "docker.io/bryanl/k8st-hello-world:missing"
  Warning  Failed     8m17s (x4 over 9m45s)   kubelet, k8s-lab-worker  Failed to pull image "docker.io/bryanl/k8st-hello-world:missing": rpc error: code = Unknown desc = failed to resolve image "docker.io/bryanl/k8st-hello-world:missing": no available registry endpoint: docker.io/bryanl/k8st-hello-world:missing not found
  Warning  Failed     8m17s (x4 over 9m45s)   kubelet, k8s-lab-worker  Error: ErrImagePull
  Warning  Failed     8m5s (x6 over 9m45s)    kubelet, k8s-lab-worker  Error: ImagePullBackOff
  Normal   BackOff    4m47s (x20 over 9m45s)  kubelet, k8s-lab-worker  Back-off pulling image "docker.io/bryanl/k8st-hello-world:missing"
```

**Question** Based on the output from `kubectl describe`, what's the
problem? 

It would appear that there is a problem retrieving the image from the
container registry. You can edit the deployment to update the image
to the proper one.

`$ kubectl -n lab-2 set image deployment/hello-world app=docker.io/bryanl/k8st-hello-world:latest`

Next, we check if we have a working pod:

`$ kubectl -n lab -2 get pods -l lab=lab-2`

```text
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-798cfdf84b-x2npz   1/1     Running   0          66s
```

Now, let's try to view our website again:

`$ curl http://app.local`

It still doesn't work.

### Configuration triage

One the application looks to be running correctly, you'll have to 
review your objects to find the problem.

From our diagram above, you'll remember, the traffic goes:

Ingress -> Service -> Pods

#### Ingress

So let's start with the ingress. As you learned earlier, you can use
`kubectl get` and `kubectl describe` to view objects in the cluster.

`$ kubectl describe ingress/hello-world`

```text
Name:             hello-world
Namespace:        lab-2
Address:
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host       Path  Backends
  ----       ----  --------
  app.local
                hello-woerld:8080 (<none>)
Annotations:
  kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"extensions/v1beta1","kind":"Ingress","metadata":{"annotations":{},"labels":{"lab":"lab-2"},"name":"hello-world","namespace":"lab-2"},"spec":{"rules":[{"host":"app.local","http":{"paths":[{"backend":{"serviceName":"hello-world","servicePort":8080}}]}}],"tls":null}}

Events:  <none>
```

You'll notice that there are no errors here. Kubernetes checks your
objects against a schema to ensure they are correct, but it does
not check the values to make sure they are correct.

There is a typo in the backend for the ingress. This means that the
ingress has no idea what service it should be routing to. You can edit
the ingress to fix the typo.

`$ kubectl edit ingress/hello-world`

Change `hello-woerld` to `hello-world`. When you exit the editor,
the changes will be applied to the cluster immediately.

Now, let's try to view our website again:

`$ curl http://app.local`

It still doesn't work. But there is an error message now, so our 
change did do something. This is a message from the service controller.
It's saying that the service has no pods available to load balance 
traffic to. We verified that we have pods running earlier, so the
service is not configured incorrectly.

#### Service

Services route traffic to pods, but not directly. There is another
object that acts as an intermediary and it is called an endpoint.

`$ kubectl -n lab-2 get endpoints/hello-world`

```text
NAME          ENDPOINTS   AGE
hello-world   <none>      49m
```

There should be endpoints which point to our pods. The way that 
services know what pods to send traffic is a selector. A selector
is a set of pod labels that will receive traffic. We can use 
`kubectl get` to retrieve the labels for our pod:

`$ kubectl -n lab-2 get pods/hello-world-798cfdf84b-x2npz -o=jsonpath='{.metadata.labels}{"\n"}'`

```text
map[lab:lab-2 pod-template-hash:798cfdf84b]
```

This command gets our pod and then uses JSONpath to extract output. 

'{.metadata.labels}{"\n"}'

This says to navigate through the object to the metadata and then inside 
of metadata, return labels. (the "\n" at the end inserts a new line so
the output is easier to read)

According to the output, our pod has two labels (`lab:lab-2` and 
`pod-template-hash:798cfdf84b`). The `pod-template-hash` label is 
maintained by Kubernetes, so we should not touch that one. We use 
`lab:lab-2` as a selector to route traffic to this pod.

If we describe our service, we can see what selectors are configured:

`$ kubectl -n lab-2 describe service/hello-world`

```text
Name:              hello-world
Namespace:         lab-2
Labels:            lab=lab-2
Annotations:       kubectl.kubernetes.io/last-applied-configuration:
                     {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"lab":"lab-2"},"name":"hello-world","namespace":"lab-2"},"spec"...
Selector:          labe=lab-2
Type:              ClusterIP
IP:                10.109.57.215
Port:              <unset>  8080/TCP
TargetPort:        8080/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>
```

Notice that the selectors configured have a typo. You can use 
`kubectl edit service/hello-world` to fix this typo.

With this change, let's review the endpoints again:

`$ kubectl -n lab-2 get endpoints/hello-world`


```text
NAME          ENDPOINTS          AGE
hello-world   10.244.1.13:8080   60m
```

Now, let's try to view our website again:

`$ curl http://app.local`

It should work and your website is up and functioning again.
