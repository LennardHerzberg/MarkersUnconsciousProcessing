# N400 ####

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
data <- read_excel("Desktop/Questionnaire_N400.xlsx")
View(data)

subName <- data$subName
congruence <- data$congruence
gender <- data$gender
age <- data$age
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
location <- data$location
N400 <- data$N400
TMT <- data$TMT
BVAQ <- data$BVAQ
MWTB <- data$MWTB
WMS_for <- data$WMS_for
WMS_back <- data$WMS_back

# Grafiken plotten

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


# LMM 

#Get datatype
summary(data) 

#Define variables
data$condition[data$condition == "happy_strong_congruent"] <- 1
data$condition[data$condition == "happy_strong_incongruent"] <- 2
data$condition[data$condition == "sad_strong_congruent"] <- 3
data$condition[data$condition == "sad_strong_incongruent"] <- 4
data$condition[data$condition == "neutral_strong_congruent"] <- 5
data$condition[data$condition == "neutral_strong_incongruent"] <- 6
data$condition[data$condition == "happy_weak_congruent"] <- 7
data$condition[data$condition == "happy_weak_incongruent"] <- 8
data$condition[data$condition == "sad_weak_congruent"] <- 9
data$condition[data$condition == "sad_weak_incongruent"] <- 10
data$condition[data$condition == "neutral_weak_congruent"] <- 11
data$condition[data$condition == "neutral_weak_incongruent"] <- 12

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$mask           <- factor(data$mask, ordered = FALSE)
data$emotion           <- factor(data$emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$location   <- factor(data$location, ordered = FALSE)
data$congruence    <- factor(data$congruence, ordered = FALSE)


summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))

# einfache Regression
ModelQN400.einfach <- lm(N400 ~ TMT + BVAQ + MWTB + WMS_for + WMS_back, data = data)
summary(ModelQN400.einfach)
anova(ModelQN400.einfach)

# LPP ####

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
data <- read_excel("Desktop/Questionnaire_LPP.xlsx")
View(data)

subName <- data$subName
congruence <- data$congruence
gender <- data$gender
age <- data$age
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
LPP <- data$LPP
TMT <- data$TMT
BVAQ <- data$BVAQ
MWTB <- data$MWTB
WMS_for <- data$WMS_for
WMS_back <- data$WMS_back

# Grafiken plotten 

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


# LMM 

#Get datatype
summary(data) 

#Define variables
data$condition[data$condition == "happy_strong_congruent"] <- 1
data$condition[data$condition == "happy_strong_incongruent"] <- 2
data$condition[data$condition == "sad_strong_congruent"] <- 3
data$condition[data$condition == "sad_strong_incongruent"] <- 4
data$condition[data$condition == "neutral_strong_congruent"] <- 5
data$condition[data$condition == "neutral_strong_incongruent"] <- 6
data$condition[data$condition == "happy_weak_congruent"] <- 7
data$condition[data$condition == "happy_weak_incongruent"] <- 8
data$condition[data$condition == "sad_weak_congruent"] <- 9
data$condition[data$condition == "sad_weak_incongruent"] <- 10
data$condition[data$condition == "neutral_weak_congruent"] <- 11
data$condition[data$condition == "neutral_weak_incongruent"] <- 12

#Factorise variables
data$subName           <- factor(data$subName, ordered = FALSE)
data$gender           <- factor(data$gender, ordered = FALSE)
data$mask           <- factor(data$mask, ordered = FALSE)
data$emotion           <- factor(data$emotion, ordered = FALSE)
data$condition           <- factor(data$condition, ordered = FALSE)
data$congruence    <- factor(data$congruence, ordered = FALSE)


summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))

# einfache Regression
ModelQLPP.einfach <- lm(LPP ~ TMT + BVAQ + MWTB + WMS_for + WMS_back, data = data)
summary(ModelQLPP.einfach)
anova(ModelQLPP.einfach)