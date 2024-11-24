function Erp = function_BackwardMask_getERP_N170_hemisphere_final(EEG,channel1,channel2, range_min, range_max)
  
 
% Create Epochs from -200ms to 800 ms
EEG = pop_epoch( EEG, {  'h_h_strong'  'h_h_weak'  'h_n_strong'  'h_n_weak'  'h_s_strong'  'h_s_weak'  'n_h_strong'  'n_h_weak'  'n_n_strong'  'n_n_weak'  'n_s_strong'  'n_s_weak'  's_h_strong'  's_h_weak'  's_n_strong'  's_n_weak'  's_s_strong'  's_s_weak'  },...
    [-0.2  0.8],  'epochinfo', 'yes');

% Remove baseline
EEG = pop_rmbase( EEG, [-200 0] ,[]);

% Find Epochs
Epoch = extractfield(EEG.event,'epoch');

% Find stimulus Type
Type = extractfield(EEG.event,'type');

%% Get Index of stimulus

% conscious
index_h_h_weak = find(strcmp(Type, 'h_h_weak'));
index_h_n_weak = find(strcmp(Type, 'h_n_weak'));
index_h_s_weak = find(strcmp(Type, 'h_s_weak'));

index_s_h_weak = find(strcmp(Type, 's_h_weak'));
index_s_n_weak = find(strcmp(Type, 's_n_weak'));
index_s_s_weak = find(strcmp(Type, 's_s_weak'));

index_n_h_weak = find(strcmp(Type, 'n_h_weak'));
index_n_n_weak = find(strcmp(Type, 'n_n_weak'));
index_n_s_weak = find(strcmp(Type, 'n_s_weak'));

% unconscious
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
% conscious
trials_h_h_weak = Epoch(index_h_h_weak);
trials_h_n_weak = Epoch(index_h_n_weak);
trials_h_s_weak = Epoch(index_h_s_weak);

trials_s_h_weak = Epoch(index_s_h_weak);
trials_s_n_weak = Epoch(index_s_n_weak);
trials_s_s_weak = Epoch(index_s_s_weak);

trials_n_h_weak = Epoch(index_n_h_weak);
trials_n_n_weak = Epoch(index_n_n_weak);
trials_n_s_weak = Epoch(index_n_s_weak);

% unconscious
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
% conscious
erp_epoch_h_h_weak = mean(EEG.data(:,:,trials_h_h_weak),3);
erp_epoch_h_n_weak = mean(EEG.data(:,:,trials_h_n_weak),3);
erp_epoch_h_s_weak = mean(EEG.data(:,:,trials_h_s_weak),3);

erp_epoch_s_h_weak = mean(EEG.data(:,:,trials_s_h_weak),3);
erp_epoch_s_n_weak = mean(EEG.data(:,:,trials_s_n_weak),3);
erp_epoch_s_s_weak = mean(EEG.data(:,:,trials_s_s_weak),3);

erp_epoch_n_h_weak = mean(EEG.data(:,:,trials_n_h_weak),3);
erp_epoch_n_n_weak = mean(EEG.data(:,:,trials_n_n_weak),3);
erp_epoch_n_s_weak = mean(EEG.data(:,:,trials_n_s_weak),3);

% unconscious
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
% conscious
mean_h_h_weak = mean(erp_epoch_h_h_weak([channel1,channel2],:),1);
mean_h_n_weak = mean(erp_epoch_h_n_weak([channel1,channel2],:),1);
mean_h_s_weak = mean(erp_epoch_h_s_weak([channel1,channel2],:),1);

mean_s_h_weak = mean(erp_epoch_s_h_weak([channel1,channel2],:),1);
mean_s_n_weak = mean(erp_epoch_s_n_weak([channel1,channel2],:),1);
mean_s_s_weak = mean(erp_epoch_s_s_weak([channel1,channel2],:),1);

mean_n_h_weak = mean(erp_epoch_n_h_weak([channel1,channel2],:),1);
mean_n_n_weak = mean(erp_epoch_n_n_weak([channel1,channel2],:),1);
mean_n_s_weak = mean(erp_epoch_n_s_weak([channel1,channel2],:),1);

% unconscious
mean_h_h_strong = mean(erp_epoch_h_h_strong([channel1,channel2],:),1);
mean_h_n_strong = mean(erp_epoch_h_n_strong([channel1,channel2],:),1);
mean_h_s_strong = mean(erp_epoch_h_s_strong([channel1,channel2],:),1);

