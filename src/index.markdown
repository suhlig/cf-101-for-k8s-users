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

<aside class="notes">
Also invisible parts like policies, maybe config in config maps, maybe service accounts.
Plus deployment configuration - Docker image
* The problem? There is not one, but 10 or even thousands of them.
</aside>

#

![](sample_app_multi.jpg)

<aside class="notes">
* From a k8s view, they are mostly all the same
* What do people do? Copy and paste yaml
</aside>

# The answer?

Cloud Foundry!

#

![](cf-push-haiku.png)

<aside class="notes">
* Alex: But I already have my existing k8s cluster! Do I need even more infra?
* Steffen: A year ago, the answer was yet. But now, we have something new!
</aside>

#

![](cf-push-eirini.png)

<aside class="notes">
*
</aside>

# Eirini

* Big idea: k8s as CF scheduler
* Staging is just another task
* bits-service turns droplets into OCI images


<aside class="notes">
or CF as K8s simplifier

What is staging?
What is bit service and droplets?
</aside>
#

![](eirini-arch.png)

<aside class="notes">
* This is what you get with Eirini!
* There are other talks with more details
<aside>

# k8s and CF - Common Ideas

- Declare the desired state of the world
- The platform will make it happen

# k8s and CF - Common Ideas

- YAML almost everywhere
- The app is in a container
- Everything is either an long-running process (LRP) or a task
- LRP is central: a process that
  * is monitored (and restarted if needed)
  * has health checks

# Concepts unique to CF

# CF is opinionated

* Orgs
* Spaces
* Roles
* Routing
* Marketplace for services

# `cf push`

* App dev cares only about the app bits
* Push to CF, it does the rest
* It's all about the UX

# Main focus on web apps

* Centered around HTTP
* No reason not to do generic TCP

<aside class="notes">
Generic TCP is not that common
</aside>

# Buildpacks (1)

* Standardized way to build app images
* Everything needed to turn your app's source code into a webapp listening on port `8080`
* Makes it easy to update versions of the packages (dependencies) of the app

# Buildpacks (2)

* Language specific
* Community or BYO

  Django, Perl, C++, TomEE, Eclipse Virgo, Jetty, Clojure, Haskell, Python, Zend Server (PHP), Null, JBoss, WebSphere Liberty, Erlang, Elixir, Swift, ...

<aside class="notes">
- static website? nginx
- Ruby apps? Interpreter + bundler
- Java? Maven, Tomcat, etc.

Alex: What about Docker image?
Does buildpack builds an image?
</aside>

# Droplet as intermediate build product

>* `app + buildpack = droplet`
>* `droplet + rootfs = image`
>* Operator can update the rootfs without asking app devs to push again

<aside class="notes">
Q: But why? You could build the image at push time.
</aside>

# How Kubernetes features map to CF

# Application access

* In K8s, application run as containers inside pods on worker nodes
* In CF, apps run as containers on `cells`

<aside class="notes">
cells == worker nodes
</aside>

# Application access

* In K8s, services provide load balancing
  * can be exposed via NodePort, Load Balancer or Ingress
* In CF, `gorouter` load balances and exposes application
  * Apps get auto-registered when they come up
  * Nothing to configure for an app

<aside class="notes">
CF is opinionated, always use $PORT (mostly 8080)
</aside>

# Access to databases

* In K8s, you bring your own services, or deploy ServiceCatalog
* In CF, apps consume services using Open Service Broker API

# BYO

Check out this talk:

> ["Microservices With Cloud Foundry and Kubernetes" by Julian Skupnjuak & Georgi Dankov](https://sched.co/KJCr)

<aside class="notes">
May want to watch the recording, as it is going as we speak
</aside>

# Secret and configuration management

* Is K8s, we have secrets and config maps.
* In CF:
  1. Service bindings auto-supply secrets via environment variables
  1. User-provided environment variables allow anything else

<aside class="notes">
* Service catalog in Kubernetes.
* Config maps create config file on disk
</aside>

# Container placement

* In K8s, lots of ways to influence placement
* In CF, not much influence
  * the default scheduler `Diego` does it for you

<aside class="notes">
K8s: affinity and antiaffinity groups based on labels and other applications, custom schedulers, based on node labels, priorities
CF: Isolation segments
</aside>

# Storage

* In K8s, there are many options
* In CF, disk is ephemeral by default
  * Possible with NFS and SMB (=> `persi`)
  * Use object storage (or another CF service)

<aside class="notes">
K8s: provider-native storage, local disk, NFS, etc
</aside>

# Monitoring & Self-healing

* In K8s, there are readiness and liveness probes
* CF: http, port, process

<aside class="notes">
* TODO Alex: some more details about K8s. Exec command on container, http-Get or TCP Socket
* There is no healing, just restart
</aside>

# Automated rollouts and rollbacks

* In K8s, there are `deployments`
* In CF, it does not really exist
  - trivial with external scripting
  - Green/blue deployments are established patterns

<aside class="notes">
Deployment. Rollout strategy with upscaling new deployment and downscaling old one. Possible to rollback to previous version
Zero-downtime deployments as a command is in beta
</aside>

# Batch execution

* In K8s, we have `Jobs`, pre-start scripts, init containers
* In CF, we have `Tasks`

# Horizontal scaling

* In K8s, we have `kubectl scale deployment`
* In CF, we use `cf scale`
  * The platform will ensure your app gets sufficient instances

# How workflows map

* In K8s, mostly operator-centric (control plane)
* In CF, we have pretty good separation between
  1. app-deployer
  1. platform operator

# Typical App Developer Workflows

# Deploy a new app in Kubernetes

>1. Create a Docker image
>1. Push docker image to registry
>1. Get credentials for database and put them to secret
>1. Create a Kubernetes spec file with multiple YAML
>1. Apply this file
>1. `kubectl deployment rollout status --watch`

<aside class="notes">
I usually find and copy something from existing Dockerfile
Most of databases for Kubernetes use operators or helm. They create credentials in secrets. And you can pass some property to create a database.
Again copy: service, deployment, pod security policy, networking policy, ingress

</aside>

# Deploy a new app in CF

`cf push`

`cf bind-service*`

<aside class="notes">
* Only if you connect to a database
</aside>

# Update an existing app in K8s

>1. Update Docker image
>1. Push docker image to registry
>1. Change spec to use new image
>1. Apply spec

<aside class="notes">
For production I have pipeline that will do it for me, but for development workflow I have to do
</aside>
# Update an existing app in CF

`cf push`

# Getting Started

* Use a public CF provider
  - perhaps PWS or IBM Cloud?
* Deploy it yourself

# Thanks!

`@alex_sly`

`@suhlig`

`http://cf101k8s.eirini.cf`

# Eirini Sessions

#include eirini-sessions.markdown

# Meta

<div class="mini">
  Rev.
  #include ../gpp/.dirty

  <br/>
  built on
  #exec TZ=UTC date +"%Y-%m-%d %T %Z"
 </div>
