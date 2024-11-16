function Erp_weak = BackwardMask_getERP_Target_weak_LPP(EEG,channel1,channel2,channel3,range_min,range_max)
  
% Create Epochs from -200ms to 1200 ms
EEG = pop_epoch( EEG, {  'h_h_weak'  'h_n_weak'  'h_s_weak'   'n_h_weak'   'n_n_weak'  'n_s_weak'  's_h_weak'  's_n_weak'   's_s_weak'  },...
    [-0.2 1.2],  'epochinfo', 'yes'); % epoch is now 1.4s long 

% Remove baseline
EEG = pop_rmbase( EEG, [-200 0] ,[]); %200ms Baseline, identical to primer analysis  

% Find Epochs
Epoch = extractfield(EEG.event,'epoch');

% Find stimulus Type
Type = extractfield(EEG.event,'type');

%% Get Index of stimulus

index_h_h_weak = find(strcmp(Type, 'h_h_weak'));
index_h_n_weak = find(strcmp(Type, 'h_n_weak'));
index_h_s_weak = find(strcmp(Type, 'h_s_weak'));

index_s_h_weak = find(strcmp(Type, 's_h_weak'));
index_s_n_weak = find(strcmp(Type, 's_n_weak'));
index_s_s_weak = find(strcmp(Type, 's_s_weak'));

index_n_h_weak = find(strcmp(Type, 'n_h_weak'));
index_n_n_weak = find(strcmp(Type, 'n_n_weak'));
index_n_s_weak = find(strcmp(Type, 'n_s_weak'));


%% Get Trials with respective index

trials_h_h_weak = Epoch(index_h_h_weak);
trials_h_n_weak = Epoch(index_h_n_weak);
trials_h_s_weak = Epoch(index_h_s_weak);

trials_s_h_weak = Epoch(index_s_h_weak);
trials_s_n_weak = Epoch(index_s_n_weak);
trials_s_s_weak = Epoch(index_s_s_weak);

trials_n_h_weak = Epoch(index_n_h_weak);
trials_n_n_weak = Epoch(index_n_n_weak);
trials_n_s_weak = Epoch(index_n_s_weak);


%% Create a mean ERP for all trials 

erp_epoch_h_h_weak = mean(EEG.data(:,:,trials_h_h_weak),3);
erp_epoch_h_n_weak = mean(EEG.data(:,:,trials_h_n_weak),3);
erp_epoch_h_s_weak = mean(EEG.data(:,:,trials_h_s_weak),3);

erp_epoch_s_h_weak = mean(EEG.data(:,:,trials_s_h_weak),3);
erp_epoch_s_n_weak = mean(EEG.data(:,:,trials_s_n_weak),3);
erp_epoch_s_s_weak = mean(EEG.data(:,:,trials_s_s_weak),3);

erp_epoch_n_h_weak = mean(EEG.data(:,:,trials_n_h_weak),3);
erp_epoch_n_n_weak = mean(EEG.data(:,:,trials_n_n_weak),3);
erp_epoch_n_s_weak = mean(EEG.data(:,:,trials_n_s_weak),3);


%% Create a mean for the Channels we are interested in

mean_h_h_weak = mean(erp_epoch_h_h_weak([channel1,channel2,channel3],:),1);
mean_h_n_weak = mean(erp_epoch_h_n_weak([channel1,channel2,channel3],:),1);
mean_h_s_weak = mean(erp_epoch_h_s_weak([channel1,channel2,channel3],:),1);

mean_s_h_weak = mean(erp_epoch_s_h_weak([channel1,channel2,channel3],:),1);
mean_s_n_weak = mean(erp_epoch_s_n_weak([channel1,channel2,channel3],:),1);
mean_s_s_weak = mean(erp_epoch_s_s_weak([channel1,channel2,channel3],:),1);

mean_n_h_weak = mean(erp_epoch_n_h_weak([channel1,channel2,channel3],:),1);
mean_n_n_weak = mean(erp_epoch_n_n_weak([channel1,channel2,channel3],:),1);
mean_n_s_weak = mean(erp_epoch_n_s_weak([channel1,channel2,channel3],:),1);


%% Save ERP

Erp_weak.h_h_weak = mean_h_h_weak;
Erp_weak.h_n_weak = mean_h_n_weak;
Erp_weak.h_s_weak = mean_h_s_weak;

