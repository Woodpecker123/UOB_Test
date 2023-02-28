#!/bin/bash

#
# create-cas-server.sh
# 2020
#
# This script will take user parameters as input, and
# generate new CAS server definitions (CR) for Viya 4.

#set -x

function echo_line()
{
    line_out="$(date) - $1"
    printf "%s\n" "$line_out"
}

version="2.0"

case "$1" in
        --version | -v)
                echo "${version}"
                exit
                ;;
        --help | -h)
                echo "Flags:"
                echo "  -h  --help     help"
                echo "  -i, --instance  CAS Server instance name"
                echo "  -o, --output   Output location.  If undefined, default to working directory."
                echo "  -v, --version  CAS Server Creation Utility version"
                echo "  -w, --workers  Specify the number of CAS worker nodes. Default is 0 (SMP)."
                echo "  -b, --backup   Set this flag to 1 to include a CAS backup controller.  Disabled by default."
                echo "  -t, --tenant   Set the tenant name. default is shared."
                exit
                ;;
esac

# declaring a couple of associative arrays
declare -A arguments=();
declare -A variables=();
declare -A env=();

# declaring an index integer
declare -i index=1;

variables["-i"]="instance";
variables["--instance"]="instance";
variables["-f"]="file";
variables["--file"]="file";
variables["-o"]="output";
variables["--output"]="output";
variables["-w"]="workers";
variables["--workers"]="workers";
variables["-b"]="backup";
variables["--backup"]="backup";
variables["-t"]="tenant";
variables["--tenant"]="tenant";

