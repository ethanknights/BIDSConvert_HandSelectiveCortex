#  Knights, et al., (2021). Hand-selective visual regions represent how to grasp 3D tools: brain decoding during real actions. Journal of Neuroscience, 41(24), 5263-5273.

This repository contains code for the machine learning project (fMRI MVPA) published in the Journal of Neuroscience (https://www.jneurosci.org/content/41/24/5263):

**Prerequisites**
- Python 3.0 (for dcm2bids)
- LibSVM (for machine learning classifier)


**1. BIDS conversion**
https://openneuro.org/datasets/ds003342/versions/1.0.0. See BIDSconversion/convertBIDS.m
- **Real Action Experiment Code**
Use runExperiment/run_MRI_realAction.m on a stimulation pc to read the sound (.wav) and delimited (.xlsx) files, with minilab.m on the matlab path.
- **Stats**
Download MVPA data (https://osf.io/wjnxk/) and use stats/BayesTests.m
- **Plots** 
Download MVPA data (https://osf.io/wjnxk/) and use plots/run_violinPlots.m

**2. MVPA & searchlight code**
See https://github.com/fws252/ROI-based-and-searchlight-MVPA-decoding-Knights-et-al-2020-


# How to Acknowledge
Please cite: Knights, E., Mansfield, C., Tonin, D., Saada, J., Smith, F. W., & Rossit, S. (2021). Hand-selective visual regions represent how to grasp 3D tools: brain decoding during real actions. Journal of Neuroscience, 41(24), 5263-5273.
