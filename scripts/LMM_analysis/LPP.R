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
data <- read_excel("Desktop/LPP_ges.xlsx")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
congruence <-data$congruence

# Graphics ####

data$LPP <- as.numeric(data$LPP)

#Plot Density
plot(density(data$LPP),main="Density estimate of data")

x <- data$LPP+100
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
data$condition[data$condition == "happy_unconscious_congruent"] <- 1
data$condition[data$condition == "neutral_unconscious_congruent"] <- 2
data$condition[data$condition == "sad_unconscious_congruent"] <- 3
data$condition[data$condition == "happy_unconscious_incongruent"] <- 4
data$condition[data$condition == "neutral_unconscious_incongruent"] <- 5
data$condition[data$condition == "sad_unconscious_incongruent"] <- 6
data$condition[data$condition == "happy_conscious_congruent"] <- 7
data$condition[data$condition == "neutral_conscious_congruent"] <- 8
data$condition[data$condition == "sad_conscious_congruent"] <- 9
data$condition[data$condition == "happy_conscious_incongruent"] <- 10
data$condition[data$condition == "neutral_conscious_incongruent"] <- 11
data$condition[data$condition == "sad_conscious_incongruent"] <- 12

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$mask           <- factor(data$mask, ordered = FALSE)
data$emotion           <- factor(data$emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$congruence      <- factor(data$congruence, ordered = FALSE)


summary(data)

options('contrasts')

options(contrasts = c("contr.sum", "contr.poly"))

# lmer
Model4 <- lmer(LPP ~ congruence + emotion + mask + (1|subName),
                        data = data)
summary(Model4)
anova(Model4)


library(effects)
effectsmodelLPP<-allEffects(Model4)
plot(effectsmodelLPP)
print(effectsmodelLPP)

effect_congruence <- Effect("congruence", Model4)
effect_emotion <- Effect("emotion", Model4)
effect_mask <- Effect("mask", Model4)
plot(effect_congruence)
plot(effect_emotion)
plot(effect_mask)

ModelLPPPairwiseE <- emmeans(Model4, pairwise ~ emotion)
ModelLPPPairwiseM <- emmeans(Model4, pairwise ~ mask)
ModelLPPPairwiseC <- emmeans(Model4, pairwise ~ congruence)

ModelLPPPairwiseE
ModelLPPPairwiseM 
ModelLPPPairwiseC

# Type II ANOVA
anova(Model4, type=2, ddf="Kenward-Roger")
