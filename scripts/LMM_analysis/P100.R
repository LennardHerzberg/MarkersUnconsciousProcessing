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
data <- read_xlsx("~/Desktop/Doktorarbeit/EmoCon/Auswertung/Tabellen/Primer/Primer_P100_leftright.xlsx")
View(data)

subName <- data$subName
age <- data$age
gender <- data$gender
mask <- data$mask
emotion <- data$emotion
condition <- data$condition
side <- data$side

# # Grafiken plotten ####
# 
# data$P100 <- as.numeric(data$P100)
# 
# #Plot Density
# plot(density(data$P100),main="Density estimate of data")
# 
# x <- data$P100+100
# den <- density(x)
# dat <- data.frame(x = den$x, y = den$y)
# 
# # Fit distributions
# library(fitdistrplus)
# fit.weibull <- fitdist(x, "weibull")
# fit.normal <- fitdist(x,"norm")
# fit.gamma <- fitdist(x, "gamma", lower = c(0, 0))
# # fit.poisson <- fitdist(x, "pois")
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
data$side          <- factor(data$side, ordered = FALSE)

summary(data)

options('contrasts')

options(contrasts = c("contr.sum", "contr.poly"))

# lmer no interaction effect 
Model1.normal <- lmer(P100 ~ mask + emotion + gender + side + age + (1|subName),
                      data = data)

summary(Model1.normal)
anova(Model1.normal)

isSingular(Model1.normal, tol=1e-4)

# lmer interaction effect mask*emotion
Model4.normal <- lmer(P100 ~ mask*emotion + gender + side + age + (1|subName),
                      data = data)

summary(Model4.normal)
anova(Model4.normal)

isSingular(Model4.normal, tol = 1e-4)

anova(Model1.normal, Model4.normal)

# Model 1 (without interaction), since AIC/BIC better than Model 4 (with interaction)
library(effects)
effectsmodel1<-allEffects(Model1.normal)
plot(effectsmodel1)
print(effectsmodel1)

Model1PairwiseE <- emmeans(Model1.normal, pairwise ~ emotion)
Model1PairwiseG <- emmeans(Model1.normal, pairwise ~ gender)
Model1PairwiseS <- emmeans(Model1.normal, pairwise ~ side)
Model1PairwiseM <- emmeans(Model1.normal, pairwise ~ mask) 

summary(Model1PairwiseE$contrasts, infer = c(TRUE, TRUE))

Model1PairwiseE
Model1PairwiseG
Model1PairwiseS
Model1PairwiseM 

effect_gender <- Effect("gender", Model1.normal)
effect_mask <- Effect("mask", Model1.normal)
effect_side <- Effect("side", Model1.normal)
plot(effect_gender)
plot(effect_mask)
plot(effect_side)

# Type II ANOVA
anova(Model1.normal, type=2, ddf="Kenward-Roger")
anova(Model4.normal, type=2, ddf="Kenward-Roger")


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
data$predicted_values <- predict(Model1.normal, type = "response")

# Plot the predicted values using ggplot
# mask 
plot1 <- ggplot(data, 
                aes(x = mask, 
                    y = P100, 
                    fill = mask)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = P100),                      # Jitter points of predicted values 
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
  labs(title = "", y = "P100", x = "Mask") 

plot1

# sex
plot2 <- ggplot(data, 
                aes(x = gender, 
                    y = P100, 
                    fill = gender)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = P100),                      # Jitter points of predicted values 
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
  labs(title = "", y = "P100", x = "Sex") 

plot2

# hemisphere  
plot3 <- ggplot(data, 
                aes(x = side, 
                    y = P100, 
                    fill = side)) +
  geom_boxplot(width = 0.5, 
               outlier.shape = NA) +                          # Boxplot of predicted values
  geom_jitter(aes(y = P100),                      # Jitter points of predicted values 
              position = position_jitter(width = 0.1), 
              size = 1.5, 
              alpha = 0.3) +                                  # adjust alpha transparency
  scale_fill_manual(values = c("Left" = "azure2",
                               "Right" = "darkgrey")) +
  #theme_prism() +
  theme_minimal() +
  theme(legend.position = "none",                             
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16),       # Update y-axis label size
        axis.title.y = element_text(size = 16),       # Update y-axis title size
        axis.title.x = element_text(size = 16, margin = margin(t = 12))) +
  labs(title = "", y = "P100", x = "Hemisphere") 

plot3

