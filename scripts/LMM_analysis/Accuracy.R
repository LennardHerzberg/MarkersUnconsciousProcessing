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
library(Matrix)

library(readxl)
data <- read_excel("Desktop/Accuracy_ges.xlsx")
View(data)

subName <- data$subName
gender <- data$gender
age <- data$age
primer_emotion <- data$primer_emotion
target_emotion <- data$target_emotion
consciousness <- data$consciousness
condition <- data$condition
accuracy <- data$accuracy
congruency <- data$congruency


# Grafiken plotten ####

data$accuracy <- as.numeric(data$accuracy)

#Plot Density
plot(density(data$accuracy),main="Density estimate of data")

x <- data$accuracy
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


# GLMM ####

#Get datatype
summary(data) 

#Define variables
data$condition[data$condition == "happy_happy_unconscious"] <- 1
data$condition[data$condition == "happy_happy_conscious"] <- 2
data$condition[data$condition == "happy_sad_unconscious"] <- 3
data$condition[data$condition == "happy_sad_conscious"] <- 4
data$condition[data$condition == "happy_neutral_unconscious"] <- 5
data$condition[data$condition == "happy_neutral_conscious"] <- 6
data$condition[data$condition == "sad_happy_unconscious"] <- 7
data$condition[data$condition == "sad_happy_conscious"] <- 8
data$condition[data$condition == "sad_sad_unconscious"] <- 9
data$condition[data$condition == "sad_sad_conscious"] <- 10
data$condition[data$condition == "sad_neutral_unconscious"] <- 11
data$condition[data$condition == "sad_neutral_conscious"] <- 12
data$condition[data$condition == "neutral_happy_unconscious"] <- 13
data$condition[data$condition == "neutral_happy_conscious"] <- 14
data$condition[data$condition == "neutral_sad_unconscious"] <- 15
data$condition[data$condition == "neutral_sad_conscious"] <- 16
data$condition[data$condition == "neutral_neutral_unconscious"] <- 17
data$condition[data$condition == "neutral_neutral_conscious"] <- 18

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$consciousness          <- factor(data$consciousness, ordered = FALSE)
data$primer_emotion           <- factor(data$primer_emotion, ordered = FALSE)
data$target_emotion           <- factor(data$target_emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$congruence           <- factor(data$congruence, ordered = FALSE)

summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))

# Model quasipoisson
library(MASS)
ModelP <- glmmPQL(accuracy ~ target_emotion + consciousness + congruence + age + gender, random = ~ 1|subName, 
                    family = quasipoisson(link = "log") , data = data)
summary(ModelP)
ModelP$contrasts

# Post hoc Tests
library(effects)
effectsmodel<-allEffects(ModelP)
plot(effectsmodel)
print(effectsmodel)

Model1PairwiseE <- emmeans(ModelP, pairwise ~ target_emotion)
Model1PairwiseC <- emmeans(ModelP, pairwise ~ consciousness)
Model1PairwiseS <- emmeans(ModelP, pairwise ~ congruence)
Model1PairwiseG <- emmeans(ModelP, pairwise ~ gender)
Model1PairwiseT <- emmeans(ModelP, pairwise ~ target_emotion)

Model1PairwiseE
Model1PairwiseC
Model1PairwiseS
Model1PairwiseG 
Model1PairwiseT

effect_congruence <- Effect("congruence", ModelP)
effect_emotion <- Effect("target_emotion", ModelP)
effect_consciousness <- Effect("consciousness", ModelP)
plot(effect_congruence)
plot(effect_emotion)
plot(effect_consciousness)


# unused ####


Model.glm <- glm(accuracy ~ target_emotion + congruency + gender + age + consciousness, 
                 family = poisson())
summary(Model.glm)
anova(Model.glm)

# Model Gamma 
ModelG <- glmer(accuracy~ primer_emotion + consciousness + congruency + age + gender + (1|subName), 
                 family = Gamma(link = "log") , data = data)
summary(ModelG)

# Model Weibull
library(glmmTMB)
ModelWei <- glmmTMB(accuracy~ primer_emotion + consciousness + congruency + age + gender + (1|subName), 
                    family = genpois , data = data)


weibull_family <- list(
  family = "weibull",
  link = "identity",  # Link-Funktion für die Weibull-Verteilung
  theta.link = "log" # Link-Funktion für die Skalenparameter
)

new_vcov <- vcov.merMod(ModelAcc.family, use.hessian = FALSE)
if (!is.positive.definite(new_vcov)) {
  new_vcov <- nearPD(new_vcov)$mat
}

summary(ModelAcc.family, corr = FALSE, correlation = FALSE, vcov = new_vcov)

# Test Model family 
ModelAcc.family <- glmer(accuracy ~ primer_emotion + consciousness + congruency + age + gender + (1|subName), data = data)
summary(ModelAcc.family)
anova(ModelAcc.family)


# Normal Verteilung
ModelAcc.normal <- lmer(accuracy ~ primer_emotion + consciousness + target_emotion + age + gender + congruency + (1|subName), data = data)
summary(ModelAcc.normal)
anova(ModelAcc.normal)







# Test einfache lineare Regression
ModelAcc.einfach <- lm(accuracy ~ primer_emotion + consciousness + age + gender + congruency, data = data)
summary(ModelAcc.einfach)
anova(ModelAcc.einfach)


# Weibull Verteilung 
ModelAcc.weibull <- glmer(accuracy ~ primer_emotion + consciousness + target_emotion + age + gender + congruency + (1|subName), data = data)
summary(ModelAcc.weibull)
anova(ModelAcc.weibull)


library(effects)
effectsmodelAcc<-allEffects(ModelAcc.normal)
plot(effectsmodelAcc)
print(effectsmodelAcc)

ModelAccPairwiseP <- emmeans(ModelAcc.normal, pairwise ~ primer_emotion)
ModelAccPairwiseG <- emmeans(ModelAcc.normal, pairwise ~ gender)
ModelAccPairwiseT <- emmeans(ModelAcc.normal, pairwise ~ target_emotion)
ModelAccPairwiseC <- emmeans(ModelAcc.normal, pairwise ~ consciousness)

ModelAccPairwiseP
ModelAccPairwiseG
ModelAccPairwiseT
ModelAccPairwiseC 

# Type II ANOVA
anova(ModelAcc.normal, type=2, ddf="Kenward-Roger")


# Repeated measures ANOVA
model <- aov(accuracy ~ primer_emotion * consciousness + target_emotion + target_emotion * consciousness, data = data)

# Summary of ANOVA
summary(model)

# Post-hoc tests (e.g., Tukey's HSD)
library(TukeyHSD)
posthoc <- TukeyHSD(model)
print(posthoc)