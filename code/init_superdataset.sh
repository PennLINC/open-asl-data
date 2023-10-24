#!/bin/bash
#
# Install an OpenNeuro dataset.
dataset_id=$1
base_dir="/cbica/home/salot/datasets"
superdataset_dir=${base_dir}/${dataset_id}
code_dir=`pwd`

# Create the YODA superdataset
datalad create -c yoda \
    -D "Create superdataset for OpenNeuro dataset ${dataset_id}" \
    "${superdataset_dir}"`
cd ${superdataset_dir}

# Download the OpenNeuro subdataset
datalad clone -d ${superdataset_dir} \
    -D "Clone of OpenNeuro dataset. May be modified for sMRIPrep/ASLPrep and pushed to G-Node GIN." \
    https://github.com/OpenNeuroDatasets/${dataset_id}.git inputs/data
datalad get inputs/data

# Create output subdatasets
datalad create -d ${superdataset_dir} \
    -D "sMRIPrep derivatives for ${dataset_id}." \
    outputs/smriprep
datalad create -d ${superdataset_dir} \
    -D "ASLPrep derivatives for ${dataset_id}." \
    outputs/aslprep

# Prepare code directory
mkdir ${superdataset_dir}/code
cp ${code_dir}/run_smriprep.sh ${superdataset_dir}/code/
cp ${code_dir}/run_aslprep.sh ${superdataset_dir}/code/
datalad save -m "Add base scripts for preprocessing."

# Push superdataset to G-Node GIN
datalad create-sibling-gin --siblingname gin --access-protocol ssh \
    --dataset . ME-ICA/${dataset_id}_superdataset
datalad push --to gin