# combine plots 
#install.packages("patchwork")
library(patchwork)

# Combine the three plots and add labels
combined_plot <- (plot1 + plot2 + plot3) + 
  plot_annotation(tag_levels = 'A') &       #  # Automatically labels A, B, C
  theme(plot.tag = element_text(size = 16))  # Set tag font size to 16

combined_plot

# Confidence intervals Model 
confint(Model1.normal, method="profile")

# effect sizes ####
library(MuMIn)
r2 <- r.squaredGLMM(Model1.normal)
print(r2)
library(effectsize)
effect_size <- eta_squared(Model1.normal)
print(effect_size)

# Load necessary libraries for calculating R?
library(performance)

# Calculate R? for the full model
r2_full_Model1 <- r2(Model1.normal)$R2_marginal
cat("R? Full Model (Model1.normal):", r2_full_Model1, "\n")

# Function to calculate Cohen's f?
calculate_f2 <- function(full_model, reduced_model) {
  r2_full <- r2(full_model)$R2_marginal
  r2_reduced <- r2(reduced_model)$R2_marginal
  f2 <- (r2_full - r2_reduced) / (1 - r2_full)
  return(f2)
}

# Calculate Cohen's f? for each fixed effect in Model1.normal

# 1. Effect Size for 'mask'
Model1_no_mask <- update(Model1.normal, . ~ . - mask)
f2_mask <- calculate_f2(Model1.normal, Model1_no_mask)
cat("Cohen's f? for 'mask':", f2_mask, "\n")

# 2. Effect Size for 'emotion'
Model1_no_emotion <- update(Model1.normal, . ~ . - emotion)
f2_emotion <- calculate_f2(Model1.normal, Model1_no_emotion)
cat("Cohen's f? for 'emotion':", f2_emotion, "\n")

# 3. Effect Size for 'gender'
Model1_no_gender <- update(Model1.normal, . ~ . - gender)
f2_gender <- calculate_f2(Model1.normal, Model1_no_gender)
cat("Cohen's f? for 'gender':", f2_gender, "\n")

# 4. Effect Size for 'side'
Model1_no_side <- update(Model1.normal, . ~ . - side)
f2_side <- calculate_f2(Model1.normal, Model1_no_side)
cat("Cohen's f? for 'side':", f2_side, "\n")

# 5. Effect Size for 'age'
Model1_no_age <- update(Model1.normal, . ~ . - age)
f2_age <- calculate_f2(Model1.normal, Model1_no_age)
cat("Cohen's f? for 'age':", f2_age, "\n")

#### Power analysis #####
install.packages("simr")
library(simr)
posthoc_power_mask <- powerSim(Model1.normal, nsim=1000, test = fixed("mask"))
print(posthoc_power_mask)
posthoc_power_emotion <- powerSim(Model1.normal, nsim=1000, test = fixed("emotion"))
print(posthoc_power_emotion)
posthoc_power_gender <- powerSim(Model1.normal, nsim=1000, test = fixed("gender"))
print(posthoc_power_gender)
posthoc_power_side <- powerSim(Model1.normal, nsim=1000, test = fixed("side"))
print(posthoc_power_side)
posthoc_power_age <- powerSim(Model1.normal, nsim=1000, test = fixed("age"))
print(posthoc_power_age)


# Model without secondary variables
ModelP100.lessfactors <- lmer(P100 ~ mask + emotion + (1|subName),
                              data = data)
summary(ModelP100.lessfactors)
anova(ModelP100.lessfactors, type=2, ddf="Kenward-Roger")

install.packages("simr")
library(simr)
posthoc_power_mask <- powerSim(ModelP100.lessfactors, nsim=1000, test = fixed("mask"))
print(posthoc_power_mask)
posthoc_power_emotion <- powerSim(ModelP100.lessfactors, nsim=1000, test = fixed("emotion"))
print(posthoc_power_emotion)

# 1. Effect Size for 'mask'
Model1_no_mask <- update(ModelP100.lessfactors, . ~ . - mask)
f2_mask <- calculate_f2(ModelP100.lessfactors, Model1_no_mask)
cat("Cohen's f? for 'mask':", f2_mask, "\n")

# 2. Effect Size for 'emotion'
Model1_no_emotion <- update(ModelP100.lessfactors, . ~ . - emotion)
f2_emotion <- calculate_f2(ModelP100.lessfactors, Model1_no_emotion)
cat("Cohen's f? for 'emotion':", f2_emotion, "\n")