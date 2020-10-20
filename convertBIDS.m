%--- BIDS CONVERSION ---%

%Start with anaconda with dcm2bids isntalled via pip:
%/Applications/MATLAB_R2019b.app/bin/matlab
%%%addpath('/Users/ethanknights/imaging/software')
%setenv('PATH', [getenv('PATH') ':/Users/ethanknights/imaging/software']);

%Stop mac sleeping:
% pmset -g
% To stop sleep entirely:
% sudo pmset -a disablesleep 1
% To revert, allowing sleep again:
% sudo pmset -a disablesleep 0

clear
%---SWITCHES----%
doneCopy_ToolAction = 1;
doneCopy_Localiser =  1;
doneBIDS_ToolAction = 1;
doneBIDS_Localiser =  1;
done_deface = 1;

%----PREPARE----%
UEA_root = '/Volumes/Ethan/fMRI_bial';
wDir = '/Users/ethanknights/imaging/toolData';

BIDS_root = '/Users/ethanknights/ownCloud/BIDS_toolStudy';
%BIDS_root = fullfile(wDir,'BIDS');
tmpDir_root = fullfile(wDir,'tmp');
utilsPath = fullfile(wDir,'scripts/utils');
sNames = {
  'CR09',
  'DT12',
  'JM15',
  'JR24',
  'KH02',
  'KL04',
  'LB28',
  'LP12',
  'MC17',
  'MK14',
  'QP18',
  'QR30',
  'RE29',
  'RL17',
  'RS06',
  'SC13',
  'ST28',
  'TS12',
  'VB04'
  };


%----TRANSFER DATA LOCALLY----%
%-- Tool Action Copy --#
if ~doneCopy_ToolAction
  
  %-- Setup --%
  sessID = 'action';
  nDcms = 6230; %for fMRI, ignore anat not many anyway so should be fine
  dirNames_anat = {
    '/Volumes/Ethan/fMRI_bial/CR09/CR09_rawA_Disc1/ST00000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/DT12/DT12_raw_A/Renamed/ST000000_disc1/ST000000/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/JM15/JM15_rawA_Disc1/ST000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/JR24/JR24_raw_A/ST000000_Renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/KH02/KH02_Raw\ A\ _Disc1/ST000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/KL04/KL04_raw_A_Disc1/ST0000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/LB28/LB28_rawA_Disc1/ST0000_renamed/SE000001_ANAT',...
    '/Volumes/Ethan/fMRI_bial/LP12/LP12_raw_A/ST00000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/MC17/MC17_rawA_Disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/MK14/MK14_rawA_Disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/QP18/QP18_raw_A/ST000000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/QR30/QR30_rawA_disc1/ST000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RE29/RE29_raw\ A_Disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RL17/RL17_raw_A_Disc1/ST0000Renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RS06/RS06_raw_A_Disc1/ST00000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/SC13/SC13_raw_A/ST000000_renamed/SE000008_ANAT2', ...
    '/Volumes/Ethan/fMRI_bial/ST28/ST28_Raw_A/Disc3/Disc3_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/TS12/TS12_raw_Part\ A/DICOM_disc3_renamed/ST000000/SE000003_ANAT_CAN' ...
    '/Volumes/Ethan/fMRI_bial/VB04/VB04_raw_A/ST000000_renamed/SE000007_ANAT'
    };
  
  for s = 1:length(sNames)
    sName = sNames{s};
    tmpDir = fullfile(tmpDir_root,sName,sessID)
    
    allDcms = [];
    
    mkdir(tmpDir);
    
    %-- Copy Anat --#
    pathparts = strsplit(dirNames_anat{s},filesep);
    tmpName = sprintf('%s/%s',tmpDir,pathparts{end})
    
    if ~exist(tmpName,'dir')
      mkdir(tmpName)
      rawPath = dirNames_anat{s}
      cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir); %not tmpName or 1 dir too deep
      system(cmdStr);
    end
    
    %-- Copy Functionals --#
    dirName_func = readtable(sprintf('%s/dirNames_%s/dirNames_%s.csv',utilsPath,sessID,sName),'delimiter',',');
    
    for r = 1:height(dirName_func)
      rawPath = dirName_func.dirName{r}
      pathparts = strsplit(rawPath,filesep);
      tmpName = sprintf('%s/%s',tmpDir,pathparts{end})

      if ~exist(tmpName,'dir')
        mkdir(tmpName)
        cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir) %not tmpName or 1 dir too deep
        system(cmdStr);
      end
      allDcms{r} = dir(sprintf('%s/*.dcm',tmpName))
       %assert(length(allDcms{r}) == nDcms,'Wrong Number of .dcms'); %Simple solution but we have ST28... %+1 for sorted_file_list.txt
      
      try
        assert(length(allDcms{r}) == nDcms,'Wrong Number of .dcms'); %+1 for sorted_file_list.txt
      catch
        if strcmp(sName,'ST28') %THis sub had 2 extra volumes in run 1 accoridng to scan notes.
           allDcms{r} = dir(sprintf('%s/*',tmpName))
           if r == 1
               assert(length(allDcms{r}) - 2 == 6300,'Wrong Number of .dcms'); %-2 for hidden . ..
           elseif r == 2:6
               assert(length(allDcms{r}) - 2 == nDcms,'Wrong Number of .dcms'); %-2 for hidden . ..
           end
        else
          error('Unexepcted wrong Number of dicoms')
        end
      end
    end
    
  end
