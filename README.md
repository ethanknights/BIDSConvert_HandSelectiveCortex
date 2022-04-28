#  Knights et al. (2021). Brain decoding during real actions.


This repository contains code accompanying the timeseries machine-learning project that is published in the Journal of Neuroscience: https://www.jneurosci.org/content/41/24/5263

**Prerequisites**
- Python 3.0 (for dcm2bids)
- LibSVM (for machine learning classification; https://www.csie.ntu.edu.tw/~cjlin/libsvm/index.html)
- Searchmight matlab toolbox (for whole-brain searchlight machine-learning; http://www.franciscopereira.org/searchmight/)

## **1) Conduct the Experiment**
Add ```minilab.m on``` to the matlab path before initiating the fMRI experiment: ```runExperiment/run_MRI_realAction.m```

## **2) Convert dataset to standard BIDS format**
Perform the .dcm conversion using python via: ```BIDSconversion/convertBIDS.m```
<br> *Alternatively, use ```datalad``` to download the fMRI data from openneuro platform: https://openneuro.org/datasets/ds003342/versions/1.0.0*

## **3) Perform machine-learning classification**
Run the Leave-One-Run-Out cross validation MVPA or searchlight libsvm classifiers: ```https://github.com/fws252/ROI-based-and-searchlight-MVPA-decoding-Knights-et-al-2020-```
<br> *Alternatively, download the derived MVPA summary dataset from the Open Science Framework platform: https://osf.io/wjnxk/*

## **4) Hypothesis testing**
Compare decoding accuracy using across classifiers using Bayesian t-tests & ANOVAs: ```stats/BayesTests.m```

## **5) Generate plots** 
The resulting machine-learning distribution plots can be generated via: ```plots/run_violinPlots.m```

## How to Acknowledge
Please cite: <br>
*Knights, E., Mansfield, C., Tonin, D., Saada, J., Smith, F. W., & Rossit, S. (2021). Hand-selective visual regions represent how to grasp 3D tools: brain decoding during real actions. Journal of Neuroscience, 41(24), 5263-5273.*