# $@ here represents all arguments passed in
for i in "$@"
do
  arguments[$index]=$i;
  prev_index="$(expr $index - 1)";

  # this if block does something akin to "where $i contains ="
  # "%=*" here strips out everything from the = to the end of the argument leaving only the label
  if [[ $i == *"="* ]]
    then argument_label=${i%=*}
    else argument_label=${arguments[$prev_index]}
  fi

  exec 2> /dev/null
  # this if block only evaluates to true if the argument label exists in the variables array
  if [[ -n ${variables[$argument_label]} ]]
    then
        # dynamically creating variables names using declare
        # "#$argument_label=" here strips out the label leaving only the value
        if [[ $i == *"="* ]]
            then declare ${variables[$argument_label]}=${i#$argument_label=}
            else declare ${variables[$argument_label]}=${arguments[$index]}
        fi
  elif [ "$argument_label" == "--env" ]; then
    #get the index of the value
    ((value_index=index+1))

    #store the name and value in the map
    env["$i"]="${!value_index}"
  fi
  exec 2> /dev/tty

  index=index+1;
done;

if [ -z "${instance}" ]; then
    if [ -z "${tenant}" ]; then
        echo_line "instance is not defined.  Please provide instance with either -i or --instance flag."
        exit 1
    else
        instance="default"
    fi
fi
echo_line "instance = $instance"
echo_line "tenant = $tenant"

if [ -z "${tenant}" ]; then
    tenant="shared"
fi

if [ ! -z "${workers}" ]; then
    workers=${workers}
else
    workers=0
fi

if [ ! -z "${backup}" ]; then
    if [ $backup == "0" ] || [ $backup == "1" ]; then
        backup=${backup}
    else
        echo "invalid value for backup: $backup"
        echo "please enter 0 or 1"
        exit 1
    fi
else
    backup=0
fi

while true; do
    echo "WARN: Do not attempt to use this script in your deployment."
    echo "WARN: Kustomize Component support in CAS is being evaluated for a future release of SAS Viya."
    echo "WARN: Use \"create-cas-server.sh\" in this same directory."
    read -p "Do you want to continue? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Default output to cwd if not set
[[ -z ${output+x} ]] && output="${PWD}"
echo_line "Output = $output"
output=$output"/"

if [ -d "${output}sas-cas-${tenant}-${instance}" ]; then
echo ""
while true; do
    read -p "Content already exists in the specified output location.  Continuing will overwrite the existing content.  Do you want to continue? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
rm -rf ${output}sas-cas-${tenant}-${instance}
fi

if [ ! -d "${output}sas-cas-${tenant}-${instance}" ]; then
    echo_line "Output directory does not exist: ${output}sas-cas-${tenant}-${instance}"
    echo_line "Creating directory: ${output}sas-cas-${tenant}-${instance}"
    output_base="${output}/sas-cas-${tenant}-${instance}"
    output_sub="${output_base}/sas-cas-server"
    mkdir -p ${output_base}
    mkdir -p ${output_sub}
fi

# Absolute path to this create-cas-server.sh script.
_cur_script=$(readlink -f $0)
# Absolute path to directory of this create-cas-server.sh script.
_cur_script_dir=$(dirname $_cur_script)
# Absolute path to the sas-cas-server-shared in components
_cas_base_component_dir=$(dirname $(readlink -f "$_cur_script_dir/../../../components/sas-cas-server-shared"))

# Output path relative to sas-cas-server-shared components
# Return relative path from canonical absolute dir path $1 to canonical
# absolute dir path $2 ($1 and/or $2 may end with one or no "/").
relPath () {
    local common path up
    common=${1%/} path=${2%/}/
    while test "${path#"$common"/}" = "$path"; do
        common=${common%/*} up=../$up
    done
    path=$up${path#"$common"/}; path=${path%/}; printf %s "${path:-.}"
}

_rel_base_component_dir=$(relPath "$(readlink -f "${output_base}")" "$(readlink -f "${_cas_base_component_dir}")")
_rel_sub_component_dir=$(relPath "$(readlink -f "${output_sub}")" "$(readlink -f "${_cas_base_component_dir}")")

echo_line "Generating artifacts..."

count=0
total=34
pstr="[=======================================================================]"

while [ $count -lt $total ]; do
  sleep 0.025 # this is work
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done

echo ""
echo "├── sas-cas-${tenant}-${instance} (root directory)"

echo "   ├── kustomization.yaml"

cat << EOF >> ${output_base}/kustomization.yaml
kind: Kustomization
apiVersion: kustomize.config.k8s.io/v1beta1

resources:
 - sas-cas-server
components:
 - ${_rel_base_component_dir}/sas-cas-server/sas-cas-server-common

EOF

# Okay now into the sas-cas-server subdirectory
echo "   └── sas-cas-server"

# Create patch for --workers
echo "       └── cas-worker-patch.yaml"
cat << EOF >> ${output_sub}/cas-worker-patch.yaml
---
apiVersion: builtin
kind: PatchTransformer
metadata:
  name: cas-worker-patch
patch: |-
   - op: replace
     path: /spec/workers
     value:
       $workers
target:
  group: viya.sas.com
  kind: CASDeployment
  name: sas-cas-${tenant}-${instance}
  version: v1alpha1

EOF

# Create patch for --backup
echo "       └── cas-backup-patch.yaml"
cat << EOF >> ${output_sub}/cas-backup-patch.yaml
---
apiVersion: builtin
kind: PatchTransformer
metadata:
  name: cas-manage-backup
patch: |-
   - op: replace
     path: /spec/backupControllers
     value:
       $backup
target:
  group: viya.sas.com
  kind: CASDeployment
  name: sas-cas-${tenant}-${instance}
  version: v1alpha1

EOF

# Create patch for --tenant + --instance
echo "       └── cas-tenant-instance-patch.yaml"
cat << EOF >> ${output_sub}/cas-tenant-instance-patch.yaml
---
apiVersion: builtin
kind: PatchTransformer
metadata:
  name: sas-cas-tenant-instance-patch
patch: |-
  - op: replace
    path: /spec/tenantID
    value:
      ${tenant}
  - op: replace
    path: /spec/instanceID
    value:
      ${instance}
target:
  group: viya.sas.com
  kind: CASDeployment
  name: sas-cas-${tenant}-${instance}
  version: v1alpha1

EOF

# Create patch for instance configmap
echo "       └── cas-instance-configmap-patch.yaml"
cat << EOF >> ${output_sub}/cas-instance-configmap-patch.yaml
---
apiVersion: builtin
kind: PatchTransformer
metadata:
  name: cas-instance-configmap-patch
patch: |-
  - op: add
    path: /spec/controllerTemplate/spec/containers/0/envFrom/-
    value:
       configMapRef:
          name: sas-cas
target:
  group: viya.sas.com
  kind: CASDeployment
  name: sas-cas-${tenant}-${instance}
  version: v1alpha1

EOF

echo "       └── kustomization.yaml"

cat << EOF >> ${output_sub}/kustomization.yaml
kind: Kustomization
apiVersion: kustomize.config.k8s.io/v1beta1
nameSuffix: -${tenant}-${instance}
commonLabels:
  sas.com/tenant: ${tenant}
  casoperator.sas.com/tenant: ${tenant}
  casoperator.sas.com/instance: ${instance}
  casoperator.sas.com/casdeployment: sas-cas-${tenant}-${instance}
  app.kubernetes.io/part-of: cas
components:
- ${_rel_sub_component_dir}/sas-cas-server/sas-cas-server-shared
transformers:
- cas-tenant-instance-patch.yaml
- cas-worker-patch.yaml
- cas-backup-patch.yaml
- cas-instance-configmap-patch.yaml

EOF

echo ""
echo_line "create-cas-server.sh complete!"
echo ""

exit 0
