
getwd()
setwd("E:/R Jaman Sir")

# Importing wage csv file
data_import = read.csv (file.choose())
attach(data_import)
dim(data_import)
names(data_import)
library(tidyverse)
library(dplyr)

str(data_import)

# Factorizing string values
data_import$occrecode = factor(data_import$occrecode)
data_import$wrkstat = factor(data_import$wrkstat)
data_import$gender = factor(data_import$gender)
data_import$educcat = factor(data_import$educcat)
data_import$maritalcat = factor(data_import$maritalcat)

# Dropping unnecessary columns
updated_data = data_import %>%
  select (-c(year,occ10))

names(updated_data)

# Finding irrelevant data
irrelevant_data = updated_data[!complete.cases(updated_data),]

dim(irrelevant_data)

# Omitting NA and dropping people over 80 years 
cleaned_data = updated_data %>%
  na.omit(updated_data) %>%
  filter(age<80)

dim(cleaned_data)

unique(cleaned_data$gender)

# Creating dummy data

cleaned_data$gender = factor(cleaned_data$gender, c("Male","Female"), labels = c(1,0))

# Alternative way
cleaned_data$gender = ifelse(cleaned_data$gender == "Male", 2,3)

unique(cleaned_data$educcat) 

# Creating category
cleaned_data$educcat = factor(cleaned_data$educcat, c("High School","Bachelor","Less Than High School","Graduate","Junior College"), labels = c(1,2,3,4,5))

# Alternative way
cleaned_data$educcat = ifelse ( cleaned_data$educcat ==
                                 "High School",1 ,
                                 ifelse ( cleaned_data$educcat == "Bachelor" ,2 ,
                                          ifelse ( cleaned_data$educcat == "Less Than High School",3 ,
                                                   ifelse ( cleaned_data$educcat == "Graduate" ,4 , 5))))

unique(cleaned_data$wrkstat)

# Replacing same type of data into one single data
cleaned_data$wrkstat = cleaned_data$wrkstat %>%
  fct_collapse("Unemployed" = c ("Retired","Temporarily Not Working","Unemployed, Laid Off"))
