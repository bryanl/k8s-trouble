# Lab 4: exploring your cluster visually

## Goal

Use Octant to explore your cluster in your browser.

## Introduction

In the previous labs, we worked with `kubectl` and `stern` to explore
your cluster. In many cases, these tools are sufficient, but as you
have learned, troubleshooting might not be intuitive at first.

VMware (Bryan and team) created Octant to allow you to explore your clusters
visually in your web browser.

## Setup

### 1. Install manifest for application

`$ kubectl apply -f https://raw.githubusercontent.com/bryanl/k8s-trouble/master/labs/lab-4/manifest.yaml`

### 1. Launch Octant

> Octant must be installed to complete this lab. The installation directions live at https://github.com/vmware-tanzu/octant#installation.

On your computer, launch Octant:

`$ octant`

## Lab

In this lab, your application is broken. You will troubleshoot and 
fix the issues with Octant and `kubectl`. 

## Notes

### Editing objects

`kubectl -n lab-4 edit kind/name`

### Clean up

When you are finish exploring, clean up your cluster:

`$ kubectl delete ns lab-4`