Erp_weak.s_h_weak = mean_s_h_weak;
Erp_weak.s_n_weak = mean_s_n_weak;
Erp_weak.s_s_weak = mean_s_s_weak;

Erp_weak.n_h_weak = mean_n_h_weak;
Erp_weak.n_n_weak = mean_n_n_weak;
Erp_weak.n_s_weak = mean_n_s_weak;



%% Get LPP and Save

h_h_weak_LPPRange = mean_h_h_weak(1,(range_min:range_max)); 
h_n_weak_LPPRange = mean_h_n_weak(1,(range_min:range_max)); 
h_s_weak_LPPRange = mean_h_s_weak(1,(range_min:range_max)); 

s_h_weak_LPPRange = mean_s_h_weak(1,(range_min:range_max)); 
s_n_weak_LPPRange = mean_s_n_weak(1,(range_min:range_max)); 
s_s_weak_LPPRange = mean_s_s_weak(1,(range_min:range_max)); 

n_h_weak_LPPRange = mean_n_h_weak(1,(range_min:range_max)); 
n_n_weak_LPPRange = mean_n_n_weak(1,(range_min:range_max)); 
n_s_weak_LPPRange = mean_n_s_weak(1,(range_min:range_max)); 



%% Save LPP

Erp_weak.h_h_weak_LPP = max(h_h_weak_LPPRange);
Erp_weak.h_n_weak_LPP = max(h_n_weak_LPPRange);
Erp_weak.h_s_weak_LPP = max(h_s_weak_LPPRange);

Erp_weak.s_h_weak_LPP = max(s_h_weak_LPPRange);
Erp_weak.s_n_weak_LPP = max(s_n_weak_LPPRange);
Erp_weak.s_s_weak_LPP = max(s_s_weak_LPPRange);

Erp_weak.n_h_weak_LPP = max(n_h_weak_LPPRange);
Erp_weak.n_n_weak_LPP = max(n_n_weak_LPPRange);
Erp_weak.n_s_weak_LPP = max(n_s_weak_LPPRange);



%% Only Target
% Get Index of stimulus

index_h_weak = [index_h_h_weak, index_n_h_weak, index_s_h_weak];
index_n_weak = [index_h_n_weak, index_n_n_weak, index_s_n_weak];
index_s_weak = [index_h_s_weak, index_n_s_weak, index_s_s_weak];

index_h_weak_congruent      = index_h_h_weak;
index_h_weak_incongruent    = [index_n_h_weak, index_s_h_weak];
index_s_weak_congruent      = index_s_s_weak;
index_s_weak_incongruent    = [index_n_s_weak, index_h_s_weak];
index_n_weak_congruent      = index_n_n_weak;
index_n_weak_incongruent    = [index_s_n_weak, index_h_n_weak];

index_weak = [index_h_h_weak, index_h_n_weak, index_h_s_weak, index_n_h_weak, index_n_n_weak, index_n_s_weak, index_s_h_weak, index_s_n_weak, index_s_s_weak];

%Get Trials with respective index
trials_h_weak = Epoch(index_h_weak);
trials_n_weak = Epoch(index_n_weak);
trials_s_weak = Epoch(index_s_weak);

trials_h_weak_congruent      = Epoch(index_h_weak_congruent);
trials_h_weak_incongruent    = Epoch(index_h_weak_incongruent);
trials_s_weak_congruent      = Epoch(index_s_weak_congruent);
trials_s_weak_incongruent    = Epoch(index_s_weak_incongruent);
trials_n_weak_congruent      = Epoch(index_n_weak_congruent);
trials_n_weak_incongruent    = Epoch(index_n_weak_incongruent);

trials_weak = Epoch(index_weak);



%Create a mean ERP for all trials
erp_epoch_h_weak = mean(EEG.data(:,:,trials_h_weak),3);
erp_epoch_n_weak = mean(EEG.data(:,:,trials_n_weak),3);
erp_epoch_s_weak = mean(EEG.data(:,:,trials_s_weak),3);

