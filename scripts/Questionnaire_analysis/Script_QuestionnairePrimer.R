# P100 ####

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
data <- read_excel("Desktop/Questionnaire_P100_N170.xlsx")
View(data)

subName <- data$subName
gender <- data$gender
age <- data$age
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side_R1L2 <- data$side_R1L2
P100 <- data$P100
N170 <- data$N170
TMT <- data$TMT
BVAQ <- data$BVAQ
MWTB <- data$MWTB
WMS_for <- data$WMS_for
WMS_back <- data$WMS_back

# Grafiken plotten 

data$P100 <- as.numeric(data$P100)

#Plot Density
plot(density(data$P100),main="Density estimate of data")

x <- data$P100+100
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
data$side_R1L2   <- factor(data$side_R1L2, ordered = FALSE)


summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))

# einfache Regression
ModelQP100.einfach <- lm(P100 ~ TMT + BVAQ + MWTB + WMS_for + WMS_back, data = data)
summary(ModelQP100.einfach)
anova(ModelQP100.einfach)



# unused
# lmer
ModelQP100.normal <- lmer(P100 ~ TMT + BVAQ + MWTB + WMS_for + WMS_back + (1|subName), data = data)
summary(ModelQP100.normal)
anova(ModelQP100.normal)

# N170 ####

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
data <- read_excel("Desktop/Questionnaire_P100_N170.xlsx")
View(data)

subName <- data$subName
gender <- data$gender
age <- data$age
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side_R1L2 <- data$side_R1L2
P100 <- data$P100
N170 <- data$N170
TMT <- data$TMT
BVAQ <- data$BVAQ
MWTB <- data$MWTB
WMS_for <- data$WMS_for
WMS_back <- data$WMS_back

# Grafiken plotten 

data$N170 <- as.numeric(data$N170)

#Plot Density
plot(density(data$N170),main="Density estimate of data")

x <- data$N170+100
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
data$side_R1L2   <- factor(data$side_R1L2, ordered = FALSE)


summary(data)

options('contrasts')

#Use type III analysis of variance!!! (Laut Thilo ist das wichtig)
options(contrasts = c("contr.sum", "contr.poly"))

# einfache Regression 
ModelQN170.einfach <- lm(N170 ~ TMT + BVAQ + MWTB + WMS_for + WMS_back, data = data)
summary(ModelQN170.einfach)
anova(ModelQN170.einfach)