end

%---- Localiser Copy ----%
if ~doneCopy_Localiser
  
  %-- Setup --%
  sessID = 'localiser';
  nDcms = 7840; %for fMRI, ignore anat not many anyway so should be fine
  dirNames_anat = {
    '/Volumes/Ethan/fMRI_bial/CR09/CR09_rawB_disc2/ST000_renamed/SE000000_ANAT',... 
    '/Volumes/Ethan/fMRI_bial/DT12/DT12_raw_B/ST000000_renamed/SE000005_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/JM15/JM15_raw_B_Disc2/ST0000_renamed/ST000000/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/JR24/JR24_raw_B_Disc2/ST00000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/KH02/KH02_raw_B_Disc2/ST0000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/KL04/KL04_raw_B_Disc1/ST00000renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/LB28/LB28_rawB_disc2/ST000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/LP12/LP12_raw_B_Disc2/ST00000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/MC17/MC17_rawB_disc1/ST000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/MK14/MK14_rawB_Disc2/ST0000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/QP18/QP18_raw_B_disc1/ST10000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/QR30/QR30_rawB_disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RE29/RE29_raw\ B_Disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RL17/RL17_raw_B_Disc1/ST0000_renamed/SE000001_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/RS06/RS06_raw_B_Disc2/ST0000_renamed/SE000000_ANAT', ...
    '/Volumes/Ethan/fMRI_bial/SC13/SC13_raw_B_Disc2/ST0000_renamed/SE000000_ANAT_Run0', ...
    '', ... %ST28
    '', ... %TS12
    '/Volumes/Ethan/fMRI_bial/VB04/VB04_raw_B/ST00000_renamed/SE000001_ANAT' %VB04
    };
  
  for s = 1:length(sNames)
    sName = sNames{s};
    tmpDir = fullfile(tmpDir_root,sName,sessID)
    
    allDcms = [];
    
    mkdir(tmpDir);
    
    %-- Copy Anat --#
    pathparts = strsplit(dirNames_anat{s},filesep);
    tmpName = sprintf('%s/%s',tmpDir,pathparts{end})
    
    if ~exist(tmpName,'dir')
      mkdir(tmpName)
      rawPath = dirNames_anat{s}
      cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir); %not tmpName or 1 dir too deep
      system(cmdStr);
    end
    
    %-- Copy Functionals --#
    dirName_func = readtable(sprintf('utils/dirNames_%s/dirNames_%s.csv',sessID,sName),'delimiter',',');
    
    for r = 1:height(dirName_func)
      rawPath = dirName_func.dirName{r}
      pathparts = strsplit(rawPath,filesep);
      tmpName = sprintf('%s/%s',tmpDir,pathparts{end})
      
      if ~exist(tmpName,'dir')
        mkdir(tmpName)
        cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir) %not tmpName or 1 dir too deep
        system(cmdStr);
      end
      allDcms{r} = dir(sprintf('%s/*.dcm',tmpName))
      assert(length(allDcms{r}) == nDcms,'Wrong Number of .dcms'); %+1 for sorted_file_list.txt
    end
    
  end
