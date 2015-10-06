#####
# DATA DOWNLOAD DIRECTIONS (BEN, DISREGARD)
#####
# NOT USING -----------------
# SHAREPOINT DATA:
# http://def.sharepoint.doh.ad.state.fl.us/Family/WIC/EBT/default.aspx?RootFolder=%2fFamily%2fWIC%2fEBT%2fShared%20Documents%2fIndicators%20%2d%20Detail%20Information&View=%7b18FCF710%2dD9AA%2d4187%2dA315%2d791587DAE18E%7d
# --- breastfeeding
# ------
# ---prenatal entry into WIC in first semester
# ------ enrolees by month or quarter
# USING ---------------------
# http://dohiws/
# --- Divisions and Bureaus / Divisions of Community Health Promotion
# --- Bureau of Women, Infants and Children Program Services
# --- Internal
# --- Indicators
# ------ Participation : Copy of FFY2015PARTICIPATION
# ------ Breastfeeding - Percent of WIC Infants Ever Breastfed : Percent_Of_WIC_Infants_And_Children_Ever_Breastfed
# ------ Breastfeeding - Percent of Breastfed Infants in WIC : Percent_Of_Breastfed_Infants_In_WIC
# ------ Breastfeeding - Infants Breastfed for 26 weeks : Infants_Breastfed_For_26_Weeks
# ------ Breastfeeding - Infants Fully Breastfed for 26 weeks : Infants_Fully_Breastfed_For_26_Weeks
# ------ 1st trimester entry into WIC-All Prenatal Enrollees : First_Trimester_Entry_Into_WIC-All_Enrollees
# ------ Nutrition Education Contacts-High Risk : Nutrition_Education_Contacts_For_High_Risk_Clients
# ------ Nutrition Education Contacts-Low Risk : Nutrition_Education_Contacts_For_Low_Risk_Clients
# ------ Overweight and Obese Children : Overweight_And_Obese_Children
# ------ Healthy Weight : Healthy_Weight
#####

#####
# LIBRARIES
#####
library(readr)
library(dplyr)
library(readxl)
library(tidyr)
library(xlsx)

#####
# DATA READ IN
#####

#### Read in all 4 sheets from Ever BF Clients LessThan 24 mos old June 2015
ever_bf1 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 1, col_names = FALSE)
ever_bf2 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 2, col_names = FALSE)
ever_bf3 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 3, col_names = FALSE)
ever_bf4 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 4, col_names = FALSE)


# Remove first two rows and make 3rd row the new column names 
# first create function to remove first 3 rows and make 4th row the new header 
clean_firstrows <- function(x){

  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)]
  # subset x again by removing rows that are entirely filled with NAs
  x <- x[complete.cases(x),]
  # Use the next available row for new column names 
  colnames(x) <- x[1,]
  # Drop the original row that just had the column names 
  x <- x[-1, ]
  # Make the column names lowercase 
  colnames(x) <- tolower((colnames(x)))
  # replace spaces with underscores
  colnames(x) <- gsub("\\s+", "_", colnames(x))
  # return x
  return(x)
    
 }

# Apply function to ever_bf data 
ever_bf1 <- clean_firstrows(ever_bf1)
ever_bf2 <- clean_firstrows(ever_bf2)
ever_bf3 <- clean_firstrows(ever_bf3)

# Drop ever_bf4 because it has no important information 
rm(ever_bf4)

##### Read in all 5 sheets from FFY2015PARTICIPATION 
# First resave the FFY2015PARTICIPATION.xls as an xlsx file. 
# Then remove the previous xls file 
ffy_20151 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 1, col_names = FALSE)
ffy_20152 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 2, col_names = FALSE)
ffy_20153 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 3, col_names = FALSE)
ffy_20154 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 4, col_names = FALSE)
ffy_20155 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 5, col_names = FALSE)



##### Read in all 3 sheets from First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx
first_tri_enroll1 <- read_excel('data/First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx', 1)
first_tri_enroll2 <- read_excel('data/First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx', 1)
first_tri_enroll3 <- read_excel('data/First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx', 1)

