# [Cloud Foundry 101 for Kubernetes Users](https://cfna19.sched.com/event/KJCK/cloud-foundry-101-for-kubernetes-users-steffen-uhlig-ibm-oleksandr-slynko-pivotal)

Steffen Uhlig, IBM & Oleksandr Slynko, Pivotal

Track: Cloud Foundry 101: Getting Started
Experience Level: Beginner

Wednesday, April 3 • 5:15pm - 5:45pm

# Abstract

This talk will take Kubernetes users from “zero to hero” with Cloud Foundry. Kubernetes is fantastic, but since you are at CF Summit you are probably tempted by the Cloud Foundry promise of letting you “just push code” and not worry about the details of containers, and scheduling, and scaling. But Cloud Foundry does still have a learning curve -- this talk is here to help you over it!

Kubernetes is meant to be used by operators, not developers. Developers shouldn’t need to care about the inner workings of Kubernetes such as Pods, Services, StatefulSets, Ingresses and how to use and configure them just to get their application running, right? This is where Cloud Foundry comes in.

In this talk, we will explore what Kubernetes users need to know when using Cloud Foundry. We’ll get familiar with CF's own container scheduler -Diego- and its differences with Kubernetes. We will also look at how, using Eirini, you can get up and running with CF on your existing Kubernetes cluster with a couple of helm installs. And we’ll compare, hands-on, the effort it takes to bring up an application from scratch in both Cloud Foundry and Kubernetes and see it running in the cloud!

# High-level Story

* Describe a "typical" k8s deployment with some pods, some are services, some are the app
* Talk about a few of the characteristics, how to scale, how to configure, etc.
* TADAAA: This is what you get when pushing an app with CF and Eirini
* Look at a few of the components and what role they fulfill on both sides, CF and k8s

# Key Take-Away Points

--

Old

* Comparison
* Deploy app
  CF vs. k8s
* which parts do what
* create a service, scale
* push an app, scale it

CF: we care about the app, just consume services
k8s: wants control, smaller size, very configurable, very popular

# TODO / Optional

* maybe show YAML of plain k8s deployment
* split the image into two (deployment vs. runtime)
* pod disruption budget => not really required in inCF
* anything unique to k8s that is worth mentioning?
* Alex may have a comparison table CF vs. k8s
* Stuff you shouldn't do in CF (and why you might no need it)
