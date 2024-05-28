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

library(haven)
data <- read_sav("~/Desktop/Doktorarbeit/EmoCon/Auswertung/Tabellen/Primer/Primer_P100_leftright.sav")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side <- data$side

# Grafiken plotten ####

data$P100 <- as.numeric(data$P100)

#Plot Density
plot(density(data$P100),main="Density estimate of data")

x <- data$P100+100
den <- density(x)
dat <- data.frame(x = den$x, y = den$y)

# Fit distributions
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
data$condition[data$condition == "happy_unconscious"] <- 1
data$condition[data$condition == "neutral_unconscious"] <- 2
data$condition[data$condition == "sad_unconscious"] <- 3
data$condition[data$condition == "happy_conscious"] <- 4
data$condition[data$condition == "neutral_conscious"] <- 5
data$condition[data$condition == "sad_conscious"] <- 6

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$mask           <- factor(data$mask, ordered = FALSE)
data$emotion           <- factor(data$emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$side          <- factor(data$side, ordered = FALSE)

summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))


# lmer kein Interaktionseffekt bei mask (statt correlated random slope und intercept nur noch random intercept)
Model1 <- lmer(P100 ~ mask + emotion + gender + side + age + (1|subName),
                      data = data)

summary(Model1)
anova(Model1)

isSingular(Model1, tol=1e-4)

# lmer Interaktionseffekt bei mask 
ModelT.normal <- lmer(P100 ~ mask*emotion + gender + side + age + (1|subName),
                      data = data)

summary(ModelT.normal)
anova(ModelT.normal)

isSingular(ModelT.normal, tol = 1e-4)

anova(Model1, ModelT.normal)

# Model 1 (ohne Interaktionseffekt), da AIC/BIC besser als Model T (mit Interaktion)
library(effects)
effectsmodel1<-allEffects(Model1)
plot(effectsmodel1)
print(effectsmodel1)

Model1PairwiseE <- emmeans(Model1, pairwise ~ emotion)
Model1PairwiseG <- emmeans(Model1, pairwise ~ gender)
Model1PairwiseS <- emmeans(Model1, pairwise ~ side)
Model1PairwiseM <- emmeans(Model1, pairwise ~ mask) 

Model1PairwiseE
Model1PairwiseG
Model1PairwiseS
Model1PairwiseM 

effect_gender <- Effect("gender", Model1)
effect_mask <- Effect("mask", Model1)
effect_side <- Effect("side", Model1)
plot(effect_gender)
plot(effect_mask)
plot(effect_side)

# Type II ANOVA
anova(Model1, type=2, ddf="Kenward-Roger")
