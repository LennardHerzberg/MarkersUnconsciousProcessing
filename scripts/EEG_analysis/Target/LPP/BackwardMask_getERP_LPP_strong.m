clear all                                                                   % clear workspace 

addpath ('/bif/software/MATLABTOOLS/eeglab2022.1')                          % path eeglab
eeglab; close;                                                              % open eeg lab 

% define datapath 
DataPath = ('/bif/storage/storage1/projects/emocon/Data/EEG');

subjects = dir(fullfile(DataPath, '*_Remove_Bad_Intervals.mat')); 

%Take Only HC                                                             
idx_HC = ismember({subjects.name}, {'sub-004_BackwardMask_Remove_Bad_Intervals.mat','sub-006_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-010_BackwardMask_Remove_Bad_Intervals.mat','sub-011_BackwardMask_Remove_Bad_Intervals.mat','sub-014_BackwardMask_Remove_Bad_Intervals.mat','sub-015_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-017_BackwardMask_Remove_Bad_Intervals.mat','sub-018_BackwardMask_Remove_Bad_Intervals.mat','sub-019_BackwardMask_Remove_Bad_Intervals.mat','sub-021_BackwardMask_Remove_Bad_Intervals.mat','sub-022_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-024_BackwardMask_Remove_Bad_Intervals.mat','sub-025_BackwardMask_Remove_Bad_Intervals.mat','sub-027_BackwardMask_Remove_Bad_Intervals.mat','sub-031_BackwardMask_Remove_Bad_Intervals.mat','sub-032_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-033_BackwardMask_Remove_Bad_Intervals.mat','sub-034_BackwardMask_Remove_Bad_Intervals.mat','sub-041_BackwardMask_Remove_Bad_Intervals.mat','sub-043_BackwardMask_Remove_Bad_Intervals.mat','sub-045_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-046_BackwardMask_Remove_Bad_Intervals.mat','sub-047_BackwardMask_Remove_Bad_Intervals.mat','sub-051_BackwardMask_Remove_Bad_Intervals.mat','sub-052_BackwardMask_Remove_Bad_Intervals.mat','sub-053_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-054_BackwardMask_Remove_Bad_Intervals.mat','sub-056_BackwardMask_Remove_Bad_Intervals.mat','sub-057_BackwardMask_Remove_Bad_Intervals.mat','sub-059_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-062_BackwardMask_Remove_Bad_Intervals.mat','sub-068_BackwardMask_Remove_Bad_Intervals.mat','sub-069_BackwardMask_Remove_Bad_Intervals.mat','sub-070_BackwardMask_Remove_Bad_Intervals.mat','sub-071_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-073_BackwardMask_Remove_Bad_Intervals.mat','sub-074_BackwardMask_Remove_Bad_Intervals.mat','sub-078_BackwardMask_Remove_Bad_Intervals.mat','sub-079_BackwardMask_Remove_Bad_Intervals.mat','sub-083_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-085_BackwardMask_Remove_Bad_Intervals.mat','sub-086_BackwardMask_Remove_Bad_Intervals.mat','sub-088_BackwardMask_Remove_Bad_Intervals.mat','sub-089_BackwardMask_Remove_Bad_Intervals.mat','sub-090_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-091_BackwardMask_Remove_Bad_Intervals.mat','sub-093_BackwardMask_Remove_Bad_Intervals.mat','sub-096_BackwardMask_Remove_Bad_Intervals.mat','sub-101_BackwardMask_Remove_Bad_Intervals.mat','sub-103_BackwardMask_Remove_Bad_Intervals.mat'...
,'sub-105_BackwardMask_Remove_Bad_Intervals.mat'});


healthy_subjects = subjects(idx_HC); % take only HC participants

%% change to channels for LPP!!
channel1 = 17;                                                              % channel Fz
channel2 = 18;                                                              % channel Cz 
channel3 = 19;                                                              % channel Pz

% change to range within ERP (LPP)!!
% Range from 500ms-700ms post target onset --> 0,25*ms=datapoints. 
% short primer presentation (unconscious trials); onset target 283,4ms after beginning epoch, 83.4ms after onset primer 
range_min = 196;                                                            % 200ms Baseline+16,7ms Primer+66,7ms Mask(target onset)+500ms = 783,4ms (195,85 datapoints) post begin of epoch 
range_max = 246;                                                            % 200ms Baseline+16,7ms Primer+66,7ms Mask(target onset)+700ms = 983,4ms (245,85 datapoints) post begin of epoch 

%% HC
% Run the script for HC participants
subjects = healthy_subjects;

i=1; 