mean_s_h_strong = mean(erp_epoch_s_h_strong([channel1,channel2],:),1);
mean_s_n_strong = mean(erp_epoch_s_n_strong([channel1,channel2],:),1);
mean_s_s_strong = mean(erp_epoch_s_s_strong([channel1,channel2],:),1);

mean_n_h_strong = mean(erp_epoch_n_h_strong([channel1,channel2],:),1);
mean_n_n_strong = mean(erp_epoch_n_n_strong([channel1,channel2],:),1);
mean_n_s_strong = mean(erp_epoch_n_s_strong([channel1,channel2],:),1);

%% Save ERP
% conscious
Erp.h_h_weak = mean_h_h_weak;
Erp.h_n_weak = mean_h_n_weak;
Erp.h_s_weak = mean_h_s_weak;

Erp.s_h_weak = mean_s_h_weak;
Erp.s_n_weak = mean_s_n_weak;
Erp.s_s_weak = mean_s_s_weak;

Erp.n_h_weak = mean_n_h_weak;
Erp.n_n_weak = mean_n_n_weak;
Erp.n_s_weak = mean_n_s_weak;

% unconscious
Erp.h_h_strong = mean_h_h_strong;
Erp.h_n_strong = mean_h_n_strong;
Erp.h_s_strong = mean_h_s_strong;

Erp.s_h_strong = mean_s_h_strong;
Erp.s_n_strong = mean_s_n_strong;
Erp.s_s_strong = mean_s_s_strong;

Erp.n_h_strong = mean_n_h_strong;
Erp.n_n_strong = mean_n_n_strong;
Erp.n_s_strong = mean_n_s_strong;

%% Get N170 and Save

% conscious
h_h_weak_N170Range = mean_h_h_weak(1,(range_min:range_max)); 
h_n_weak_N170Range = mean_h_n_weak(1,(range_min:range_max)); 
h_s_weak_N170Range = mean_h_s_weak(1,(range_min:range_max)); 

s_h_weak_N170Range = mean_s_h_weak(1,(range_min:range_max)); 
s_n_weak_N170Range = mean_s_n_weak(1,(range_min:range_max)); 
s_s_weak_N170Range = mean_s_s_weak(1,(range_min:range_max)); 

n_h_weak_N170Range = mean_n_h_weak(1,(range_min:range_max)); 
n_n_weak_N170Range = mean_n_n_weak(1,(range_min:range_max)); 
n_s_weak_N170Range = mean_n_s_weak(1,(range_min:range_max)); 

% unconscious
h_h_strong_N170Range = mean_h_h_strong(1,(range_min:range_max)); 
h_n_strong_N170Range = mean_h_n_strong(1,(range_min:range_max)); 
h_s_strong_N170Range = mean_h_s_strong(1,(range_min:range_max)); 

s_h_strong_N170Range = mean_s_h_strong(1,(range_min:range_max)); 
s_n_strong_N170Range = mean_s_n_strong(1,(range_min:range_max)); 
s_s_strong_N170Range = mean_s_s_strong(1,(range_min:range_max)); 

n_h_strong_N170Range = mean_n_h_strong(1,(range_min:range_max)); 
n_n_strong_N170Range = mean_n_n_strong(1,(range_min:range_max)); 
n_s_strong_N170Range = mean_n_s_strong(1,(range_min:range_max)); 

%% Save N170
% conscious
Erp.h_h_weak_N170 = min(h_h_weak_N170Range);
Erp.h_n_weak_N170 = min(h_n_weak_N170Range);
Erp.h_s_weak_N170 = min(h_s_weak_N170Range);

Erp.s_h_weak_N170 = min(s_h_weak_N170Range);
Erp.s_n_weak_N170 = min(s_n_weak_N170Range);
Erp.s_s_weak_N170 = min(s_s_weak_N170Range);

Erp.n_h_weak_N170 = min(n_h_weak_N170Range);
Erp.n_n_weak_N170 = min(n_n_weak_N170Range);
Erp.n_s_weak_N170 = min(n_s_weak_N170Range);

% unconscious
Erp.h_h_strong_N170 = min(h_h_strong_N170Range);
Erp.h_n_strong_N170 = min(h_n_strong_N170Range);
Erp.h_s_strong_N170 = min(h_s_strong_N170Range);

Erp.s_h_strong_N170 = min(s_h_strong_N170Range);
Erp.s_n_strong_N170 = min(s_n_strong_N170Range);
Erp.s_s_strong_N170 = min(s_s_strong_N170Range);

