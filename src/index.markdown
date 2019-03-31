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

<aside class="notes">
Speaker: Steffen, then Alex
</aside>

# K8s Application

>![](sample_app.jpg)

<aside class="notes">
Speaker: Alex

* Also invisible parts like policies, maybe config in config maps, maybe service accounts.
* Plus deployment configuration - Docker image
* The problem? There is not one, but 10 or even thousands of them.
</aside>

# More applications

![](sample_app_multi.jpg)

<aside class="notes">
* From a K8s view, they are mostly all the same
* What do people do? Copy and paste YAML :-(
</aside>

# The answer?

#### Cloud Foundry!

# K8s and CF - Common Ideas

- Declare the desired state of the world
- The platform will make it happen

# Common Ideas (2)

- YAML almost everywhere
- The app is in a container
- Everything is either a long-running process (LRP) or a task
- LRP is central: a process that
  * is monitored (and restarted if needed)
  * has health checks

# Concepts unique to CF

<aside class="notes">
Speaker: Steffen
</aside>

#

![](cf-push-haiku.png)

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

# Main focus:<br/>web apps

* Centered around HTTP
* No reason not to do generic TCP

<aside class="notes">
Generic TCP is possible, but not that common
</aside>

# Buildpacks (1)

* Standardized way to build app images
* Everything needed to turn your app's source code into a webapp listening on port `8080`
* Makes it easy to update versions of the packages (dependencies) of the app

# Buildpacks (2)

>* Language specific
>* Core: Go, Ruby, Java, Node.js, ...
>* Community: Django, Perl, C++, TomEE, Eclipse Virgo, Jetty, Clojure, Haskell, Python, Zend Server (PHP), Null, JBoss, WebSphere Liberty, Erlang, Elixir, Swift, ...
>* BYO

<aside class="notes">
- static website? nginx
- Ruby apps? Interpreter + bundler
- Java? Maven, Tomcat, etc.

Alex: What about Docker image?

Does the buildpack build a container image?
</aside>

# Droplet as intermediate build product

>* `app + buildpack = droplet`
>* `droplet + rootfs = image`
>* Operator can update the rootfs without asking app devs to push again

<aside class="notes">
Alex (after second bullet point):

> But why? You could build the image at push time!
</aside>

# How Kubernetes features map to CF

<aside class="notes">
Speaker: Alex
</aside>

# Application access

- **K8s**: services provide load balancing
  * can be exposed via NodePort, Load Balancer or Ingress
- **CF**: `gorouter` load balances and exposes application
  * Apps get auto-registered when they come up
  * Nothing to configure for an app

<aside class="notes">
Alternating speakers

- K8s: map from custom container port to service port
- CF: is opinionated, always use $PORT (mostly 8080)
</aside>

# Access to databases

- **K8s**: you bring your own services, or deploy ServiceCatalog
- **CF**: apps consume services using Open Service Broker API

# BYO

Check out this talk:

> ["Microservices With Cloud Foundry and Kubernetes" by Julian Skupnjuak & Georgi Dankov](https://sched.co/KJCr)

<aside class="notes">
Speaker: Alex

May want to watch the recording, as it is going as we speak
</aside>

# Secret and configuration management

- **K8s**: secrets and config maps
- **CF**:
  * Service bindings auto-supply secrets via environment variables
  * User-provided environment variables

<aside class="notes">
* Service catalog in Kubernetes.
* Config maps create config file on disk
</aside>

# Container placement

- **K8s**: lots of ways to influence placement
- **CF**: not much influence
  * the default scheduler `Diego` does it for you

<aside class="notes">
K8s: affinity and antiaffinity groups based on labels and other applications, custom schedulers, based on node labels, priorities

CF: Isolation segments
</aside>

# Storage

- **K8s**: there are many options
- **CF**: disk is ephemeral by default
  * Possible with NFS and SMB (=> `persi`)
  * Use object storage (or another CF service)

<aside class="notes">
K8s: provider-native storage, local disk, NFS, etc

CF: [12factor says](https://12factor.net/processes):

> Any data that needs to persist must be stored in a stateful backing service, typically a database.
</aside>

# Monitoring & Self-healing

- **K8s**: there are readiness and liveness probes
- **CF**: http, port, process

<aside class="notes">
* K8s: Exec command on container, http-Get or TCP Socket
* There is no healing, just restart
</aside>

# Metrics

- **K8s**: you have to deploy metrics service
- **CF**: RYO

<aside class="notes">
K8s:

* Add heapster if you want to see metrics in your dashboard.
* May need something to store metrics; for example Prometheus
</aside>

# Logs

- **K8s**: logs are stored on worker node. You can deploy some tool, that will forward them
- **CF**: `Loggregator` streams to terminal or 3rd-party service

# Automated rollouts and rollbacks

- **K8s**: there are `deployments`
- **CF**: it does not really exist
  - trivial with external scripting
  - Green/blue deployments are established patterns

<aside class="notes">
* K8s: `Deployment`. Rollout strategy with upscaling new deployment and downscaling old one. Possible to rollback to previous version
* Zero-downtime deployments as a command is in beta
</aside>

# Batch execution

- **K8s**: `Jobs`, pre-start scripts, init containers
- **CF**: `Tasks`

# How workflows map

- **K8s**: mostly operator-centric (control plane)
- **CF**: we have pretty good separation between
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
* Only if you connect to a database, on first deploy
</aside>

# Update an existing app in K8s

>1. Update Docker image
>1. Push docker image to registry
>1. Change spec to use new image
>1. Apply spec

<aside class="notes">
For production I have a pipeline that does it for me, but for development workflow I have to do this.
</aside>

# Update an existing app in CF

`cf push`

# Getting Started

* Use a public CF provider
  - perhaps PWS or IBM Cloud?
* Deploy it yourself

# Eirini

![](cf-push-eirini.png)

#

![Eirini Architecture](eirini-arch.png)

<aside class="notes">
* This is what you get with Eirini!
* There are other talks with more details
<aside>

# Eirini Sessions

#include eirini-sessions.markdown

# Thanks!

`@alex_sly`

`@suhlig`

`http://cf101k8s.eirini.cf`

# Meta

<div class="mini">
  Rev.
  #include ../gpp/.dirty

  <br/>
  built on
  #exec TZ=UTC date +"%Y-%m-%d %T %Z"
 </div>
