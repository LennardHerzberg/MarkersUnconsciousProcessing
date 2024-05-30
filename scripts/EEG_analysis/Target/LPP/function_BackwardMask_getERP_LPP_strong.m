function Erp_strong = BackwardMask_getERP_Target_strong_LPP(EEG,channel1,channel2,channel3,range_min,range_max)
  
% Create Epochs from -200ms to 1000 ms
EEG = pop_epoch( EEG, {  'h_h_strong'  'h_n_strong'   'h_s_strong'   'n_h_strong'   'n_n_strong'  'n_s_strong'  's_h_strong'  's_n_strong'   's_s_strong'  },...
    [-0.2  1.2],  'epochinfo', 'yes'); %-Epoche ist jetzt 1.4s lang

% Remove baseline
EEG = pop_rmbase( EEG, [-200   0] ,[]); % 200ms Baseline, gleiche wie bei Auswertung Primer 

% Find Epochs
Epoch = extractfield(EEG.event,'epoch');

% Find stimulus Type
Type = extractfield(EEG.event,'type');

%% Get Index of stimulus

index_h_h_strong = find(strcmp(Type, 'h_h_strong'));
index_h_n_strong = find(strcmp(Type, 'h_n_strong'));
index_h_s_strong = find(strcmp(Type, 'h_s_strong'));

index_s_h_strong = find(strcmp(Type, 's_h_strong'));
index_s_n_strong = find(strcmp(Type, 's_n_strong'));
index_s_s_strong = find(strcmp(Type, 's_s_strong'));

index_n_h_strong = find(strcmp(Type, 'n_h_strong'));
index_n_n_strong = find(strcmp(Type, 'n_n_strong'));
index_n_s_strong = find(strcmp(Type, 'n_s_strong'));


%% Get Trials with respective index

trials_h_h_strong = Epoch(index_h_h_strong);
trials_h_n_strong = Epoch(index_h_n_strong);
trials_h_s_strong = Epoch(index_h_s_strong);

trials_s_h_strong = Epoch(index_s_h_strong);
trials_s_n_strong = Epoch(index_s_n_strong);
trials_s_s_strong = Epoch(index_s_s_strong);

trials_n_h_strong = Epoch(index_n_h_strong);
trials_n_n_strong = Epoch(index_n_n_strong);
trials_n_s_strong = Epoch(index_n_s_strong);


%% Create a mean ERP for all trials 

erp_epoch_h_h_strong = mean(EEG.data(:,:,trials_h_h_strong),3);
erp_epoch_h_n_strong = mean(EEG.data(:,:,trials_h_n_strong),3);
erp_epoch_h_s_strong = mean(EEG.data(:,:,trials_h_s_strong),3);

erp_epoch_s_h_strong = mean(EEG.data(:,:,trials_s_h_strong),3);
erp_epoch_s_n_strong = mean(EEG.data(:,:,trials_s_n_strong),3);
erp_epoch_s_s_strong = mean(EEG.data(:,:,trials_s_s_strong),3);

erp_epoch_n_h_strong = mean(EEG.data(:,:,trials_n_h_strong),3);
erp_epoch_n_n_strong = mean(EEG.data(:,:,trials_n_n_strong),3);
erp_epoch_n_s_strong = mean(EEG.data(:,:,trials_n_s_strong),3);


%% Create a mean for the Channels we are interested in

mean_h_h_strong = mean(erp_epoch_h_h_strong([channel1,channel2,channel3],:),1);
mean_h_n_strong = mean(erp_epoch_h_n_strong([channel1,channel2,channel3],:),1);
mean_h_s_strong = mean(erp_epoch_h_s_strong([channel1,channel2,channel3],:),1);

mean_s_h_strong = mean(erp_epoch_s_h_strong([channel1,channel2,channel3],:),1);
mean_s_n_strong = mean(erp_epoch_s_n_strong([channel1,channel2,channel3],:),1);
mean_s_s_strong = mean(erp_epoch_s_s_strong([channel1,channel2,channel3],:),1);

mean_n_h_strong = mean(erp_epoch_n_h_strong([channel1,channel2,channel3],:),1);
mean_n_n_strong = mean(erp_epoch_n_n_strong([channel1,channel2,channel3],:),1);
mean_n_s_strong = mean(erp_epoch_n_s_strong([channel1,channel2,channel3],:),1);


%% Save ERP