erp_epoch_h_weak_congruent   = mean(EEG.data(:,:,trials_h_weak_congruent),3);
erp_epoch_h_weak_incongruent = mean(EEG.data(:,:,trials_h_weak_incongruent),3);
erp_epoch_s_weak_congruent   = mean(EEG.data(:,:,trials_s_weak_congruent),3);
erp_epoch_s_weak_incongruent = mean(EEG.data(:,:,trials_s_weak_incongruent),3);
erp_epoch_n_weak_congruent   = mean(EEG.data(:,:,trials_n_weak_congruent),3);
erp_epoch_n_weak_incongruent = mean(EEG.data(:,:,trials_n_weak_incongruent),3);

erp_epoch_weak = mean(EEG.data(:,:,trials_weak),3);


%Create a mean for the Channels we are interested in
mean_h_weak = mean(erp_epoch_h_weak([channel1,channel2,channel3],:),1);
mean_n_weak = mean(erp_epoch_n_weak([channel1,channel2,channel3],:),1);
mean_s_weak = mean(erp_epoch_s_weak([channel1,channel2,channel3],:),1);

mean_h_weak_congruent   = mean(erp_epoch_h_weak_congruent([channel1,channel2,channel3],:),1);
mean_h_weak_incongruent = mean(erp_epoch_h_weak_incongruent([channel1,channel2,channel3],:),1);
mean_s_weak_congruent   = mean(erp_epoch_s_weak_congruent([channel1,channel2,channel3],:),1);
mean_s_weak_incongruent = mean(erp_epoch_s_weak_incongruent([channel1,channel2,channel3],:),1);
mean_n_weak_congruent   = mean(erp_epoch_n_weak_congruent([channel1,channel2,channel3],:),1);
mean_n_weak_incongruent = mean(erp_epoch_n_weak_incongruent([channel1,channel2,channel3],:),1);

mean_weak = mean(erp_epoch_weak([channel1,channel2,channel3],:),1);

% Save Erp
Erp_weak.h_weak = mean_h_weak;
Erp_weak.n_weak = mean_n_weak;
Erp_weak.s_weak = mean_s_weak;

Erp_weak.h_weak_congruent   = mean_h_weak_congruent;
Erp_weak.h_weak_incongruent = mean_h_weak_incongruent;
Erp_weak.s_weak_congruent   = mean_s_weak_congruent;
Erp_weak.s_weak_incongruent = mean_s_weak_incongruent;
Erp_weak.n_weak_congruent   = mean_n_weak_congruent;
Erp_weak.n_weak_incongruent = mean_n_weak_incongruent;

Erp_weak.weak = mean_weak;
        

% Get range of LPP
h_weak_LPPRange = mean_h_weak(1,(range_min:range_max));
n_weak_LPPRange = mean_n_weak(1,(range_min:range_max)); 
s_weak_LPPRange = mean_s_weak(1,(range_min:range_max)); 

h_weak_congruent_LPPRange   = mean_h_weak_congruent(1,(range_min:range_max));
h_weak_incongruent_LPPRange = mean_h_weak_incongruent(1,(range_min:range_max));
s_weak_congruent_LPPRange   = mean_s_weak_congruent(1,(range_min:range_max));
s_weak_incongruent_LPPRange = mean_s_weak_incongruent(1,(range_min:range_max));
n_weak_congruent_LPPRange   = mean_n_weak_congruent(1,(range_min:range_max));
n_weak_incongruent_LPPRange = mean_n_weak_incongruent(1,(range_min:range_max));


weak_LPPRange = mean_weak(1,(range_min:range_max)); 


% Save LPP
Erp_weak.h_weak_LPP = max(h_weak_LPPRange);
Erp_weak.n_weak_LPP = max(n_weak_LPPRange);
Erp_weak.s_weak_LPP = max(s_weak_LPPRange);


Erp_weak.h_weak_congruent_LPP   = max(h_weak_congruent_LPPRange);
Erp_weak.h_weak_incongruent_LPP = max(h_weak_incongruent_LPPRange);
Erp_weak.s_weak_congruent_LPP   = max(s_weak_congruent_LPPRange);
Erp_weak.s_weak_incongruent_LPP = max(s_weak_incongruent_LPPRange);
Erp_weak.n_weak_congruent_LPP   = max(n_weak_congruent_LPPRange);
Erp_weak.n_weak_incongruent_LPP = max(n_weak_incongruent_LPPRange);


Erp_weak.weak_LPP = max(weak_LPPRange);


% to plot
Erp_weak.times = EEG.times;
