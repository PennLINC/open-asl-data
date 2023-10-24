# open-asl-data
Processing for open ASL datasets

This repository contains code to do the following for ASL datasets on OpenNeuro:

1.  Create a Datalad super-dataset.

```
dsXXXXXX/
    inputs/
        data/       <-- subdataset from OpenNeuro
            code/   <-- code to fix BIDS issues in raw dataset
    outputs/
        smriprep/   <-- subdataset of sMRIPrep derivatives
        aslprep/    <-- subdataset of ASLPrep derivatives
    code/           <-- code to run sMRIPrep and ASLPrep
```
