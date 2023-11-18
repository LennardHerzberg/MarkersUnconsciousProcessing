clear all                                                                   % workspace leeren

addpath ('/bif/software/MATLABTOOLS/eeglab2022.1')                          % pfad für eeglab
eeglab                                                                      % eeg lab öffnen

% definiere Datenpfad
DataPath = ('/bif/storage/storage1/projects/emocon/Data/EEG');

subjects = dir(fullfile(DataPath, '*Remove_Bad_Intervals.mat')); 

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

channel1 = 60;                                                              % channel PO8
channel2 = 16;                                                              % channel P8

% Range for P100 within ERP...
% Range von 80ms-130ms für P100 sind --> 0,25*ms=datapoints. 
range_min = 70;                                                             % 200ms Baseline+80ms=280ms(70 datapoints)
range_max = 83;                                                             % 200+130=320(82,5 datapoints)

subjects = healthy_subjects; 

i=1;

for i = 1:length(subjects)
    %% Datenset einlesen
    FileName = subjects(i).name;
    filePath = fullfile(DataPath, FileName);
    EEG = pop_loadbva(filePath);                                            % read in EEG data
    subName = FileName(1:7);                                                % get SubName
    
    Erp = function_BackwardMask_getERP_P100_hemisphere_final(EEG,channel1,channel2, range_min, range_max);
    
    erp_neutral_strong(i,:) = Erp.n_strong;
    erp_happy_strong(i,:) = Erp.h_strong;
    erp_sad_strong(i,:) = Erp.s_strong;
    
    erp_neutral_weak(i,:) = Erp.n_weak;
    erp_happy_weak(i,:) = Erp.h_weak;
    erp_sad_weak(i,:) = Erp.s_weak;
    
    erp_times = Erp.times;
    
    %% Tabelle erstellen 
 
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
    
    dataframe{j,2}= 'bewusst';
    dataframe{k,2}= 'bewusst';
    dataframe{l,2}= 'bewusst';
    dataframe{m,2}= 'unbewusst';
    dataframe{n,2}= 'unbewusst';
    dataframe{o,2}= 'unbewusst';
    
    dataframe{j,3}= 'happy';
    dataframe{k,3}= 'sad';
    dataframe{l,3}= 'neutral';
    dataframe{m,3}= 'happy';
    dataframe{n,3}= 'sad';
    dataframe{o,3}= 'neutral';
    
    dataframe{j,5}= 'happy_bewusst';
    dataframe{j,4}= Erp.h_weak_P100;

    dataframe{k,5}= 'sad_bewusst';
    dataframe{k,4}= Erp.s_weak_P100;
    
    dataframe{l,5}= 'neutral_bewusst'
    dataframe{l,4}= Erp.n_weak_P100;
    
    dataframe{m,5}= 'happy_unbewusst'
    dataframe{m,4}= Erp.h_strong_P100;
    
    dataframe{n,5}='sad_unbewusst'
    dataframe{n,4}= Erp.s_strong_P100;
    
    dataframe{o,5}='neutral_unbewusst'
    dataframe{o,4}= Erp.n_strong_P100; 
    
end

%% Excel Tabelle aus dataframe erstellen 
% füge Kopfzeile hinzu 
header = {'subName','mask','emotion','P100_right','condition'};

dataframe = [header; dataframe]; 

% Erstellt excel Tabelle aus dataframe
writecell(dataframe,'/bif/storage/storage1/projects/emocon/Lennard/Primer_P100_right_final.xlsx');
