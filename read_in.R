#####
# DATA DOWNLOAD DIRECTIONS
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
# ------ 1st Trimester Entry Into WIC by Quarter or Month : First_Trimester_Entry_Into_WIC_By_Time_Period
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


#####
# DATA READ IN
#####

### PARTICIPATION
participation <- read_excel('data/FFY2015PARTICIPATION.xls', header = FALSE)
# Extract names
temp <- apply(participation, 2, function(x){paste0(x[1], x[2], format(as.Date(x[3]), '%Y-%m-%d'), x[4])})

# DEFINE WHICH FILES TO WORK WITH
files <- c(participation = 'FFY2015PARTICIPATION',
           ever_breast = 'Percent_Of_WIC_Infants_And_Children_Ever_Breastfed',
           breast_wic = 'Percent_Of_Breastfed_Infants_In_WIC',
           breast_26 = 'Infants_Breastfed_For_26_Weeks',
           breast_26_full = 'Infants_Fully_Breastfed_For_26_Weeks',
           first_tri = 'First_Trimester_Entry_Into_WIC-All_Enrollees',
           first_tri_ts = 'First_Trimester_Entry_Into_WIC_By_Time_Period',
           nutrition_contacts_high_risk = 'Nutrition_Education_Contacts_For_High_Risk_Clients',
           nutrition_contacts_low_risk = 'Nutrition_Education_Contacts_For_Low_Risk_Clients')

# Define how many skips per file
skips <- c(2, 1, 1, 3, 3, 1, 3, 2, 1)


# Read in each file
for (i in 1:length(files)){
  if(paste0('', files[i], '.xlsx') %in% dir('data')){
    val <- paste0('data/', files[i], '.xlsx')
  } else {
    val <- paste0('data/', files[i], '.xls')
  }
  assign(x = names(files)[i],
         value = read_excel(val, skip = skips[i]))
  print(i)
}