#Load Packages/Data

library(tidyverse)
library(openxlsx)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
setwd("C:/Users/Jack Simpson/Downloads")
Re_admission_Data <- read.xlsx("Re-admission Data.xlsx", sheet = "Sheet2") 
Hospital_Characteristics <- read.xlsx("Hospital Characteristics.xlsx", sheet = "Hospital_General_Information")

# Names Readmission_Data

names(Re_admission_Data) <- str_replace_all(names(Re_admission_Data), c(" " = "." , "," = "" ))

#Names Hospital Characteristics

names(Hospital_Characteristics) <- str_replace_all(names(Hospital_Characteristics), c(" " = "." , "," = "" ))

# Rename Readmissions Data Provider Number to Provider.ID

Re_admission_Data <- rename(Re_admission_Data, Provider.ID = Provider.Number)

# Merge Data

Readmissions_Table <- merge(Hospital_Characteristics, Re_admission_Data, by = "Provider.ID")

# MU filter

MU <- Readmissions_Data$Meets.criteria.for.meaningful.use.of.EHRs

# Highlight Hospital Data Point

highlight_hospital <- Readmissions_Table %>%
  filter(Provider.ID == 140239)


#AMI # of Discharges/ERR Linear Regression

AMI_lm <- lm(AMI.Number.of.Discharges ~ AMI.Excess.Readmission.Ratio, data = Readmissions_Table)

summary(AMI_lm)


# COPD # of Discharges Linear Regression

COPD_lm <- lm(COPD.Number.of.Discharges ~ COPD.Excess.Readmission.Ratio, data = Readmissions_Table)

summary(COPD_lm)


# Hip/Knee # of Discharges/ERR Linear Regression

HipKnee_lm <- lm(HIP.KNEE.Number.of.Discharges~HIP.KNEE.Excess.Readmission.Ratio, data = Readmissions_Table)

summary(HipKnee_lm)

# USA Map Packages

library(usmap)

#remove NAs to create new data table

Readmissions_Table2 <- na.omit(Readmissions_Table)

# create new column titled state in order to work properly with plot_usmap() function

Readmissions_Table2$state <- Readmissions_Table2$State.x

# Average AMI ERRs for each state calculation

STATE_AMI_ERRs <- Readmissions_Table2 %>%
  group_by(state) %>%
  summarize(mean(AMI.Excess.Readmission.Ratio, na.rm = "TRUE"))

# USA Map Plot

plot_usmap(data = Readmissions_Table2, values = "AMI.Excess.Readmission.Ratio", na.rm = "TRUE") +
  scale_colour_gradient2(low = "white", mid = "turquoise", high = "blue") +
  theme(legend.position = "right")

# Original Data Hip/Knee Readmissions

Readmissions_Table %>%
  
  ggplot(aes(HIP.KNEE.Number.of.Discharges, HIP.KNEE.Excess.Readmission.Ratio)) +
  geom_point(aes(color = HIP.KNEE.Excess.Readmission.Ratio <= 1.0)) +
  geom_point(data = highlight_hospital,
             aes(HIP.KNEE.Number.of.Discharges, HIP.KNEE.Excess.Readmission.Ratio), 
             color = 'green', size = 3.5, shape = 'diamond') +
  geom_smooth(color = 'black', method = lm, se = FALSE) +
  geom_text(data = highlight_hospital, aes(label = "P-value: < 2.2e-16"), nudge_x = 4000, nudge_y = .01 , size = 3.4) +
  geom_text(data = highlight_hospital, aes(label = "R-squared = 0.1251"), nudge_x = 4000, nudge_y = -.045 , size = 3.4) +
  labs(y = "Hip/Knee ERRs", x = "Hip/Knee # of Discharges") +
  theme(legend.position = "none")


# Log transformed data Hip/Knee Readmissions

Readmissions_Table %>%
  
  ggplot( aes(x = log(HIP.KNEE.Number.of.Discharges), HIP.KNEE.Excess.Readmission.Ratio)) +
  geom_point(aes(color = HIP.KNEE.Excess.Readmission.Ratio <= 1.0)) +
  geom_point(data = highlight_hospital,
           aes(x = log(HIP.KNEE.Number.of.Discharges), HIP.KNEE.Excess.Readmission.Ratio), 
           color = 'green', size = 3.5, shape = 'diamond') +
  geom_smooth(color = 'black', method = lm, se = FALSE) +
  labs(y = "Hip/Knee ERRs", x = "Hip/Knee # of Discharges Log Transformed") +
  theme(legend.position = "none")

# HF by # of Discharges Scatterplot

Readmissions_Table %>%
  
  ggplot(aes(HF.Number.of.Discharges, HF.Excess.Readmission.Ratio)) +
  geom_point(aes(color = HF.Excess.Readmission.Ratio <= 1.0)) +
  geom_point(data = highlight_hospital,
             aes(HF.Number.of.Discharges, HF.Excess.Readmission.Ratio), 
             color = 'Navy', size = 3.5, shape = 'diamond') +
  geom_smooth(color = 'black', method = lm, se = FALSE) +
  labs(y = "HF ERRs", x = "HF # of Discharges") +
  theme(legend.position = "none")

#AMI ERR by # of Discharges Scatterplot

Readmissions_Table %>%
  
  ggplot(aes(AMI.Number.of.Discharges, AMI.Excess.Readmission.Ratio)) +
  geom_point(alpha = 0.7, aes(color = AMI.Excess.Readmission.Ratio < 1.0)) +
  geom_point(data = highlight_hospital,
             aes(AMI.Number.of.Discharges, AMI.Excess.Readmission.Ratio), 
             color = 'green', size = 3.5, shape = 'diamond') +
  geom_text(data = highlight_hospital, aes(label = "P-value: 1.899e-10"), nudge_x = 800, nudge_y = -0.015 , size = 3.4) +
  geom_text(data = highlight_hospital, aes(label = "R-squared = 0.023"), nudge_x = 800, nudge_y = -.03 , size = 3.4) +
  geom_smooth(color = 'black',method = lm, se = FALSE) +
  theme(legend.position = "none") +
  labs(y = "AMI ERR", x = "AMI # of Discharges")

# COPD Scatter Plot

Readmissions_Table %>%
  
  ggplot(aes(COPD.Number.of.Discharges, COPD.Excess.Readmission.Ratio)) +
  geom_point(aes(color = COPD.Excess.Readmission.Ratio <= 1.0)) +
  geom_point(data = highlight_hospital,
             aes(COPD.Number.of.Discharges, COPD.Excess.Readmission.Ratio), 
             color = 'navy', size = 3.5, shape = 'diamond') +
  geom_smooth(color = 'black', method = lm, se = FALSE) +
  geom_text(data = highlight_hospital, aes(label = "P value = 1.328e-07"), nudge_x = 1500, nudge_y = .21 , size = 3.4) +
  geom_text(data = highlight_hospital, aes(label = "R-squared = .01014"), nudge_x = 1500, nudge_y = .18 , size = 3.4) +
  labs(y = "COPD ERRs", x = "COPD # of Discharges") +
  theme(legend.position = "none")







