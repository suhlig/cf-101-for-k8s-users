% Cloud Foundry 101 for Kubernetes Users
% Oleksandr Slynko, Steffen Uhlig
%

## Who we are

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

![](eirini-arch.png)

This is what you get with Eirini!

# Eirini?

* Big idea: k8s as CF scheduler
* Staging is just another task
* bits-service turns droplets into OCI images

# k8s and CF - Common Ideas

- Declare the desired state of the world, and the platform will make it happen

#

![](cf-push-haiku.png)

# k8s and CF - Common Ideas

- YAML almost everywhere
- The app is in a container
- Everything is either an long-running process (LRP) or a task
- LRP is central: a process that
  * is monitored (and restarted if needed)
  * has health checks

# Concepts unique to CF

# `cf push`

* App dev cares only about the app bits
* Push to CF, it does the rest
* TBD

# Main focus on web apps

* Centered around HTTP
* No reason not to do generic TCP

# Droplet as intermediate build product

>* `app + buildpack = droplet`
>* `droplet + rootfs = image`
>* Operator can update the rootfs without asking app devs to push again

<aside class="notes">
Q: But why? You could build the image at push time.
</aside>

# Buildpack

* TBD
* Community or BYO

# CF is opinionated

* Roles
* Orgs
* Spaces
* Routing is done for you
* Services Marketplace

# How Kubernetes features map to CF

# Services

* 12factor apps consume services using Open Service Broker API
* k8s: BYO or manually bind

=> For BYO, check presentation of Herr Julz and Georgi

# Load balancing

* Apps run as containers on `cells` (worker nodes)

  => not exposed

. . .

* `gorouter =~ ingress controller + service`

  => nothing to configure for an app

. . .

* Apps get auto-registered when they come up

# Container placement

* Diego: purpose-built container scheduler; optimized for CF (across AZs)
* Eirini: schedule containers to run on a Kubernetes cluster
* Future: Conceptually, Eirini is not restricted to k8s (think Mesos, knative, etc)
* k8s: lots of ways to influence placement, not so much in CF

# Storage

* CF: Disk is ephemeral by default
* Possible with NFS and SMB (=> `persi`)
* Use object storage (or another CF service)

# Monitoring & Self-healing

* TODO
* CF: List health check types
* k8s: Readiness and Liveness probes

# Automated rollouts and rollbacks

* In k8s, we have Deployment
* Not really baked into CF, but trivial with external scripting
* Green/blue deployments are established patterns

<aside class="notes">
Deployment. Rollout strategy with upscaling new deployment and downscaling old one.
</aside>

# Secret and configuration management

* In k8s, we have secrets and config maps.
1. Service bindings auto-supply secrets via environment variables
1. User-provided environment variables allow anything else
1. Credhub etc. are also possible

<aside class="notes">
Deployment. Rollout strategy with upscaling new deployment and downscaling old one.
</aside>

# Batch execution

* In k8s, we have ... TODO
* Tasks

# Horizontal scaling

* In k8s, we have ... TODO
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

<aside class="notes">
TODO How to get and connect to a database
</aside>

# Update an existing app

Kubernetes:

CF:

# Scale an app

Kubernetes:

CF:

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
