#Load in library
library(lme4)       # mixed, version 1.1-26
library(lmerTest)   # to get p values, version 3.1-3 
library(ggplot2)    # graphics, version 3.3.5
library(interactions) #version 1.1.5
library(tidyverse)  # needed for data manipulation.#needed to view data, version 1.3.1
library(jtools)     # post hoc tests, version 2.1.4
library(readxl)     # read excel, version 1.3.1
library(lme4)      # load mixed model library
library(lmerTest)  # library providing p-values for mixed models in lme4
library(tidyverse) # library with various tools (e.g. ggplot, pivot_long, pipes etc.)
library(emmeans)   # library for post-hoc tests
library(pbkrtest)  # needed for post-hoc tests in mixed models
library(haven)    # import/export SPSS files 
library(apaTables) # create American Psychological Association Style Tables
library(effects)   # effects displays for linear models 
library(carData)  # companion to applied regression datasets 


library(readxl)
data <- read_excel("Desktop/N400_ges.xlsx")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side <- data$location
congruence <-data$congruence

# Grafiken plotten ####

data$N400 <- as.numeric(data$N400)

#Plot Density
plot(density(data$N400),main="Density estimate of data")

x <- data$N400+100
den <- density(x)
dat <- data.frame(x = den$x, y = den$y) 

#Fit distributions
library(fitdistrplus)
fit.weibull <- fitdist(x, "weibull")
fit.normal <- fitdist(x,"norm")
fit.gamma <- fitdist(x, "gamma", lower = c(0, 0))
# fit.poisson <- fitdist(x, "pois")


# Compare fits graphically
plot.legend <- c("Weibull", "Gamma","Normal")
par(mfrow = c(2, 2)) #show 4 pictures
denscomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
qqcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
cdfcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
ppcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)


# LMM ####

#Get datatype
summary(data) 

#Define variables
data$condition[data$condition == "happy_strong_congruent"] <- 1
data$condition[data$condition == "neutral_strong_congruent"] <- 2
data$condition[data$condition == "sad_strong_congruent"] <- 3
data$condition[data$condition == "happy_strong_incongruent"] <- 4
data$condition[data$condition == "neutral_strong_incongruent"] <- 5
data$condition[data$condition == "sad_strong_incongruent"] <- 6
data$condition[data$condition == "happy_weak_congruent"] <- 7
data$condition[data$condition == "neutral_weak_congruent"] <- 8
data$condition[data$condition == "sad_weak_congruent"] <- 9
data$condition[data$condition == "happy_weak_incongruent"] <- 10
data$condition[data$condition == "neutral_weak_incongruent"] <- 11
data$condition[data$condition == "sad_weak_incongruent"] <- 12

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$mask           <- factor(data$mask, ordered = FALSE)
data$emotion           <- factor(data$emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$congruence      <- factor(data$congruence, ordered = FALSE)
data$location           <- factor(data$location, ordered = FALSE)

summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist es wichtig, dass man das so macht)
options(contrasts = c("contr.sum", "contr.poly"))

# lmer Model 
Model1 <- lmer(N400 ~ congruence + emotion + mask + location + (1|subName),
                                   data = data)
summary(Model1)
anova(Model1)

library(effects)
effectsmodelN400<-allEffects(Model1)
plot(effectsmodelN400)
print(effectsmodelN400)

ModelN400PairwiseE <- emmeans(Model1, pairwise ~ emotion)
ModelN400PairwiseL <- emmeans(Model1, pairwise ~ location)
ModelN400PairwiseM <- emmeans(Model1, pairwise ~ mask)
ModelN400PairwiseC <- emmeans(Model1, pairwise ~ congruence)

ModelN400PairwiseE
ModelN400PairwiseL
ModelN400PairwiseM 
ModelN400PairwiseC

effect_congruence <- Effect("congruence", Model1)
effect_emotion <- Effect("emotion", Model1)
effect_mask <- Effect("mask", Model1)
effect_location <- Effect("location", Model1)
plot(effect_congruence)
plot(effect_emotion)
plot(effect_mask)
plot(effect_location)

anova(Model1, type=2, ddf="Kenward-Roger")

# unused ####
ModelN400.test <- lmer(N400 ~ congruence + emotion + emotion*congruence + emotion*mask + gender + mask + location + age + (1|subName),
                         data = data)
summary(ModelN400.test)
anova(ModelN400.test)

anova(ModelN400.normal,ModelN400.test)

ModelN400.normal <- lmer(N400 ~ congruence + emotion + gender + mask + location + age + (1|subName),
                         data = data)
summary(ModelN400.normal)
anova(ModelN400.normal)

library(effects)
effectsmodelN400<-allEffects(ModelN400.normal)
plot(effectsmodelN400)
print(effectsmodelN400)

ModelN400PairwiseE <- emmeans(ModelN400.normal, pairwise ~ emotion)
ModelN400PairwiseG <- emmeans(ModelN400.normal, pairwise ~ gender)
ModelN400PairwiseL <- emmeans(ModelN400.normal, pairwise ~ location)
ModelN400PairwiseM <- emmeans(ModelN400.normal, pairwise ~ mask)
ModelN400PairwiseC <- emmeans(ModelN400.normal, pairwise ~ congruence)

ModelN400PairwiseE
ModelN400PairwiseG
ModelN400PairwiseL
ModelN400PairwiseM 
ModelN400PairwiseC

# Type II ANOVA
anova(ModelN400.normal, type=2, ddf="Kenward-Roger")
