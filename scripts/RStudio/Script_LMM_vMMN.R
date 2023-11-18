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
data <- read_sav("~/Desktop/Doktorarbeit/EmoCon/Auswertung/Tabellen/Target/Target_vMMN_leftright_strongweak.sav")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side <- data$side
congruence <-data$congruence

# Grafiken plotten ####

data$vMMN <- as.numeric(data$vMMN)

#Plot Density
plot(density(data$vMMN),main="Density estimate of data")

x <- data$vMMN+100
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
data$side           <- factor(data$side, ordered = FALSE)

summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist es wichtig, dass man das so macht)
options(contrasts = c("contr.sum", "contr.poly"))


# lmer kein Interaktionseffekt (statt correlated random slope und intercept nur noch random intercept)
Model3.normal <- lmer(vMMN ~ congruence + emotion + gender + mask + side + age + (1|subName),
                      data = data)

summary(Model3.normal)
anova(Model3.normal)

isSingular(Model3.normal, tol=1e-4)

# lmer Interaktionseffekt bei congruence (ebenfalls nur random intercept)
Model6.normal <- lmer(vMMN ~ congruence*emotion + gender + mask + side + age + (1|subName),
                      data = data)

summary(Model6.normal)
anova(Model6.normal)

isSingular(Model6.normal, tol = 1e-4)

anova(Model3.normal, Model6.normal)

# lmer Interaktionseffekt bei mask*emotion (ebenfalls nur random intercept)
Model7.normal <- lmer(vMMN ~ mask*emotion + gender + congruence + side + age + (1|subName),
                      data = data)

summary(Model7.normal)
anova(Model7.normal)

isSingular(Model7.normal, tol = 1e-4)

# Model 3 (ohne Interaktionseffekt), da AIC/BIC besser als Model 6 (mit Interaktion)
library(effects)
effectsmodel3<-allEffects(Model3.normal)
plot(effectsmodel3)
print(effectsmodel3)

Model3PairwiseE <- emmeans(Model3.normal, pairwise ~ emotion)
Model3PairwiseG <- emmeans(Model3.normal, pairwise ~ gender)
Model3PairwiseS <- emmeans(Model3.normal, pairwise ~ side)
Model3PairwiseM <- emmeans(Model3.normal, pairwise ~ mask)
Model3PairwiseC <- emmeans(Model3.normal, pairwise ~ congruence)

Model3PairwiseE
Model3PairwiseG
Model3PairwiseS
Model3PairwiseM 
Model3PairwiseC

# Type II ANOVA
anova(Model3.normal, type=2, ddf="Kenward-Roger")