Erp_strong.h_h_strong = mean_h_h_strong;
Erp_strong.h_n_strong = mean_h_n_strong;
Erp_strong.h_s_strong = mean_h_s_strong;

Erp_strong.s_h_strong = mean_s_h_strong;
Erp_strong.s_n_strong = mean_s_n_strong;
Erp_strong.s_s_strong = mean_s_s_strong;

Erp_strong.n_h_strong = mean_n_h_strong;
Erp_strong.n_n_strong = mean_n_n_strong;
Erp_strong.n_s_strong = mean_n_s_strong;



%% Get LPP and Save

h_h_strong_LPPRange = mean_h_h_strong(1,(range_min:range_max)); 
h_n_strong_LPPRange = mean_h_n_strong(1,(range_min:range_max)); 
h_s_strong_LPPRange = mean_h_s_strong(1,(range_min:range_max)); 

s_h_strong_LPPRange = mean_s_h_strong(1,(range_min:range_max)); 
s_n_strong_LPPRange = mean_s_n_strong(1,(range_min:range_max)); 
s_s_strong_LPPRange = mean_s_s_strong(1,(range_min:range_max)); 

n_h_strong_LPPRange = mean_n_h_strong(1,(range_min:range_max)); 
n_n_strong_LPPRange = mean_n_n_strong(1,(range_min:range_max)); 
n_s_strong_LPPRange = mean_n_s_strong(1,(range_min:range_max)); 



%% Save LPP 

Erp_strong.h_h_strong_LPP = max(h_h_strong_LPPRange);
Erp_strong.h_n_strong_LPP = max(h_n_strong_LPPRange);
Erp_strong.h_s_strong_LPP = max(h_s_strong_LPPRange);

Erp_strong.s_h_strong_LPP = max(s_h_strong_LPPRange);
Erp_strong.s_n_strong_LPP = max(s_n_strong_LPPRange);
Erp_strong.s_s_strong_LPP = max(s_s_strong_LPPRange);

Erp_strong.n_h_strong_LPP = max(n_h_strong_LPPRange);
Erp_strong.n_n_strong_LPP = max(n_n_strong_LPPRange);
Erp_strong.n_s_strong_LPP = max(n_s_strong_LPPRange);



%% Only Target
% Get Index of stimulus

index_h_strong = [index_h_h_strong, index_n_h_strong, index_s_h_strong];
index_n_strong = [index_h_n_strong, index_n_n_strong, index_s_n_strong];
index_s_strong = [index_h_s_strong, index_n_s_strong, index_s_s_strong];

index_h_strong_congruent      = index_h_h_strong;
index_h_strong_incongruent    = [index_n_h_strong, index_s_h_strong];
index_s_strong_congruent      = index_s_s_strong;
index_s_strong_incongruent    = [index_n_s_strong, index_h_s_strong];
index_n_strong_congruent      = index_n_n_strong;
index_n_strong_incongruent    = [index_s_n_strong, index_h_n_strong];

index_strong = [index_h_h_strong, index_h_n_strong, index_h_s_strong, index_n_h_strong, index_n_n_strong, index_n_s_strong, index_s_h_strong, index_s_n_strong, index_s_s_strong];

%Get Trials with respective index
trials_h_strong = Epoch(index_h_strong);
trials_n_strong = Epoch(index_n_strong);
trials_s_strong = Epoch(index_s_strong);

trials_h_strong_congruent      = Epoch(index_h_strong_congruent);
trials_h_strong_incongruent    = Epoch(index_h_strong_incongruent);
trials_s_strong_congruent      = Epoch(index_s_strong_congruent);
trials_s_strong_incongruent    = Epoch(index_s_strong_incongruent);
trials_n_strong_congruent      = Epoch(index_n_strong_congruent);
trials_n_strong_incongruent    = Epoch(index_n_strong_incongruent);

trials_strong = Epoch(index_strong);



%Create a mean ERP for all trials
erp_epoch_h_strong = mean(EEG.data(:,:,trials_h_strong),3);
erp_epoch_n_strong = mean(EEG.data(:,:,trials_n_strong),3);
erp_epoch_s_strong = mean(EEG.data(:,:,trials_s_strong),3);

