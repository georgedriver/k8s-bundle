# k8s-bundle

*The new home for k8s helmfiles*

## Intro

k8s is the Service Infrastructure Compute platform; this repo contains the files need to provisioning the platform on top of an empty Kubernetes cluster and the configuration files for all our current k8s clusters/environments.

## Usage

I expect most of the applications can be installed automatically with below commands.

Please notice that, for the first time installation, it's strongly recommended to use [`--selector`](https://github.com/roboll/helmfile#cli-reference) to install the releases one by one.

```bash
docker run -it -v $PWD:/code -v /Users/`whoami`/.kube/config:/root/.kube/config georgedriver/k8s-tools:latest bash
cd /code
# Install depend_on_others!=true
helmfile -e k8s-mirana --selector depend_on_others!=true diff
helmfile -e k8s-mirana --selector depend_on_others!=true sync

# Then sync all
helmfile -e k8s-mirana sync
```

### CI/CD flow & the life of a PR

* on each PR
  - for each cluster/environment defined in the environments folder:
    - helmfile linter is run
    - helmfile diff is run (with clean output and more to come)

* once PR is merged to master
  - for each cluster/environment defined in the environments folder:
    - helmfile linter is run
    - helmfile diff is run (output is store for auditing purposes)
    - apply the new helmfiles

## Secret management

Managed by CircleCI.

## Contributing
* Pull requests are welcome.
* For major changes, please open an issue first to discuss what you would like to change.
