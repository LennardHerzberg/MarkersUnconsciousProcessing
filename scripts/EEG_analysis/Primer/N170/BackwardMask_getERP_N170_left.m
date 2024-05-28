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

channel1 = 59;                                                              % channel PO7
channel2 = 15;                                                              % channel P7

% Range for N170 within ERP...
% Range von 150ms-200ms für N170 sind --> 0,25*ms=datapoints. 
range_min = 88;                                                             % 200ms Baseline+150ms=350ms(87,5 datapoints)
range_max = 100;                                                            % 200+200=400(100 datapoints)

subjects = healthy_subjects;

i=1;

for i = 1:length(subjects)
    %% Datenset einlesen
    FileName = subjects(i).name;
    filePath = fullfile(DataPath, FileName);
    EEG = pop_loadbva(filePath);                                            % read in EEG data
    subName = FileName(1:7);                                                % get SubName
    
    Erp = function_BackwardMask_getERP_N170_hemisphere_final(EEG,channel1,channel2, range_min, range_max);
    
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
    dataframe{j,4}= Erp.h_weak_N170;

    dataframe{k,5}= 'sad_bewusst';
    dataframe{k,4}= Erp.s_weak_N170;
    
    dataframe{l,5}= 'neutral_bewusst'
    dataframe{l,4}= Erp.n_weak_N170;
    
    dataframe{m,5}= 'happy_unbewusst'
    dataframe{m,4}= Erp.h_strong_N170;
    
    dataframe{n,5}='sad_unbewusst'
    dataframe{n,4}= Erp.s_strong_N170;
    
    dataframe{o,5}='neutral_unbewusst'
    dataframe{o,4}= Erp.n_strong_N170; 
    
end

%% Excel Tabelle aus dataframe erstellen 
% füge Kopfzeile hinzu 
header = {'subName','mask','emotion','N170_left','condition'};

dataframe = [header; dataframe]; 

% Erstellt excel Tabelle aus dataframe
writecell(dataframe,'/bif/storage/storage1/projects/emocon/Lennard/Primer_N170_left_final.xlsx');

%% Grafik plotten
% Unbewusst figure gesamt 
figure,
plot(erp_times,mean(erp_neutral_strong,1),'b'); hold on;
plot(erp_times,mean(erp_happy_strong,1),'r');
plot(erp_times,mean(erp_sad_strong,1),'k'); hold off;

legend('neutral','happy','sad','Location','northwest');
legend('boxoff'); title(['P100 and N170, ', 'strongly masked trials, ', 'PO7+P7']);  box off
xlim([-200 800]); xlabel('Time(ms)'); ylabel('Amplitude (uV)'); grid off;
ylim([-3 10])

% Unbewusst figure Ausschnitt 
% figure,
% plot(erp_times,mean(erp_neutral_strong,1),'b'); hold on;
% plot(erp_times,mean(erp_happy_strong,1),'r');
% plot(erp_times,mean(erp_sad_strong,1),'k'); hold off;
% 
% legend('neutral','happy','sad','Location','northeast');
% legend('boxoff'); title(['P100 and N170, ', 'strongly masked trials, ', 'PO7+P7']);  box off
% xlim([-200 800]); grid off;
% ylim([-3 10])


% Bewusst figure gesamt 
figure,
plot(erp_times,mean(erp_neutral_weak,1),'b'); hold on;
plot(erp_times,mean(erp_happy_weak,1),'r');
plot(erp_times,mean(erp_sad_weak,1),'k'); hold off;

legend('neutral','happy','sad','Location','northwest');
legend('boxoff'); title(['P100 and N170, ', 'weakly masked trials, ', 'PO7+P7']);  box off
xlim([-200 800]); xlabel('Time(ms)'); ylabel('Amplitude (uV)'); grid off;
ylim([-3 10])

% Bewusst figure Ausschnitt 
% figure,
% plot(erp_times,mean(erp_neutral_weak,1),'b'); hold on;
% plot(erp_times,mean(erp_happy_weak,1),'r');
% plot(erp_times,mean(erp_sad_weak,1),'k'); hold off;
% 
% legend('neutral','happy','sad','Location','northeast');
% legend('boxoff'); title(['P100 and N170, ', 'weakly masked trials, ', 'PO7+P7']);  box off
% xlim([-200 800]); grid off;
% ylim([-3 10])