##### Read in all 2 sheets from First_Trimester_Entry_Into_WIC_By_Time_Period.xlsx
first_tri_time1 <- read_excel('data/First_Trimester_Entry_Into_WIC_By_Time_Period.xlsx', 1)
first_tri_time2 <- read_excel('data/First_Trimester_Entry_Into_WIC_By_Time_Period.xlsx', 1)

##### Read in all 3 sheets from Healthy_Weight.xlsx 
healthy_weight1 <- read_excel('data/Healthy_Weight.xlsx', 1)
healthy_weight2 <- read_excel('data/Healthy_Weight.xlsx', 2)

##### Read in all 4 sheets from Infants Breastfed for 26 weeks june 2015.xlsx 
infants_fed1_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 1)
infants_fed2_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 2)
infants_fed3_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 3)
infants_fed4_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 4)

##### Read in all 3 sheets from Infants Breastfed for 26 weeks.xlsx 
infants_fed1 <- read_excel('data/Infants_Breastfed_For_26_Weeks.xlsx', 1) 
infants_fed2 <- read_excel('data/Infants_Breastfed_For_26_Weeks.xlsx', 2) 
infants_fed3 <- read_excel('data/Infants_Breastfed_For_26_Weeks.xlsx', 3) 

##### Read in all 4 sheets from Infants Fully BF for 26 weeks June 2015.xlsx
infants_full1_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 1)
infants_full2_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 2)
infants_full3_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 3)
infants_full4_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 4)

##### Read in all 3 sheets for Infants_Fully_Breastfed_For_26_Weeks.xlsx
infants_full1 <- read_excel('data/Infants_Fully_Breastfed_For_26_Weeks.xlsx', 1)
infants_full2 <- read_excel('data/Infants_Fully_Breastfed_For_26_Weeks.xlsx', 2)
infants_full3 <- read_excel('data/Infants_Fully_Breastfed_For_26_Weeks.xlsx', 3)

##### Read in mydata.csv
my_data <- read.csv('data/mydata.csv')

##### Read in all 4 sheets of Non-Hisp Black Ever BF Clients - June 2015.xlsx
# rename file to Non_Hisp Black Ever BF Clients_June 2015.xlsx
non_hisp1 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 1)
non_hisp2 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 2)
non_hisp3 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 3)
non_hisp4 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 4)

##### Read in all 3 sheets of Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx 
high_risk1 <- read_excel('data/Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx', 1)
high_risk2 <- read_excel('data/Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx', 2)
high_risk3 <- read_excel('data/Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx', 3)

##### Read in all 3 sheets of Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx
low_risk1 <- read_excel('data/Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx', 1)
low_risk2 <- read_excel('data/Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx', 2)
low_risk3 <- read_excel('data/Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx', 3)

##### Read in all 3 sheets of Overweight_And_Obese_Children.xlsx 
over_obese1 <- read_excel('data/Overweight_And_Obese_Children.xlsx', 1)
over_obese2 <- read_excel('data/Overweight_And_Obese_Children.xlsx', 2)
over_obese3 <- read_excel('data/Overweight_And_Obese_Children.xlsx', 3)

##### Read in all 4 sheets of Percent BF Infants in WIC June 2015.xlsx
percent_bf1_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 1)
percent_bf2_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 2)
percent_bf3_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 3)
percent_bf4_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 4)

##### Read in all 3 sheets of Percent_Of_Breastfed_Infants_In_WIC.xlsx
percent_bf1 <- read_excel('data/Percent_Of_Breastfed_Infants_In_WIC.xlsx', 1)
percent_bf2 <- read_excel('data/Percent_Of_Breastfed_Infants_In_WIC.xlsx', 2)
percent_bf3 <- read_excel('data/Percent_Of_Breastfed_Infants_In_WIC.xlsx', 3)

##### Read in all 3 sheets of Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx
percent_ever1 <- read_excel('data/Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx', 1)
percent_ever2 <- read_excel('data/Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx', 2)
percent_ever3 <- read_excel('data/Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx', 3)

##### Read in all 4 sheets of Prenatal Entry in First Trim in June 2015.xlsx 
pre_entry1 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 1)
pre_entry2 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 2)
pre_entry3 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 3)
pre_entry4 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 4)

















































