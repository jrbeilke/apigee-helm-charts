#!/bin/bash
#
# Copyright 2023 Google LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

NAMESPACE="${NAMESPACE:-apis}"

# REGISTRY_HOST is the domain where the Registry API will be served.
# VIEWER_HOST is the domain where the Registry Viewer will run.
if [[ -z "$REGISTRY_HOST" ]] || [[ -z "$VIEWER_HOST" ]]; then
    echo "Please set REGISTRY_HOST and VIEWER_HOST" 1>&2
    exit 1
fi

# Create namespace if it doesn't already exist.
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Install core components.
helm install -n $NAMESPACE data bitnami/postgresql
helm install -n $NAMESPACE registry-server charts/core/registry-server \
  --set "database.config.host=data-postgresql.${NAMESPACE}.svc.cluster.local"
helm install -n $NAMESPACE registry-gateway charts/core/registry-gateway \
  --set ingress.host=${REGISTRY_HOST} \
  --set "registry.host=registry-server.${NAMESPACE}.svc.cluster.local"
helm install -n $NAMESPACE registry-viewer charts/core/registry-viewer \
  --set ingress.host=${VIEWER_HOST} \
  --set registry.url=https://${REGISTRY_HOST}
helm install -n $NAMESPACE registry-controller charts/core/registry-controller \
  --set registry.project=catalog \
  --set "registry.host=registry-server.${NAMESPACE}.svc.cluster.local"

# Install importers.
helm install -n $NAMESPACE import-kubernetes charts/importers/import-kubernetes \
  --set "registry.host=registry-server.${NAMESPACE}.svc.cluster.local"
helm install -n $NAMESPACE import-wordnik charts/importers/import-wordnik \
  --set registry.host=registry-server.${NAMESPACE}.svc.cluster.local

# Install workers.
helm install -n $NAMESPACE compute-summary-project charts/jobs/compute-summary-project \
  --set "registry.host=registry-server.${NAMESPACE}.svc.cluster.local"
helm install -n $NAMESPACE compute-summary-apis charts/jobs/compute-summary-apis \
  --set "registry.host=registry-server.${NAMESPACE}.svc.cluster.local"