for i = 1:1%length(subjects)
    FileName = subjects(i).name;
    filePath = fullfile(DataPath, FileName);
    EEG = pop_loadbva(filePath);                                            % read in EEG data
    subName = FileName(1:7);                                                % get SubName
    
    Erp_strong = BackwardMask_getERP_Target_strong_LPP(EEG,channel1,channel2,channel3,range_min,range_max);

    % To plot ERPs
    erp_neutral_strong(i,:) = Erp_strong.n_strong;                          % neutral target, strong mask (unconscious)
    erp_happy_strong(i,:) = Erp_strong.h_strong;                            % happy target, strong mask (unconscious)
    erp_sad_strong(i,:) = Erp_strong.s_strong;                              % sad target, strong mask (unconscious) 

    erp_strong(i,:) = Erp_strong.strong;

    erp_times = Erp_strong.times;                                             
      
    erp_h_h_strong(i,:) = Erp_strong.h_h_strong;
    erp_h_n_strong(i,:) = Erp_strong.h_n_strong;
    erp_h_s_strong(i,:) = Erp_strong.h_s_strong;
    
    erp_n_n_strong(i,:) = Erp_strong.n_n_strong;
    erp_n_s_strong(i,:) = Erp_strong.n_s_strong;
    erp_n_h_strong(i,:) = Erp_strong.n_h_strong;
    
    erp_s_s_strong(i,:) = Erp_strong.s_s_strong;
    erp_s_n_strong(i,:) = Erp_strong.s_n_strong;
    erp_s_h_strong(i,:) = Erp_strong.s_h_strong;
    
    erp_h_strong_con(i,:)  = Erp_strong.h_strong_congruent;                 % happy target, congruent strong (unconscious) 
    erp_h_strong_incon(i,:) = Erp_strong.h_strong_incongruent;              % happy target, incongruent strong (primer neutral or sad) (unconscious) 
    erp_s_strong_con(i,:)   = Erp_strong.s_strong_congruent;                % sad target, congruent strong (unconscious) 
    erp_s_strong_incon(i,:) = Erp_strong.s_strong_incongruent;              % sad target, incongruent strong (primer happy or neutral) (unconscious) 
    erp_n_strong_con(i,:)   = Erp_strong.n_strong_congruent;                % neutral target, congruent strong (unconscious) 
    erp_n_strong_incon(i,:) = Erp_strong.n_strong_incongruent;              % neutral target, incongruent strong (primer happy or sad) (unconscious) 
    
 %% create table
    
    j=1+(6*(i-1))    
    
    k=j+1
    l=k+1
    m=l+1
    n=m+1
    o=n+1
    
    dataframe{j,1}= subName;
    dataframe{k,1}= subName;
    dataframe{l,1}= subName;
    dataframe{m,1}= subName;
    dataframe{n,1}= subName;
    dataframe{o,1}= subName;
    
    dataframe{j,2}= 'happy';
    dataframe{k,2}= 'happy';
    dataframe{l,2}= 'sad';
    dataframe{m,2}= 'sad';
    dataframe{n,2}= 'neutral';
    dataframe{o,2}= 'neutral';
    
    dataframe{j,3}= 'congruent';
    dataframe{k,3}= 'incongruent';
    dataframe{l,3}= 'congruent';
    dataframe{m,3}= 'incongruent';
    dataframe{n,3}= 'congruent';
    dataframe{o,3}= 'incongruent';
    
    dataframe{j,4}= 'strong';
    dataframe{k,4}= 'strong';
    dataframe{l,4}= 'strong';
    dataframe{m,4}= 'strong';
    dataframe{n,4}= 'strong';
    dataframe{o,4}= 'strong';
    
    dataframe{j,6}= 'happy_strong_congruent';
    dataframe{j,5}= Erp_strong.h_strong_congruent_LPP;

    dataframe{k,6}= 'happy_strong_incongruent';
    dataframe{k,5}= Erp_strong.h_strong_incongruent_LPP;
    
    dataframe{l,6}= 'sad_strong_congruent';
    dataframe{l,5}= Erp_strong.s_strong_congruent_LPP;
    
    dataframe{m,6}= 'sad_strong_incongruent';
    dataframe{m,5}= Erp_strong.s_strong_incongruent_LPP;
    
    dataframe{n,6}='neutral_strong_congruent';
    dataframe{n,5}= Erp_strong.n_strong_congruent_LPP;
    
    dataframe{o,6}='neutral_strong_incongruent';
    dataframe{o,5}= Erp_strong.n_strong_incongruent_LPP; 
    
end

header = {'subName','emotion','congruence','mask','LPP','condition'};
dataframe = [header; dataframe]; 
writecell(dataframe,'/bif/storage/storage1/projects/emocon/Lennard/Scripts/Target/N400_LPP_test/Target_LPP_strong.xlsx');