end



%---- CONVERT2BIDS ----%
  
%-- Tool Action --%
if ~doneBIDS_ToolAction
  sessID = 'action';
  
  configFile = sprintf('%s/config_%s.json',utilsPath,sessID);
    for s = 1:length(sNames)
      sName = sNames{s}
      tmpDir = fullfile(tmpDir_root,sName,sessID)

      cmdStr = sprintf('dcm2bids -d %s -p %s -s %s -c %s -o %s',tmpDir,sName,sessID,configFile,BIDS_root)
      system(cmdStr);
    end
end

%-- Localiser --%
if ~doneBIDS_Localiser
sessID = 'localiser';

configFile = sprintf('%s/config_%s.json',utilsPath,sessID);
  for s = 13:length(sNames)
    
    sName = sNames{s}
    
    if ~strcmp(sName,'ST28') & ~strcmp(sName,'TS12')
      
    tmpDir = fullfile(tmpDir_root,sName,sessID)
    
    cmdStr = sprintf('dcm2bids -d %s -p %s -s %s -c %s -o %s',tmpDir,sName,sessID,configFile,BIDS_root)
    system(cmdStr);
    else
      %NOOP - skip no localiser ST28/TS12.dcms
    end
      
  end
end



%-- Deface --%
if ~done_deface
sessIDList = {'action','localiser'};

%configFile = sprintf('%s/config_%s.json',utilsPath,sessID);
  for s = 1:length(sNames)
    
    for sess = 1:2
      
      %if ~strcmp(sName,'ST28') & ~strcmp(sName,'TS12')
      try
        sName = sNames{s};
        sessID = sessIDList{sess};
        fileToDeface = sprintf('%s/sub-%s/ses-%s/anat/sub-%s_ses-%s_T1w.nii.gz',BIDS_root,sName,sessID,sName,sessID);
    
        cmdStr = sprintf('pydeface --verbose --force --outfile %s %s',fileToDeface,fileToDeface)
        system(cmdStr);
      catch
        %NOOP %ST28TS12 LOCALISER
      end
    end
  end
end
 %---- END ---%
 
 

return
  
  
%-- RERIEVE LOCALISERS FROM TONIN, ROSSIT SMITH: ST28 & TS12  ----% 
%--ST28--%
rawPath = '/Volumes/Ethan/fMRI_bial/ST28/LocaliserDicoms/ST28_raw'
tmpDir = '/Users/ethanknights/imaging/toolData/localiser_fromDcm';
cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir) %not tmpName or 1 dir too deep
system(cmdStr);
!mv /Users/ethanknights/imaging/toolData/localiser_fromDcm/ST28_raw/ST28_raw_ep2d_3iso_matrix72_ipat2_localizer_20160419121241_* /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-ST28/ses-localiser/func
!mv /Users/ethanknights/imaging/toolData/localiser_fromDcm/ST28_raw/*MPRAGE* /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-ST28/ses-localiser/anat
!pydeface --verbose --force --outfile /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-ST28/ses-localiser/anat/sub-ST28_ses-localiser_T1w.nii /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-ST28/ses-localiser/anat/sub-ST28_ses-localiser_T1w.nii
  
    
%rawPath = '/Volumes/Ethan/fMRI_bial/TS12/TS12_LocaliserDicoms/ZS12_160415' %MPRAGE but no localiser
%rawPath = '/Volumes/Ethan/fMRI_bial/TS12/TS12_LocaliserDicoms/OBJECT_ZS12_160413/'
rawPath = '/Volumes/Ethan/fMRI_bial/TS12/TS12_LocaliserDicoms/ZS12-EXTRA'
tmpDir = '//Users/ethanknights/imaging/toolData/localiser_fromDcm/';
cmdStr = sprintf('rsync -vr %s %s',rawPath,tmpDir)
system(cmdStr);
!mv /Users/ethanknights/imaging/toolData/localiser_fromDcm/*ZS12*/*ipat*localizer*.* /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-TS12/ses-localiser/func
!mv /Users/ethanknights/imaging/toolData/localiser_fromDcm/ZS12_160415/__MPRAGE_1iso_G2_20160415165649_2* /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-TS12/ses-localiser/anat/
!pydeface --verbose --force --outfile /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-TS12/ses-localiser/anat/sub-TS12_ses-localiser_T1w.nii /Users/ethanknights/ownCloud/BIDS_toolStudy/sub-TS12/ses-localiser/anat/sub-TS12_ses-localiser_T1w.nii
  


