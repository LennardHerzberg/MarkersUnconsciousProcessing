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


# Graphics ####

data$accuracy <- as.numeric(data$accuracy)

# #Plot Density
# plot(density(data$accuracy),main="Density estimate of data")
# 
# x <- data$accuracy
# den <- density(x)
# dat <- data.frame(x = den$x, y = den$y) 
# 
# #Fit distributions
# library(fitdistrplus)
# fit.weibull <- fitdist(x, "weibull")
# fit.normal <- fitdist(x,"norm")
# fit.gamma <- fitdist(x, "gamma", lower = c(0, 0))
# # fit.poisson <- fitdist(x, "pois")
# 
# 
# # Compare fits graphically
# plot.legend <- c("Weibull", "Gamma","Normal")
# par(mfrow = c(2, 2)) #show 4 pictures
# denscomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
# qqcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
# cdfcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)
# ppcomp(list(fit.weibull, fit.gamma, fit.normal), fitcol = c("red", "blue","green"), legendtext = plot.legend)


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

#### Boxplot with scatter points #### 

library(lme4)         # mixed model package
library(lmerTest)     # library providing p-values for mixed models in lme4
library(readxl)       # read excel
library(ggplot2)      # graphics
library(emmeans)      # library for post-hoc tests
library(pbkrtest)     # needed for post-hoc tests in mixed models
library(jtools)       # post hoc tests
library(interactions) 
library(effects)      # estimate effects
library(apaTables)
library(dplyr)
library(tidyr)
library(readr)
library(fitdistrplus)
library(openxlsx)
library(afex) 
library(cowplot)
library(prism)

# Assuming 'model' is your fitted GLMM model and 'df' is your original dataset

# Generate predictions from the model
data$predicted_values <- predict(ModelP, type = "response")

# Plot the predicted values using ggplot
# congruence 
plot1 <- ggplot(data, 
                aes(x = consciousness, 
                    y = accuracy, 
                    fill = consciousness)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = accuracy),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Conscious" = "blue3",
                               "Unconscious" = "deepskyblue")) +
  #theme_prism() +
  theme_minimal() +
  theme(legend.position = "none",                          
        axis.text.x = element_text(angle = 0, 
                                   #hjust = 1, 
                                   #vjust = 1, 
                                   size = 16),
        axis.text.y = element_text(size = 16),       # Update y-axis label size
        axis.title.y = element_text(size = 16),       # Update y-axis title size
        axis.title.x = element_text(size = 16, margin = margin(t = 12))) +
  labs(title = "", y = "Accuracy", x = "Consciousness") 

plot1

# emotion 
plot2 <- ggplot(data, 
                aes(x = target_emotion, 
                    y = accuracy, 
                    fill = target_emotion)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = accuracy),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Happy" = "darkorchid1",
                               "Neutral" = "yellow2",
                               "Sad" = "#FF6666")) +
  #theme_prism() +
  theme_minimal() +
  theme(legend.position = "none",                           
        axis.text.x = element_text(angle = 0, 
                                   #hjust = 1, 
                                   #vjust = 1, 
                                   size = 16),
        axis.text.y = element_text(size = 16),       # Update y-axis label size
        axis.title.y = element_text(size = 16),       # Update y-axis title size
        axis.title.x = element_text(size = 16, margin = margin(t = 12))) +
  labs(title = "", y = "Accuracy", x = "Emotion") 

plot2

# congruence
plot3 <- ggplot(data, 
                aes(x = congruence, 
                    y = accuracy, 
                    fill = congruence)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = accuracy),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Congruent" = "azure2",
                               "Incongruent" = "darkgrey")) +
  #theme_prism() +
  theme_minimal() +
  theme(legend.position = "none",                             
        axis.text.x = element_text(angle = 0, 
                                   #hjust = 1, 
                                   #vjust = 1, 
                                   size = 16),
        axis.text.y = element_text(size = 16),       # Update y-axis label size
        axis.title.y = element_text(size = 16),       # Update y-axis title size
        axis.title.x = element_text(size = 16, margin = margin(t = 12))) +
  labs(title = "", y = "Accuracy", x = "Congruence") 

plot3

## combine plots 
#install.packages("patchwork")
library(patchwork)

# Combine the three plots and add labels
combined_plot <- (plot1 + plot2 + plot3) + 
  plot_annotation(tag_levels = 'A') &       #  # Automatically labels A, B, C
  theme(plot.tag = element_text(size = 16))  # Set tag font size to 16

combined_plot