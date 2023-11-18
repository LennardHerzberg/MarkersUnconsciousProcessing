# Identifying electrophysiological markers for unconscious emotion processing: an EEG data analysis 
  
## Table of contents
* [General info](#general-info)
    * [Authors](#authors)
    * [Publication](#OSF)
    * [License](#license)
* [Experimental design](#experimental-design)
* [Folder description](#folder-description)
* [Technologies](#technologies)

## General info 
This work is part of a simultaneous EEG-fMRI study which includes more data that will be published elsewhere (for more information please see https://github.com/JuliaSchraeder/SubconsciousBias). 

The study investigates on the topic of conscious and unconsonscious processing of emotional facial expressions by analyzing EEG data of 52 healthy participants. The experimental setup consists of a modified backward masked emotional conflict task, allowing to examine the effect of consciousness as well as the impact of emotional conflict on the processing of emotional facial expressions. Three different event-related potentials were used for analysis (P100/N170 for research on the effect of consciousness on emotional face processing, vMMN for the effect of emotional conflict). 

#### Authors 
Lennard Herzberg 1, Julia Schräder 1,2, Han-Gue Jo 3, Ute Habel 1,2, Lisa Wagels 1,2

* <sub> 1 Department of Psychiatry, Psychotherapy and Psychosomatics, Medical Faculty, Uniklinik RWTH Aachen, Pauwelsstraße 30, 52074 Aachen, Germany <sub/>
* <sub> 2 Institue of Neuroscience and medicine: JARA-Institure Brain Structure Function Relationship (INM 10), Research Center Jülich, Jülich, Germany <sub/>
* <sub> 3 School of Computer Information and Communication Engineering, Kunsan National University, Gunsan, Korea <sub/>


#### OSF

[osf.io/mscz5](https://osf.io/bfrky)

#### License 

CC-By Attribution 4.0 International 

## Experimental design 

Images of 36 different faces (taken from the FACES database) showing different facial expressions (happy, sad, or neutral) were presented in a modified backward masked emotinoal conflict task. Using PsychoPy3 software, the images were shown against a grey background at the center of an LCD monitor (120 Hz refresh rate). In total, 360 trials were presented in pseudorandomized order. 
At the beginning of each trial, a fixation cross was presented for a duration of 300 ms (36 frames), followed by a primer image. The primer was either presented for 16.7 ms (2 frames, below threshold for conscious perception) or 150 ms (18 frames, above threshold for conscious perception). The prime stimuli were then followed by a scrambled mask presented for 66.7 ms (8 frames). After that, a target image was displayed for a duration of 300 ms, followed by a response screen presented for 1.5s. Participants were asked to rate the emotion of the target face as fast and accurately as possible using three response buttons placed at their right hand (index finger for "sad", middle finger for "neutral", ring finger for "happy"). 
Aiming to study the effect of emotional conflict on face processing, trials showing the same emotion between primer and target face were considered congruent trials, while trials with different emotions between primer and target were considered incongruent trials. 

## Folder description 

* `data` includes data used for LMM calculation, scalp topography maps
* `scripts` includes scripts used for EEG data, LMM calculation, scalp topography maps

## Technologies 
Project is created with: 
* PsychoPy3: version v2020.2.4
* RStudio: version 2022.12.0.353
* Python 3
* Matlab: version 2020b
