clear 

% addpath('/imaging/ek03/toolbox/cbrewer/')
%addpath('/imaging/ek03/toolbox/otherMatlab/') %not needed so far
% addpath('/imaging/ek03/toolbox/plot2svg')

%data = readtable('/imaging/henson/users/ek03/projects/tool_grasping/data.csv')
%save('t_decAcc_forPlot.mat','data')
load('t_decAcc_forPlot.mat')


roiName = {'EVC','LOTC-Object','LOTC-Body','LOTC-Hand','LOTC-Tool','pMTG','pFs','SMG','IPS-Hand','IPS-Tool','PMv','PMd','SC'};
pairs = [1,2; 3,4; 5,6; 7,8; 9,10; 11,12; 13,14; 15,16; 17,18; 19,20; 21,22; 23,24; 25,26];
for r = 1:12
%for r = 13
   clear d dd tmp
   
    col(1) = pairs(r,1);
    col(2) = pairs(r,2);

    d = table2array(data(:,col(1):col(2)));
    
    tmp = isnan(d(:,1)) %nans match within roi obv
    dd{1} = d(~tmp,1)
    dd{2} = d(~tmp,2)
    d=dd
    
    makeViolinPlot_v2_EK(d,roiName{r});
end