%---- CREATE EVENTS FILES ----%
rootPath = '/Users/ethanknights/imaging/toolData/scripts/events';
BIDS_root = '/Users/ethanknights/ownCloud/BIDS_toolStudy'

%--tool action--%
diary createToolActionEvents.log
sessID = 'action';
taskN = 'grasp';
prtReadName = fullfile(rootPath,'PRT_toolstudy1.xls')
sheet = 'FinalPRT(2)';

%--Localiser--%
diary createToolLocaliserEvents.log
diary createToolLocaliserMaastrichtEvents.log
sessID = 'localiser';
taskN = 'localiser';
prtReadName = fullfile(rootPath,'PRT_FILE_LOCALIZER.xls')
prtReadName = fullfile(rootPath,'PRT_FILE_LOCALIZER_MAASTRICHT.xlsx')
sheet = 'Sheet1';
  
[~,~,rawData] = xlsread(prtReadName, sheet);
onset = cell2mat(rawData(2:end,3))/1000;
offset = cell2mat(rawData(2:end,4))/1000;
duration = offset-onset;

for p = 5:size(rawData,2)
  thisPRT = rawData(:,p);
  prtName = thisPRT{1}(1:end); 
  sName = prtName(1:4);
  runN = [];
  if strcmp(prtReadName,fullfile(rootPath,'PRT_FILE_LOCALIZER.xls'))
    runN = ['0',num2str(prtName(9))];
  elseif strcmp(prtReadName,fullfile(rootPath,'PRT_FILE_LOCALIZER_MAASTRICHT.xlsx'))
    runN = ['0',num2str(prtName(24))];
  end
  fN = sprintf('%s/sub-%s/ses-%s/func/sub-%s_ses-%s_task-%s_run-%s_events.tsv',...
                BIDS_root,sName,sessID,sName,sessID,taskN,runN)
  tNames = thisPRT(2:end);

  headers = {'onset','duration','offset','trial_type'};
  ev = horzcat([headers;num2cell(onset),num2cell(duration),num2cell(offset),tNames]);

  try
    WriteCellArraytoCSV(ev,fN,'\t','%s')
  catch
    warning(['Could not write events file. Ensure they are not expected in BIDS:',fN])
  end

end
diary off




  %%%---- CLEAN LAPTOP ----%
  %%%rmdir(tmpDir,'s')
  
  
  %export PATH="$PATH://Users/ethanknights/imaging/software"
  
  %cmdStr = sprintf('dcm2bids -d %s -p %s -c %s',tmpDir,sName,configFilePath)
  %dcm2bids -d /Users/ethanknights/imaging/toolData/tmp_dcm2bids/helper -p JR24 -s action -c /Users/ethanknights/imaging/toolData/scripts/config.json -o /Users/ethanknights/imaging/toolData/BIDS
  
  %find /Volumes/Ethan/fMRI_bial/JR24/JR24_raw_A/ST000000_Renamed/SE000008_Run7 -type f -name "*.dcm" -exec cp -v {} /Users/ethanknights/imaging/toolData/tmp/SE000008_Run7/ \;