library(readxl)
data <- read_excel("~/Desktop/Doktorarbeit/Downloads_Data/Verhaltensdaten/BackwardMask_Accuracy.xlsx", 
                                    sheet = "Tabelle")
View(data)

subName <- data$subName
gender <- data$gender
age <- data$age
primer_emotion <- data$primer_emotion
target_emotion <- data$target_emotion
consciousness <- data$consciousness
accuracy <- data$accuracy

# Repeated measures ANOVA
model <- aov(accuracy ~ primer_emotion * consciousness, data = data)

# Summary of ANOVA
summary(model)

# Post-hoc tests (e.g., Tukey's HSD)
library(TukeyHSD)
posthoc <- TukeyHSD(model)
print(posthoc)