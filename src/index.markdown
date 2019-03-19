% Cloud Foundry 101 for Kubernetes Users
% Oleksandr Slynko, Steffen Uhlig
%

# Who we are

- Oleksandr Slynko
  * Pivotal
  * #eirini, previously #cfcr

- Steffen Uhlig
  * IBM
  * `#eirini`, `#ruby`, previously `#bits-service`

# A Typical k8s deployment?

#

![](sample_app.jpg)

# Surprise!

This is what you get with Eirini!

# Eirini?

* (spend 5 minutes explaining Eirini)

# k8s and CF - Common Ideas

- Declare the desired state of the world, and the platform will make it happen

  ![](cf-haiku)

- TBD

# Concepts unique to CF

# Main focus on web apps

* Centered around HTTP
* No reason not to do generic TCP
* The app is an LRP

# Droplet as intermediate build product

* `app + buildpack = droplet`
* `droplet + rootfs = container`
* Operator can update the rootfs without asking app devs to push again

# Services Marketplace

TBD

# Roles, Orgs, Spaces

TBD

# How Kubernetes features map to CF

# Service discovery

* 12factor apps
* Open Service Broker API

# Load balancing

* Apps run as containers on `cells` (worker nodes)

  => not exposed

. . .

* `gorouter =~ ingress controller + load balancer`

  => nothing to configure for an app

. . .

* Apps get auto-registered when they come up

# Container placement

* Diego: purpose-built container scheduler; optimized for CF
* Eirini: schedule containers to run on a Kubernetes cluster
* Future: Conceptually, Eirini is not restricted to k8s (think Mesos, knative, etc)

# Storage

* Possible, but not encouraged
* Use object stores

# Monitoring & Self-healing

* TBD

# Automated rollouts and rollbacks

* Not really baked into CF, but trivial with external scripting
* Green/blue deployments are established patterns

# Secret and configuration management

1. Service bindings auto-supply secrets via environment variables
1. User-provided environment variables allow anything else

# Batch execution

* Tasks

# Horizontal scaling

* `cf scale`
* The platform will ensure your app gets sufficient instances

# How Kubernetes workflows map to CF

* Kubernetes: mostly operator-centric (control plane)
* CF has pretty good separation between
  1. app-deployer
  1. platform operator

# Typical App Developer Workflows

# Deploy a new app

Kubernetes:

CF:

# Update an existing app

Kubernetes:

CF:

# Bind a service

Kubernetes:

CF:

# Scale an app

Kubernetes:

CF:

# TBD Any more that are interesting?

# Thanks!

`@alex_sly`

`@suhlig`

<div class="mini">
  Rev.
  #include ../gpp/.dirty

  <br/>
  built on
  #exec TZ=UTC date +"%Y-%m-%d %T %Z"
 </div>