erp_epoch_h_strong_congruent   = mean(EEG.data(:,:,trials_h_strong_congruent),3);
erp_epoch_h_strong_incongruent = mean(EEG.data(:,:,trials_h_strong_incongruent),3);
erp_epoch_s_strong_congruent   = mean(EEG.data(:,:,trials_s_strong_congruent),3);
erp_epoch_s_strong_incongruend = mean(EEG.data(:,:,trials_s_strong_incongruent),3);
erp_epoch_n_strong_congruent   = mean(EEG.data(:,:,trials_n_strong_congruent),3);
erp_epoch_n_strong_incongruent = mean(EEG.data(:,:,trials_n_strong_incongruent),3);

erp_epoch_strong = mean(EEG.data(:,:,trials_strong),3);


%Create a mean for the Channels we are interested in
mean_h_strong = mean(erp_epoch_h_strong([channel1,channel2,channel3],:),1);
mean_n_strong = mean(erp_epoch_n_strong([channel1,channel2,channel3],:),1);
mean_s_strong = mean(erp_epoch_s_strong([channel1,channel2,channel3],:),1);

mean_h_strong_congruent   = mean(erp_epoch_h_strong_congruent([channel1,channel2,channel3],:),1);
mean_h_strong_incongruent = mean(erp_epoch_h_strong_incongruent([channel1,channel2,channel3],:),1);
mean_s_strong_congruent   = mean(erp_epoch_s_strong_congruent([channel1,channel2,channel3],:),1);
mean_s_strong_incongruent = mean(erp_epoch_s_strong_incongruend([channel1,channel2,channel3],:),1);
mean_n_strong_congruent   = mean(erp_epoch_n_strong_congruent([channel1,channel2,channel3],:),1);
mean_n_strong_incongruent = mean(erp_epoch_n_strong_incongruent([channel1,channel2,channel3],:),1);

mean_strong = mean(erp_epoch_strong([channel1,channel2,channel3],:),1);

% Save Erp
Erp_strong.h_strong = mean_h_strong;
Erp_strong.n_strong = mean_n_strong;
Erp_strong.s_strong = mean_s_strong;

Erp_strong.h_strong_congruent   = mean_h_strong_congruent;
Erp_strong.h_strong_incongruent = mean_h_strong_incongruent;
Erp_strong.s_strong_congruent   = mean_s_strong_congruent;
Erp_strong.s_strong_incongruent = mean_s_strong_incongruent;
Erp_strong.n_strong_congruent   = mean_n_strong_congruent;
Erp_strong.n_strong_incongruent = mean_n_strong_incongruent;

Erp_strong.strong = mean_strong;
        

% Get range of LPP 
h_strong_LPPRange = mean_h_strong(1,(range_min:range_max));
n_strong_LPPRange = mean_n_strong(1,(range_min:range_max)); 
s_strong_LPPRange = mean_s_strong(1,(range_min:range_max)); 

h_strong_congruent_LPPRange   = mean_h_strong_congruent(1,(range_min:range_max));
h_strong_incongruent_LPPRange = mean_h_strong_incongruent(1,(range_min:range_max));
s_strong_congruent_LPPRange   = mean_s_strong_congruent(1,(range_min:range_max));
s_strong_incongruent_LPPRange = mean_s_strong_incongruent(1,(range_min:range_max));
n_strong_congruent_LPPRange   = mean_n_strong_congruent(1,(range_min:range_max));
n_strong_incongruent_LPPRange = mean_n_strong_incongruent(1,(range_min:range_max));


strong_LPPRange = mean_strong(1,(range_min:range_max)); 


% Save LPP 
Erp_strong.h_strong_LPP = max(h_strong_LPPRange);
Erp_strong.n_strong_LPP = max(n_strong_LPPRange);
Erp_strong.s_strong_LPP = max(s_strong_LPPRange);


Erp_strong.h_strong_congruent_LPP   = max(h_strong_congruent_LPPRange);
Erp_strong.h_strong_incongruent_LPP = max(h_strong_incongruent_LPPRange);
Erp_strong.s_strong_congruent_LPP   = max(s_strong_congruent_LPPRange);
Erp_strong.s_strong_incongruent_LPP = max(s_strong_incongruent_LPPRange);
Erp_strong.n_strong_congruent_LPP   = max(n_strong_congruent_LPPRange);
Erp_strong.n_strong_incongruent_LPP = max(n_strong_incongruent_LPPRange);


Erp_strong.strong_LPP = max(strong_LPPRange);



% Zum Plotten
Erp_strong.times = EEG.times;



