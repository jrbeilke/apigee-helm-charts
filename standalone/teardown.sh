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

# Uninstall workers.
helm uninstall -n ${NAMESPACE} compute-summary-project
helm uninstall -n ${NAMESPACE} compute-summary-apis

# Uninstall importers.
helm uninstall -n ${NAMESPACE} import-kubernetes
helm uninstall -n ${NAMESPACE} import-wordnik

# Uninstall core components.
helm uninstall -n ${NAMESPACE} registry-controller
helm uninstall -n ${NAMESPACE} registry-viewer
helm uninstall -n ${NAMESPACE} registry-gateway
helm uninstall -n ${NAMESPACE} registry-server
helm uninstall -n ${NAMESPACE} data

# Delete the storage used by postgresql.
kubectl delete pvc/data-data-postgresql-0 -n ${NAMESPACE}