Erp.n_h_strong_N170 = min(n_h_strong_N170Range);
Erp.n_n_strong_N170 = min(n_n_strong_N170Range);
Erp.n_s_strong_N170 = min(n_s_strong_N170Range);

%% Only Primer
% Get Index of stimulus
index_h_weak = [index_h_h_weak, index_h_n_weak, index_h_s_weak];
index_n_weak = [index_n_h_weak, index_n_n_weak, index_n_s_weak];
index_s_weak = [index_s_h_weak, index_s_n_weak, index_s_s_weak];
index_h_strong = [index_h_h_strong, index_h_n_strong, index_h_s_strong];
index_n_strong = [index_n_h_strong, index_n_n_strong, index_n_s_strong];
index_s_strong = [index_s_h_strong, index_s_n_strong, index_s_s_strong];

index_conscious = [index_h_h_weak, index_h_n_weak, index_h_s_weak,index_n_h_weak, index_n_n_weak, index_n_s_weak,index_s_h_weak, index_s_n_weak, index_s_s_weak];
index_unconscious = [index_h_h_strong, index_h_n_strong, index_h_s_strong, index_n_h_strong, index_n_n_strong, index_n_s_strong,index_s_h_strong, index_s_n_strong, index_s_s_strong];


% Get Trials with respective index
trials_h_weak = Epoch(index_h_weak);
trials_n_weak = Epoch(index_n_weak);
trials_s_weak = Epoch(index_s_weak);
trials_h_strong = Epoch(index_h_strong);
trials_n_strong = Epoch(index_n_strong);
trials_s_strong = Epoch(index_s_strong);

trials_conscious = Epoch(index_conscious);
trials_unconscious = Epoch(index_unconscious);

% Create a mean ERP for all trials
erp_epoch_h_weak = mean(EEG.data(:,:,trials_h_weak),3);
erp_epoch_n_weak = mean(EEG.data(:,:,trials_n_weak),3);
erp_epoch_s_weak = mean(EEG.data(:,:,trials_s_weak),3);
erp_epoch_h_strong = mean(EEG.data(:,:,trials_h_strong),3);
erp_epoch_n_strong = mean(EEG.data(:,:,trials_n_strong),3);
erp_epoch_s_strong = mean(EEG.data(:,:,trials_s_strong),3);

erp_epoch_conscious = mean(EEG.data(:,:,trials_conscious),3);
erp_epoch_unconscious = mean(EEG.data(:,:,trials_unconscious),3);


% Create a mean for the Channels we are interested in
mean_h_weak = mean(erp_epoch_h_weak([channel1,channel2],:),1);
mean_n_weak = mean(erp_epoch_n_weak([channel1,channel2],:),1);
mean_s_weak = mean(erp_epoch_s_weak([channel1,channel2],:),1);

mean_h_strong = mean(erp_epoch_h_strong([channel1,channel2],:),1);
mean_n_strong = mean(erp_epoch_n_strong([channel1,channel2],:),1);
mean_s_strong = mean(erp_epoch_s_strong([channel1,channel2],:),1);

mean_conscious = mean(erp_epoch_conscious([channel1,channel2],:),1);
mean_unconscious = mean(erp_epoch_unconscious([channel1,channel2],:),1);


% Save Erp
Erp.h_weak = mean_h_weak;
Erp.n_weak = mean_n_weak;
Erp.s_weak = mean_s_weak;

Erp.h_strong = mean_h_strong;
Erp.n_strong = mean_n_strong;
Erp.s_strong = mean_s_strong;

Erp.conscious = mean_conscious;
Erp.unconscious = mean_unconscious;


h_weak_N170Range = mean_h_weak(1,(range_min:range_max));
n_weak_N170Range = mean_n_weak(1,(range_min:range_max)); 
s_weak_N170Range = mean_s_weak(1,(range_min:range_max)); 

h_strong_N170Range = mean_h_strong(1,(range_min:range_max));
n_strong_N170Range = mean_n_strong(1,(range_min:range_max)); 
s_strong_N170Range = mean_s_strong(1,(range_min:range_max)); 

% Save N170
Erp.h_weak_N170 = min(h_weak_N170Range);
Erp.n_weak_N170 = min(n_weak_N170Range);
Erp.s_weak_N170 = min(s_weak_N170Range);

Erp.h_strong_N170 = min(h_strong_N170Range);
Erp.n_strong_N170 = min(n_strong_N170Range);
Erp.s_strong_N170 = min(s_strong_N170Range);

% to plot 
Erp.times = EEG.times;
