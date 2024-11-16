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
data <- read_xlsx("~/Desktop/Doktorarbeit/EmoCon/Auswertung/Tabellen/Primer/Primer_N170_leftright.xlsx")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side <- data$side

# # Graphics ####
# 
# data$N170 <- as.numeric(data$N170)
# 
# #Plot Density
# plot(density(data$N170),main="Density estimate of data")
# 
# x <- data$N170+100
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
data$side           <- factor(data$side, ordered = FALSE)

summary(data)

options('contrasts')

options(contrasts = c("contr.sum", "contr.poly"))


# lmer no interaction effect 
Model2.normal <- lmer(N170 ~ mask + emotion + gender + side + age + (1|subName),
                      data = data)

summary(Model2.normal)
anova(Model2.normal)

isSingular(Model2.normal, tol=1e-4)

# lmer interaction effect mask*emotion
Model5.normal <- lmer(N170 ~ mask*emotion + gender + side + age + (1|subName),
                      data = data)

summary(Model5.normal)
anova(Model5.normal)

isSingular(Model5.normal, tol = 1e-4)

anova(Model2.normal, Model5.normal)

# Model 2 (without interaction), since AIC/BIC better than Model 5 (with interaction)
library(effects)
effectsmodel2<-allEffects(Model2.normal)
plot(effectsmodel2)
print(effectsmodel2)

Model2PairwiseE <- emmeans(Model2.normal, pairwise ~ emotion)
Model2PairwiseG <- emmeans(Model2.normal, pairwise ~ gender)
Model2PairwiseS <- emmeans(Model2.normal, pairwise ~ side)
Model2PairwiseM <- emmeans(Model2.normal, pairwise ~ mask)

Model2PairwiseE
Model2PairwiseG
Model2PairwiseS
Model2PairwiseM 

effect_gender <- Effect("gender", Model2.normal)
effect_mask <- Effect("mask", Model2.normal)
effect_side <- Effect("side", Model2.normal)
effect_age <- Effect("age", Model2.normal)
effect_emotion <- Effect("emotion", Model2.normal)
plot(effect_gender)
plot(effect_mask)
plot(effect_side)
plot(effect_age)
plot(effect_emotion)

# Type II ANOVA
anova(Model2.normal, type=2, ddf="Kenward-Roger")

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

# Generate predictions from the model
data$predicted_values <- predict(Model2.normal, type = "response")

# Plot the predicted values using ggplot
# mask 
plot1 <- ggplot(data, 
                aes(x = mask, 
                    y = N170, 
                    fill = mask)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = N170),                      # Jitter points of predicted values 
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
  labs(title = "", y = "N170", x = "Mask") 

plot1

# emotion 
plot2 <- ggplot(data, 
                aes(x = emotion, 
                    y = N170, 
                    fill = emotion)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = N170),                      # Jitter points of predicted values 
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
  labs(title = "", y = "N170", x = "Emotion") 

plot2

# sex
plot3 <- ggplot(data, 
                aes(x = gender, 
                    y = N170, 
                    fill = gender)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = N170),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Female" = "azure2",
                               "Male" = "darkgrey")) +
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
  labs(title = "", y = "N170", x = "Sex") 

plot3

# hemisphere  
plot4 <- ggplot(data, 
                aes(x = side, 
                    y = N170, 
                    fill = side)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = N170),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Left" = "azure2",
                               "Right" = "darkgrey")) +
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
  labs(title = "", y = "N170", x = "Hemisphere") 

plot4

# age 
plot5 <- ggplot(data, 
                aes(x = age,     
                    y = N170)) +       # Fill based on continuous age values
  geom_point(size = 0.4) + 
  geom_smooth(method="lm", color = "darkslategrey") + 
  ##ggpubr::theme_pubr()+
  ##scale_fill_gradient(low = "lightgreen", high = "lightgreen") +  
  theme_classic(base_size = 16) +
  theme(
    legend.position = "none",                             
    axis.text.x = element_text(angle = 0, size = 16),
    axis.text.y = element_text(size = 16),       
    axis.title.y = element_text(size = 16),      
    axis.title.x = element_text(size = 16, margin = margin(t = 12))
  ) +
  labs(title = "", y = "N170", x = "Age")

plot5

# combine plots 
#install.packages("patchwork")
library(patchwork)

