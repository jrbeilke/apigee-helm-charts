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

registry rpc admin update-project \
	--project.name projects/catalog \
	--project.display_name "API Catalog" \
	--project.description "APIs collected from a variety of sources." \
	--allow_missing \
	>& /dev/null

registry config set registry.project catalog

registry apply -f ./catalog/manifest.yaml