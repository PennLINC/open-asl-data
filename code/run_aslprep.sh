#!/bin/bash
#$ -pe threaded 1
#$ -l h_vmem=32G
#$ -l h_rt=240:00:00
#$ -cwd
#$ -N aslprep
#$ -e /cbica/home/salot/datasets/${dataset_id}/code/logs
#$ -o /cbica/home/salot/datasets/${dataset_id}/code/logs

BIDS_DIR=/cbica/home/salot/datasets/${dataset_id}/dset

# Extract the subject ID from the participants.tsv file.
subject=$( sed -n -E "$((${SGE_TASK_ID} + 1))s/sub-(\S*)\>.*/\1/gp" ${BIDS_DIR}/participants.tsv )

cmd="singularity run --home $HOME --cleanenv \
    -B $BIDS_DIR:/data \
    /cbica/home/salot/datasets/mobile-phenomics/singularity/aslprep-23_1_5dev.simg \
    /data \
    /data/derivatives/aslprep \
    participant \
    --participant-label $subject \
    -w /cbica/home/salot/datasets/mobile-phenomics/work \
    --anat-derivatives /cbica/home/salot/datasets/mobile-phenomics/derivatives/smriprep \
    --nprocs 1 \
    --omp-nthreads 1 \
    --output-spaces aslref T1w MNI152NLin6Asym \
    --scorescrub \
    --basil \
    --bids-filter-file /cbica/home/salot/datasets/mobile-phenomics/code/bids_filter.json \
    --fs-license-file /cbica/home/salot/datasets/mobile-phenomics/freesurfer_license.txt \
    --skip_bids_validation"

echo Running task ${SGE_TASK_ID}
echo Commandline: $cmd
datalad run -m "Run fMRIPrep on ${dataset_id} ${subject}." $cmd
