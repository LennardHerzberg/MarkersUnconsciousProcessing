clear all                                                                   % workspace leeren

addpath ('/bif/software/MATLABTOOLS/eeglab2022.1')                          % pfad für eeglab
eeglab; close;                                                                      % eeg lab öffnen

% definiere Datenpfad
DataPath = ('/bif/storage/storage1/projects/emocon/Data/EEG');

subjects = dir(fullfile(DataPath, '*_Remove_Bad_Intervals.mat')); 

% Take Only HC                                                              
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

%% Change to channels for Mismatch negativity ERP!!
channel1 = 59;                                                              % channel PO7 (left)
channel2 = 15;                                                              % channel P7 (left)

% Range within ERP...
% Range von 200ms-400ms für vMMN sind --> 0,25*ms=datapoints. 
range_min = 154;                                                            % 200ms Baseline+150ms Primer+66,7ms Mask(hier Zeitpunkt Target)+200ms = 616,7ms (154,175 datapoints)
range_max = 204;                                                            % 200ms Baseline+150ms Primer+66,7ms Mask(hier Zeitpunkt Target)+400ms = 816,7ms (204,175 datapoints)

%% HC

% Run the script for HC participants
subjects = healthy_subjects;

i=1;  

for i = 1:length(subjects)
    FileName = subjects(i).name;
    filePath = fullfile(DataPath, FileName);
    EEG = pop_loadbva(filePath);                                            % read in EEG data
    subName = FileName(1:7);                                                % get SubName
    
    Erp_weak = BackwardMask_getERP_Target_weak_hemisphere_final(EEG,channel1,channel2,range_min,range_max);


    erp_neutral_weak(i,:) = Erp_weak.n_weak;                                % neutral target, weak mask
    erp_happy_weak(i,:) = Erp_weak.h_weak;                                  % happy target, weak mask
    erp_sad_weak(i,:) = Erp_weak.s_weak;                                    % sad target, weak mask 

    erp_weak(i,:) = Erp_weak.weak;

    erp_times = Erp_weak.times;                                             
    
    erp_h_h_weak(i,:) = Erp_weak.h_h_weak;
    erp_h_n_weak(i,:) = Erp_weak.h_n_weak;
    erp_h_s_weak(i,:) = Erp_weak.h_s_weak;
    
    erp_n_n_weak(i,:) = Erp_weak.n_n_weak;
    erp_n_s_weak(i,:) = Erp_weak.n_s_weak;
    erp_n_h_weak(i,:) = Erp_weak.n_h_weak;
    
    erp_s_s_weak(i,:) = Erp_weak.s_s_weak;
    erp_s_n_weak(i,:) = Erp_weak.s_n_weak;
    erp_s_h_weak(i,:) = Erp_weak.s_h_weak;
    
    erp_h_weak_con(i,:)  = Erp_weak.h_weak_congruent;                       % happy target, congruent weak 
    erp_h_weak_incon(i,:) = Erp_weak.h_weak_incongruent;                    % happy target, incongruent weak (primer neutral or sad)
    erp_s_weak_con(i,:)   = Erp_weak.s_weak_congruent;                      % sad target, congruent weak 
    erp_s_weak_incon(i,:) = Erp_weak.s_weak_incongruent;                    % sad target, incongruent weak (primer happy or neutral)
    erp_n_weak_con(i,:)   = Erp_weak.n_weak_congruent;                      % neutral target, congruent weak 
    erp_n_weak_incon(i,:) = Erp_weak.n_weak_incongruent;                    % neutral target, incongruent weak (primer happy or sad)
    
    %% Tabelle
    
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
    
    dataframe{j,4}= 'weak';
    dataframe{k,4}= 'weak';
    dataframe{l,4}= 'weak';
    dataframe{m,4}= 'weak';
    dataframe{n,4}= 'weak';
    dataframe{o,4}= 'weak';
        
    dataframe{j,6}= 'happy_weak_congruent';
    dataframe{j,5}= Erp_weak.h_weak_congruent_vMMN;

    dataframe{k,6}= 'happy_weak_incongruent';
    dataframe{k,5}= Erp_weak.h_weak_incongruent_vMMN;
    
    dataframe{l,6}= 'sad_weak_congruent';
    dataframe{l,5}= Erp_weak.s_weak_congruent_vMMN;
    
    dataframe{m,6}= 'sad_weak_incongruent';
    dataframe{m,5}= Erp_weak.s_weak_incongruent_vMMN;
    
    dataframe{n,6}='neutral_weak_congruent';
    dataframe{n,5}= Erp_weak.n_weak_congruent_vMMN;
    
    dataframe{o,6}='neutral_weak_incongruent';
    dataframe{o,5}= Erp_weak.n_weak_incongruent_vMMN; 

    dataframe{j,7}= 'left';
    dataframe{k,7}= 'left';
    dataframe{l,7}= 'left';
    dataframe{m,7}= 'left';
    dataframe{n,7}= 'left';
    dataframe{o,7}= 'left';

end

header = {'subName','emotion','congruence','mask','vMMN','condition','side'};
dataframe = [header; dataframe]; 
writecell(dataframe,'/bif/storage/storage1/projects/emocon/Lennard/Target_weak_left_final.xlsx');

%% Plot %% 

% % plot happy target congruent vs incongruent
% figure,
% plot(erp_times,mean(erp_h_weak_con,1),'Color','#FF0000','LineWidth',1.5); hold on;
% plot(erp_times,mean(erp_h_weak_incon,1),'Color','#0072BD','LineWidth',1.5); hold off;
% ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
% legend('congruent weak','incongruent weak','Location','northeast');
% legend('boxoff'); title(['Happy target with congruent/incongruent primer, ', 'PO7/P7']);  
% xlim([-250 820]); xlabel('Amplitude (uV)', 'Position', [0 9],'FontSize', 8); ylabel('Time(ms)', 'Position',[0 0],'FontSize', 8); grid on; box off
% set(gcf,'Position',[15 15 750 600])
% 
% % plot sad target congruent vs incongruent
% figure,
% plot(erp_times,mean(erp_s_weak_con,1),'Color','#FF0000','LineWidth',1.5); hold on;
% plot(erp_times,mean(erp_s_weak_incon,1),'Color','#0072BD','LineWidth',1.5); hold off;
% ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
% legend('congruent weak','incongruent weak','Location','northeast');
% legend('boxoff'); title(['Sad target with congruent/incongruent primer, ', 'PO7/P7']);  
% xlim([-250 820]); xlabel('Amplitude (uV)', 'Position', [0 9],'FontSize', 8); ylabel('Time(ms)', 'Position',[0 0],'FontSize', 8); grid on; box off
% set(gcf,'Position',[15 15 750 600])
% 
% % plot neutral target congruent vs incongruent
% figure,
% plot(erp_times,mean(erp_n_weak_con,1),'Color','#FF0000','LineWidth',1.5); hold on;
% plot(erp_times,mean(erp_n_weak_incon,1),'Color','#0072BD','LineWidth',1.5); hold off;
% ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';
% legend('congruent weak','incongruent weak','Location','northeast');
% legend('boxoff'); title(['Neutral target with congruent/incongruent primer, ', 'PO7/P7']);  
% xlim([-250 820]); xlabel('Amplitude (uV)', 'Position', [0 9],'FontSize', 8); ylabel('Time(ms)', 'Position',[0 0],'FontSize', 8); grid on; box off
% set(gcf,'Position',[15 15 750 600])