# Combine the three plots and add labels
combined_plot <- (plot1 + plot2 + plot3 + plot4 + plot5) + 
  plot_annotation(tag_levels = 'A') &       #  # Automatically labels A, B, C
  theme(plot.tag = element_text(size = 16))  # Set tag font size to 16

combined_plot

# effect sizes ####
library(MuMIn)
r2 <- r.squaredGLMM(Model2.normal)
print(r2)
library(effectsize)
effect_size <- eta_squared(Model2.normal)
print(effect_size)

# Load necessary libraries for calculating R?
library(performance)

# Calculate R? for the full model
r2_full_Model2 <- r2(Model2.normal)$R2_marginal
cat("R? Full Model (Model2.normal):", r2_full_Model2, "\n")

# Function to calculate Cohen's f?
calculate_f2 <- function(full_model, reduced_model) {
  r2_full <- r2(full_model)$R2_marginal
  r2_reduced <- r2(reduced_model)$R2_marginal
  f2 <- (r2_full - r2_reduced) / (1 - r2_full)
  return(f2)
}

# Calculate Cohen's f? for each fixed effect in Model2.normal

# 1. Effect Size for 'mask'
Model2_no_mask <- update(Model2.normal, . ~ . - mask)
f2_mask <- calculate_f2(Model2.normal, Model2_no_mask)
cat("Cohen's f? for 'mask':", f2_mask, "\n")

# 2. Effect Size for 'emotion'
Model2_no_emotion <- update(Model2.normal, . ~ . - emotion)
f2_emotion <- calculate_f2(Model2.normal, Model2_no_emotion)
cat("Cohen's f? for 'emotion':", f2_emotion, "\n")

# 3. Effect Size for 'gender'
Model2_no_gender <- update(Model2.normal, . ~ . - gender)
f2_gender <- calculate_f2(Model2.normal, Model2_no_gender)
cat("Cohen's f? for 'gender':", f2_gender, "\n")

# 4. Effect Size for 'side'
Model2_no_side <- update(Model2.normal, . ~ . - side)
f2_side <- calculate_f2(Model2.normal, Model2_no_side)
cat("Cohen's f? for 'side':", f2_side, "\n")

# 5. Effect Size for 'age'
Model2_no_age <- update(Model2.normal, . ~ . - age)
f2_age <- calculate_f2(Model2.normal, Model2_no_age)
cat("Cohen's f? for 'age':", f2_age, "\n")

# Confidence intervals Model 
confint(Model2.normal, method="profile")

#### Power analysis #####
install.packages("simr")
library(simr)
posthoc_power_mask <- powerSim(Model2.normal, nsim=1000, test = fixed("mask"))
print(posthoc_power_mask)
posthoc_power_emotion <- powerSim(Model2.normal, nsim=1000, test = fixed("emotion"))
print(posthoc_power_emotion)
posthoc_power_gender <- powerSim(Model2.normal, nsim=1000, test = fixed("gender"))
print(posthoc_power_gender)
posthoc_power_side <- powerSim(Model2.normal, nsim=1000, test = fixed("side"))
print(posthoc_power_side)
posthoc_power_age <- powerSim(Model2.normal, nsim=1000, test = fixed("age"))
print(posthoc_power_age)

# Model without secondary variables
ModelN170.lessfactors <- lmer(N170 ~ mask + emotion + (1|subName),
                              data = data)
summary(ModelN170.lessfactors)
anova(ModelN170.lessfactors, type=2, ddf="Kenward-Roger")

install.packages("simr")
library(simr)
posthoc_power_mask <- powerSim(ModelN170.lessfactors, nsim=1000, test = fixed("mask"))
print(posthoc_power_mask)
posthoc_power_emotion <- powerSim(ModelN170.lessfactors, nsim=1000, test = fixed("emotion"))
print(posthoc_power_emotion)

# 1. Effect Size for 'mask'
Model1_no_mask <- update(ModelN170.lessfactors, . ~ . - mask)
f2_mask <- calculate_f2(ModelN170.lessfactors, Model1_no_mask)
cat("Cohen's f? for 'mask':", f2_mask, "\n")
# 2. Effect Size for 'emotion'
Model1_no_emotion <- update(ModelN170.lessfactors, . ~ . - emotion)
f2_emotion <- calculate_f2(ModelN170.lessfactors, Model1_no_emotion)
cat("Cohen's f? for 'emotion':", f2_emotion, "\n")