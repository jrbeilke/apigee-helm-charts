# Helm Charts

This repository contains Helm charts for the
[Apigee Registry API](https://github.com/apigee/registry) and related tools.

## Charts

The [charts/core](/charts/core) directory contains Helm charts for the core
services of an API Registry.

- [registry-server](/charts/core/registry-server) installs the Registry API
  gRPC service.
- [registry-gateway](/charts/core/registry-gateway) installs an Envoy proxy
  that provides transcoded HTTP and gRPC Web services.
- [registry-controller](/charts/core/registry-controller) installs a cron job
  that runs the Registry Controller.
- [registry-viewer](/charts/core/registry-viewer) installs the Registry Viewer.

The [charts/importers](/charts/importers) directory contains Helm charts for
cron jobs that import information into the registry.

- [import-kubernetes](/charts/importers/import-kubernetes) imports Kubernetes
  APIs.
- [import-wordnik](/charts/importers/import-wordnik) imports the Wordnik API.
- [import-google](/charts/importers/import-google) imports Protocol Buffer descriptions of Google APIs.

The [charts/jobs](/charts/jobs) directory contains Helm charts for cron jobs
that maintain information in the registry.

- [compute-summary-apis](/charts/jobs/compute-summary-apis) computes summary
  information about APIs.
- [compute-summary-project](/charts/jobs/compute-summary-project) computes a
  project-level summary.

## Installation

Users familiar with Helm can install these charts directly.

The [standalone](/standalone) directory contains scripts that create and manage
a standalone installation of the entire toolset.

The [catalog](/catalog) directory contains a script that can be used to create
a Registry project named "catalog".

Note that all scripts should be run from the root of the repo, e.g.
```
./standalone/setup.sh
```

## Exploration

To directly call the registry server, expose the `registry-server` using one of
the following methods:

```
# expose the pod for local testing (your pod name will vary)
kubectl port-forward -n registry pods/registry-server-d67c558c8-g9rmz 8080:8080

# expose the deployment for local testing
kubectl port-forward -n registry deployments/registry-server 8080:8080

# expose the service for local testing
kubectl port-forward -n registry services/registry-server 8080:80
```

Since these commands run for the lifetime of the connection, change to a
different shell to call the API.

```
# first configure the registry tool
registry config configurations create helm
registry config set address localhost:8080
registry config set insecure true
registry config set location global

# verify the registry-server and its database connection
registry rpc admin get-storage --json
```

## PostgreSQL

The `registry-server` requires PostgreSQL, and the chart currently expects an
installation of the
[bitnami/postgresql](https://bitnami.com/stack/postgresql/helm) chart in the
`registry` namespace. Future chart revisions might support
[Cloud SQL](https://cloud.google.com/sql) and other database hosting services.

Quoting the `bitnami/postgresql` installation notes:

> PostgreSQL can be accessed via port 5432 on the following DNS names from
> within your cluster:

    data-postgresql.apis.svc.cluster.local - Read/Write connection

> To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace apis data-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

> To connect to your database run the following command:

    kubectl run data-postgresql-client --rm --tty -i --restart='Never' --namespace apis --image docker.io/bitnami/postgresql:15.2.0-debian-11-r14 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host data-postgresql -U postgres -d postgres -p 5432

> NOTE: If you access the container using bash, make sure that you execute
> "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid
> the error "psql: local user with ID 1001} does not exist"

> To connect to your database from outside the cluster execute the following
> commands:

    kubectl port-forward --namespace apis svc/data-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432

> WARNING: The configured password will be ignored on new installation in case
> when previous Posgresql release was deleted through the helm command. In that
> case, old PVC will have an old password, and setting it through helm won't
> take effect. Deleting persistent volumes (PVs) will solve the issue.

## Disclaimer

This demonstration is not an officially supported Google product.

## License

Unless otherwise specified, all content in the organization is owned by Google,
LLC and released with the Apache license.
