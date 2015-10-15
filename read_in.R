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

###### BEFORE STARTING
# MANUAL INSTRUCTIONS for FFY2015PARTICIPATION.xlsx
# First resave the FFY2015PARTICIPATION.xls as an xlsx file. 
# Manually remove column CJ, rows 61-85 because they are not associated with the data 

#####
# LIBRARIES
#####
library(ggthemes)
library(readr)
library(plyr)
library(dplyr)
library(readxl)
library(tidyr)
library(xlsx)
library(splitstackshape)
library(ggplot2)

#####
# DATA READ IN
#####

#### Read in all 4 sheets from Ever BF Clients LessThan 24 mos old June 2015
ever_bf1 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 1, col_names = FALSE)
ever_bf2 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 2, col_names = FALSE)
ever_bf3 <- read_excel('data/Ever BF Clients LessThan 24 mos old June 2015.xlsx', 3, col_names = FALSE)

# create function to clean ever_bf1
clean_everbf1 <- function(x){

  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)]
  # subset x again by removing rows that are entirely filled with NAs
  x <- x[complete.cases(x),]
  # drop last column
  x <- x[,1:(ncol(x) - 1)]
  # rename x
  names(x) <- c("agency_number","agency", "ever_bf", "all_infants_children")
  # Drop the original row that just had the column names 
  x <- x[2:nrow(x), ]
  # drop state totals 
  x <- x[x$agency != 'State',]
  #Make as numeric 
  x$ever_bf <-as.numeric(x$ever_bf)
  x$all_infants_children <-as.numeric(x$all_infants_children)
  
  
  # return x
  return(x)
    
 }

# Apply function to ever_bf1 data 
ever_bf1 <- clean_everbf1(ever_bf1)

# create function to clean ever_bf2
clean_everbf2 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)]
  # subset x again by removing rows that are entirely filled with NAs
  x <- x[complete.cases(x),]
  # drop last column
  x <- x[,1:(ncol(x) - 1)]
  # rename x
  names(x) <- c("agency","site", "ever_bf", "all_infants_children")
  # Drop the original row that just had the column names 
  x <- x[2:nrow(x), ]
  #Make as numeric 
  x$ever_bf <-as.numeric(x$ever_bf)
  x$all_infants_children <-as.numeric(x$all_infants_children)
  
  # return x
  return(x)
  
}

# apply function to ever_bf2
ever_bf2 <- clean_everbf2(ever_bf2)

# Create function to clean ever_bf3
clean_everbf3 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)]
  # subset x again by removing rows that are entirely filled with NAs
  x <- x[complete.cases(x),]
  # drop last column
  x <- x[,1:(ncol(x) - 1)]
  # rename x
  names(x) <- c("agency_number","agency", "ever_bf", "all_infants_children")
  # Drop the original row that just had the column names 
  x <- x[2:nrow(x), ]
  # drop state totals 
  x <- x[x$agency != 'State',]
  #Make as numeric 
  x$ever_bf <-as.numeric(x$ever_bf)
  x$all_infants_children <-as.numeric(x$all_infants_children)
  
}
ever_bf3<- clean_everbf1(ever_bf3)

##### Read in from FFY2015PARTICIPATION 

ffy_2015_1 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 1, col_names = FALSE)
ffy_2015_2 <- read_excel('data/FFY2015PARTICIPATION.xlsx', 2, col_names = FALSE)


# Create function to clean ffy_2015_1 data 
clean_ffy_2015_1 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)]  
  # Drop rows where NA is in first column
  x <- x[!is.na(x$X0),]
  # Get rid of last 4 columns
  x <- x[,1:(ncol(x)-4)]
  # Names columns X0,X2,X3 
  names(x)[1:3] <- c("agency", "la", "eligible")
  names(x)[4:ncol(x)] <- paste0("date", as.Date(as.numeric(x[2,4:ncol(x)]), origin = '1899-12-30'))
  # get rid of first 3 rows 
  x <- x[4:nrow(x),]
  # get rid of total and below 
  x <- x[1:(which(x$agency == 'STATE TOTAL') - 1),]   
  # Gather the time columns together
  x <- gather(x, date, participation, starts_with('date'))
  # clean up the date column so it's an actual date
  x$date <- as.Date(gsub("date", "", x$date), format = "%Y-%m-%d")
  # Make participation and eligible numeric
  x$participation <- as.numeric(x$participation)
  x$eligible <- as.numeric(x$eligible)
  
  return(x)
}
  
ffy_2015_1 <- clean_ffy_2015_1(ffy_2015_1)

# Create a function to clean ffy_2015_2 data 
clean_ffy_2015_2 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)] 
  # get ride of rows where there are NAs in first column 
  x <- x[!is.na(x$X0),]
  # Get rid of last 4 columns
  x <- x[,1:(ncol(x)-4)]
  # Names columns X0,X2,X3 
  names(x)[1:3] <- c("agency", "la", "eligible")
  names(x)[4:ncol(x)] <- paste0("date", as.Date(as.numeric(x[3,4:ncol(x)]), origin = '1899-12-30'))
  # get rid of first 4 rows 
  x <- x[5:nrow(x),]
  # get rid of total and below 
  x <- x[1:(which(x$agency == 'TOTAL') - 1),] 
  # Gather the time columns together
  x <- gather(x, date, participation, starts_with('date'))
  # clean up the date column so it's an actual date
  x$date <- as.Date(gsub("date", "", x$date), format = "%Y-%m-%d")
  # Make participation and eligible numeric
  x$participation <- as.numeric(x$participation)
  x$eligible <- as.numeric(x$eligible)
  return(x)
}
ffy_2015_2 <- clean_ffy_2015_2(ffy_2015_2)

##### Read in all 3 sheets from First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx
first_tri_enroll1 <- read_excel('data/First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx', 1, col_names = FALSE)
first_tri_enroll2 <- read_excel('data/First_Trimester_Entry_Into_WIC-All_Enrollees.xlsx', 2, col_names = FALSE)

# Make function to clean first_tri_enroll1
clean_enroll1 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)] 
  # get rid of rows where there are NAs in first column 
  x <- x[!is.na(x$X0),]
  # Names columns X0,X2,X3 
  names(x)[1:2] <- c("agency_num", "agency")
  names(x)[3:ncol(x)] <- paste0("date", as.Date(as.numeric(x[2,3:ncol(x)]), origin = '1899-12-30'))
  # Drop rows until name is alachua
  x <- x[(which(x$agency == 'Alachua')):nrow(x),]
  # drop first column 
  x <- x[,2:ncol(x)]
  # gather x 
  x <- gather(x, date, participation, starts_with('date'))
  # clean up date column
  x$date <- as.Date(gsub("date","",x$date), format = '%Y-%m-%d')
  # remove row with state totals
  x <- x[x$agency != 'State',]
  
  return(x)
  
}

first_tri_enroll1 <- clean_enroll1(first_tri_enroll1)

# make a function to clean first_tri_enroll1
clean_enroll2 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)] 
  # drop first column 
  x <- x[,2:ncol(x)]
  # Names columns X0,X2,X3 
  names(x)[1] <- "county"
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[2,2:ncol(x)]), origin = '1899-12-30'))
  # clean county names-- replace spaces with nothing
  x$county <- gsub("\\s+", "", x$county)
  # Drop rows until name is alachua
  x <- x[(which(x$county == 'Alachua')):nrow(x),]
  # gather x
  x <- gather(x, date, participation, starts_with('date'))
  # clean date column 
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # remove row with state totals
  x <- x[x$county != 'State',]
  
  return(x)
}

first_tri_enroll2 <- clean_enroll2(first_tri_enroll2)

##### Read in sheet from First_Trimester_Entry_Into_WIC_By_Time_Period.xlsx
first_tri_time1 <- read_excel('data/First_Trimester_Entry_Into_WIC_By_Time_Period.xlsx', 1, col_names = FALSE)

# Make function to clean first_tri_time1
clean_tri_1 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]  
  # drop first row 
  x$X0 <- NULL
  # Get first column name
  names(x)[1] <- 'county'
  # Standardize column names for the rest of the data
  for (j in 2:ncol(x)){
    column_indicator <- j
    # manipulate the date objects
    if(j == ncol(x)){
      column_indicator <- column_indicator - 1
    }else{
      if(is.na(x[2,column_indicator])){
        column_indicator <- column_indicator +1
        if(is.na(x[2, column_indicator])){
          column_indicator <- column_indicator - 2
        }
      } 
    }
   
    # Fix column indicator for last column
    column_indicator <- ifelse(column_indicator > ncol(x),
                               ncol(x)-1, column_indicator)
    
    # Get the date object
    date_object <- unlist(strsplit(as.character(x[2,column_indicator]), ' - '))
    # Deal with differential number vs. hyphenated date stuff
    if(length(date_object) == 2){
      date_object <- date_object[length(date_object)]
      # Extract the quarter
      quarter <- ifelse(grepl('Mar', date_object), 1,
                        ifelse(grepl('Jun', date_object), 2,
                               ifelse(grepl('Sep', date_object), 3,
                                      ifelse(grepl('Dec', date_object), 4, NA))))
      # Extract the year
      year <- as.numeric(unlist(strsplit(date_object, '-'))[2])  
    } else {
      # Convert from excel to r date
      date_object <- as.Date(as.numeric(date_object), origin = '1899-12-30')
      # Extract the quarter
      month <- as.numeric(format(date_object, '%m'))
      quarter <- ((month-1) %/% 3) + 1
      # Extract the year
      year <- as.numeric(format(date_object, '%Y'))
    }
    
    # Paste together the quarter, year and third row info
    column_name <- paste0(year,"_", quarter,"_", x[3,j])
    # Stick that column name where it belongs
    names(x)[j] <- column_name
  }
# remove first 3 rows 
x <- x[4:nrow(x),]
# gather
x <- gather(x, key, value, 2:ncol(x))
# strsplit the key on underscore creating year, quarter and description columns 
list <- strsplit(as.character(x$key), '_')
# turn list into data table object
temp <- ldply(list)
# make column names
colnames(temp) <- c("year", "quarter", "class")
# put back into x
x <- cbind(x, temp)
# remove extra columns in x 
x <- x[, c("county", "year", "quarter", "class", "value")]
# remove state 
x <- x[x$county != 'State',]
# remove if "As of"
x <- x[!grepl("As of", x$county),]
# clean county column 
x$county <- gsub("\\s+", "", x$county)
# make as numeric
x$value <- as.numeric(x$value)
# Keep only percent 
x <- x[x$class == 'Percent clients certified in 1st trimester',]
# recode 14 as 2014
x$year <- ifelse(x$year == '14', '2014', x$year)
# Combine year and quarter into a date object 
x$time <- paste0(x$year,  "-0", x$quarter)
x$time <- paste0(x$time, "-01")
# change to date time 
x$time <- as.Date(x$time, format = '%Y-%m-%d')
  
  return(x)
}

# apply function to get clean data set 
first_tri_time1 <- clean_tri_1(first_tri_time1)

##### Read in all 3 sheets from Healthy_Weight.xlsx 
healthy_weight1 <- read_excel('data/Healthy_Weight.xlsx', 1, col_names = FALSE)
healthy_weight2 <- read_excel('data/Healthy_Weight.xlsx', 2, col_names = FALSE)

# Create function to clean both healthy_weight tables
clean_weight1 <- function(x){
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop first column
  x$X0 <- NULL
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make names for county 
  names(x)[1] <- "agency"
  # make name for other columns converting 1st row into date time from excel 
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[1,2:ncol(x)]), origin = '1899-12-30'))
  # clean up county by removing spaces 
  x$agency <- gsub("\\s+", "", x$agency)
  # drop rows up until alachua 
  x <- x[which(x$agency == 'Alachua'):nrow(x),]
  # gather x 
  x <- gather(x, date, value, starts_with('date'))
  # clean up date column
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # remove state 
  x <- x[x$agency != 'State',]
  
  return(x)
}

healthy_weight1 <- clean_weight1(healthy_weight1)

# Make function to clean healthy_weight2
clean_weight2 <- function(x){
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop first column
  x$X0 <- NULL
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make names for county 
  names(x)[1] <- "county"
  # make name for other columns converting 1st row into date time from excel 
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[1,2:ncol(x)]), origin = '1899-12-30'))
  # clean up county by removing spaces 
  x$county <- gsub("\\s+", "", x$county)
  # drop rows up until alachua 
  x <- x[which(x$county == 'Alachua'):nrow(x),]
  # gather x 
  x <- gather(x, date, value, starts_with('date'))
  # clean up date column
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # remove state 
  x <- x[x$county != 'State',]
  
  return(x)
}


healthy_weight2 <- clean_weight2(healthy_weight2)


##### Read in all 4 sheets from Infants Breastfed for 26 weeks june 2015.xlsx 
infants_fed1_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 1, col_names = FALSE)
infants_fed2_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 2, col_names = FALSE)
infants_fed3_june <- read_excel('data/Infants Breastfed for 26 weeks June 2015.xlsx', 3, col_names = FALSE)

# Write function to clean infants_fed1_june 
clean_infants_june1 <- function(x){
  # drop first and last column
  x$X0 <- NULL
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make names for county 
  names(x) <- c("agency_name", "bf_infants", "all_infants")
  # drop first row
  # clean up county by removing spaces 
  x$agency_name <- gsub("\\s+", "", x$agency_name)
  x <- x[(which(x$agency_name == 'Alachua')):nrow(x),]
  # remove state 
  x <- x[x$agency_name != 'State',]
  # make numeric 
  x$bf_infants <- as.numeric(x$bf_infants)
  x$all_infants <- as.numeric(x$all_infants)
  
  return(x)
}

infants_fed1_june <- clean_infants_june1(infants_fed1_june)

# make function for infants_fed2_june
clean_infants_june2 <- function(x){
  # drop any row that has "total" in it
  x <- x[!grepl("Total", x$X0),]
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop last column
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make new names of columns
  names(x) <- c("agency_name", "site", "bf_infants", "ever_bf_infants")
  # clean up county by removing spaces 
  x$agency_name <- gsub("\\s+", "", x$agency_name)
  # drop first row
  x <- x[2:nrow(x),]
  # remove state 
  x <- x[x$agency_name != 'State',]
  
  return(x)
}

# apply new function to infants_fed2_june
infants_fed2_june <- clean_infants_june2(infants_fed2_june)

# create function to clean clean_infants_jun3
clean_infants_june3 <- function(x){
  # drop first and last column
  x$X0 <- NULL
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make names for county 
  names(x) <- c("county", "bf_infants", "all_infants")
  # drop first row
  # clean up county by removing spaces 
  x$county <- gsub("\\s+", "", x$county)
  x <- x[(which(x$county == 'Alachua')):nrow(x),]
  # remove state 
  x <- x[x$county != 'State',]
  
  return(x)
}

infants_fed3_june <- clean_infants_june3(infants_fed3_june)


##### Read in all 3 sheets from Infants Breastfed for 26 weeks.xlsx 
infants_fed1 <- read_excel('data/Infants_Breastfed_For_26_Weeks.xlsx', 1, col_names = FALSE) 
infants_fed2 <- read_excel('data/Infants_Breastfed_For_26_Weeks.xlsx', 2, col_names = FALSE) 

# Create function to clean infants_fed, both tables 
clean_infants1 <- function(x){
  
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop first column
  x$X0 <- NULL
  # make agency_names for county 
  names(x)[1] <- "agency_name"
  # make agency_name for other columns converting 1st row into date time from excel 
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[3,2:ncol(x)]), origin = '1899-12-30'))
  # clean up county by removing spaces 
  x$agency_name <- gsub("\\s+", "", x$agency_name)
  # drop rows up until alachua 
  x <- x[which(x$agency_name == 'Alachua'):nrow(x),]
  # gather x 
  x <- gather(x, date, value, starts_with('date'))
  # clean up date column
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # remove state 
  x <- x[x$agency_name != 'State',]
  # make numeric
  x$value <- as.numeric(x$value)
  
  return(x)
  
}

# apply function to infants_fed1
infants_fed1 <- clean_infants1(infants_fed1)

# create function to clean infants_fed2
clean_infants2 <- function(x){
  
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop first column
  x$X0 <- NULL
  # make agency_names for county 
  names(x)[1] <- "county"
  # make agency_name for other columns converting 1st row into date time from excel 
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[3,2:ncol(x)]), origin = '1899-12-30'))
  # clean up county by removing spaces 
  x$county <- gsub("\\s+", "", x$county)
  # drop rows up until alachua 
  x <- x[which(x$county == 'Alachua'):nrow(x),]
  # gather x 
  x <- gather(x, date, value, starts_with('date'))
  # clean up date column
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # remove state 
  x <- x[x$county != 'State',]
  
  return(x)
  
}

# apply function to infants_fed2
infants_fed2<- clean_infants2(infants_fed2)



##### Read in all 4 sheets from Infants Fully BF for 26 weeks June 2015.xlsx
infants_full1_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 1, col_names = FALSE)
infants_full2_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 2, col_names = FALSE)
infants_full3_june <- read_excel('data/Infants Fully BF for 26 weeks June 2015.xlsx', 3, col_names = FALSE)

# Create a function to clean infants_full1_june 
clean_full1 <- function(x){
 
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop rows that have all NAs
  x <- x[complete.cases(x),]
  # drop first and last column
  x$X0 <- NULL
  x <- x[, 1:(ncol(x)-1)]
  # make names for county 
  names(x) <- c("agency_name", "full_bf", "ever_bf")
  # drop rows up until alachua 
  x <- x[which(x$agency_name == 'Alachua'):nrow(x),]
  # drop state 
  x <- x[which(x$agency_name != 'State'),]
  # Make numeric 
  x$full_bf <- as.numeric(x$full_bf)
  x$ever_bf <- as.numeric(x$ever_bf)
  
  return(x)
}

# apply clean_infants to infants_full1_june
infants_full1_june <- clean_full1(infants_full1_june)


# create a function to clean infants_full2_june
clean_full2 <- function(x){
  
# drop any row that has "total" in it
x <- x[!grepl("Total", x$X0),]
# drop columns with all NAs
x <- x[, colSums(is.na(x)) < nrow(x)]
# drop last column
x <- x[, 1:(ncol(x) -1) ]
# drop top rows filled with NAs
x <- x[complete.cases(x),]
# make new names of columns
names(x) <- c("agency", "site", "fully_bf_infants", "ever_bf_infants")
# clean up county by removing spaces 
x$agency <- gsub("\\s+", "", x$agency)
# drop first row
x <- x[2:nrow(x),]
# drop row with name equal to state 
x <- x[x$site != 'State',]

return(x)
}

# apply second function to infants_full2_june
infants_full2_june <- clean_full2(infants_full2_june)

# Create function to clean infants_full3_june

clean_full3 <- function(x){
  
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop rows that have all NAs
  x <- x[complete.cases(x),]
  # drop first and last column
  x$X0 <- NULL
  x <- x[, 1:(ncol(x)-1)]
  # make names for county 
  names(x) <- c("county", "full_bf", "ever_bf")
  # drop rows up until alachua 
  x <- x[which(x$county == 'Alachua'):nrow(x),]
  # drop state 
  x <- x[which(x$county != 'State'),]
  
  return(x)
}

infants_full3_june <- clean_full3(infants_full3_june)

##### Read in all 3 sheets for Infants_Fully_Breastfed_For_26_Weeks.xlsx
infants_full2 <- read_excel('data/Infants_Fully_Breastfed_For_26_Weeks.xlsx', 2, col_names = FALSE)
infants_full3 <- read_excel('data/Infants_Fully_Breastfed_For_26_Weeks.xlsx', 3, col_names = FALSE)

clean_full_date1 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)] 
  # drop first column 
  x <- x[,2:ncol(x)]
  # Names columns X0,X2,X3 
  names(x)[1] <- "agency_name"
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[3,2:ncol(x)]), origin = '1899-12-30'))
  # clean county names-- replace spaces with nothing
  x$agency_name <- gsub("\\s+", "", x$agency_name)
  # Drop rows until name is alachua
  x <- x[(which(x$agency_name == 'Alachua')):nrow(x),]
  # gather x
  x <- gather(x, date, per_full_bf, starts_with('date'))
  # clean date column 
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # drop state 
  x <- x[which(x$agency_name != 'State'),]
  # Make numeric 
  x$per_full_bf<- as.numeric(x$per_full_bf)
  
  return(x)
}

# apply function to both data sets 
infants_full2 <- clean_full_date1(infants_full2)

# Create function to clean infants_full3
clean_full_date2 <- function(x){
  # subset x by removing columns that are filled entirely with NAs
  x <- x[,colSums(is.na(x))<nrow(x)] 
  # drop first column 
  x <- x[,2:ncol(x)]
  # Names columns X0,X2,X3 
  names(x)[1] <- "county"
  names(x)[2:ncol(x)] <- paste0("date", as.Date(as.numeric(x[3,2:ncol(x)]), origin = '1899-12-30'))
  # clean county names-- replace spaces with nothing
  x$county <- gsub("\\s+", "", x$county)
  # Drop rows until name is alachua
  x <- x[(which(x$county == 'Alachua')):nrow(x),]
  # gather x
  x <- gather(x, date, per_full_bf, starts_with('date'))
  # clean date column 
  x$date <- as.Date(gsub("date", "", x$date), format = '%Y-%m-%d')
  # drop state 
  x <- x[which(x$county != 'State'),]
  
  return(x)
}
infants_full3 <- clean_full_date2(infants_full3)


##### Read in all 4 sheets of Non-Hisp Black Ever BF Clients - June 2015.xlsx
# rename file to Non_Hisp Black Ever BF Clients_June 2015.xlsx
non_hisp1 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 1, col_names = FALSE)
non_hisp2 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 2, col_names = FALSE)
non_hisp3 <- read_excel('data/Non_Hisp Black Ever BF Clients_June 2015.xlsx', 3, col_names = FALSE)

# make function to clean non_hips1
clean_hisp1 <- function(x){
  
  # drop any row that has "total" in it
  x$X0 <- NULL
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop last column
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make new names of columns
  names(x) <- c("agency_name", "ever_bf", "all")
  # clean up county by removing spaces 
  x$agency_name <- gsub("\\s+", "", x$agency_name)
  # drop first row
  x <- x[2:nrow(x),]
  # drop row with name equal to state 
  x <- x[x$agency_name != 'State',]
  # make numeric 
  x$ever_bf <- as.numeric(x$ever_bf)
  x$all <- as.numeric(x$all)
  
  return(x)
}

# apply function to non_hisp1
non_hisp1 <- clean_hisp1(non_hisp1)

# create function to clean non_hisp2
clean_hisp2 <- function(x){
  
  # drop any row that has "total" in it
  x <- x[!grepl("Total", x$X0),]
  # drop last column
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make new names of columns
  names(x) <- c("agency", "site", "ever_bf", "all")
  # clean up county by removing spaces 
  x$agency <- gsub("\\s+", "", x$agency)
  # drop first row
  x <- x[2:nrow(x),]
  
  return(x)
  
}

# apply function to non_hisp2
non_hisp2 <- clean_hisp2(non_hisp2)

# Create a function to clean non_hisp3
# make function to clean non_hips1
clean_hisp3 <- function(x){
  
  # drop any row that has "total" in it
  x$X0 <- NULL
  # drop columns with all NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]
  # drop last column
  x <- x[, 1:(ncol(x) -1) ]
  # drop top rows filled with NAs
  x <- x[complete.cases(x),]
  # make new names of columns
  names(x) <- c("county", "ever_bf", "all")
  # clean up county by removing spaces 
  x$county <- gsub("\\s+", "", x$county)
  # drop first row
  x <- x[2:nrow(x),]
  # drop row with name equal to state 
  x <- x[x$county != 'State',]
}

non_hisp3 <- clean_hisp3(non_hisp3)


##### Read in all 3 sheets of Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx 
high_risk2 <- read_excel('data/Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx', 2, col_names = FALSE)
high_risk3 <- read_excel('data/Nutrition_Education_Contacts_For_High_Risk_Clients.xlsx', 3, col_names = FALSE)

# Create function to clean high_risk2
clean_high_2 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]  
  # drop first row 
  x$X0 <- NULL
  # Get first column name
  names(x)[1] <- 'county'
  # Standardize column names for the rest of the data
  for (j in 2:ncol(x)){
    column_indicator <- j
    # manipulate the date objects
    if(j == ncol(x)){
      column_indicator <- column_indicator - 2
    }else{
      if(is.na(x[2,column_indicator])){
        column_indicator <- column_indicator +1
        if(is.na(x[2, column_indicator])){
          column_indicator <- column_indicator - 2
        }
      } 
    }
    
    # Fix column indicator for last column
    column_indicator <- ifelse(column_indicator > ncol(x),
                               ncol(x)-1, column_indicator)
    
    # Get the date object
    date_object <- unlist(strsplit(as.character(x[2,column_indicator]), ' - '))
    # Deal with differential number vs. hyphenated date stuff
    if(length(date_object) == 2){
      date_object <- date_object[length(date_object)]
      # Extract the quarter
      quarter <- ifelse(grepl('03', date_object), 1,
                        ifelse(grepl('06', date_object), 2,
                               ifelse(grepl('09', date_object), 3,
                                      ifelse(grepl('12', date_object), 4, NA))))
      # Extract the year
      year <- as.numeric(unlist(strsplit(date_object, '/'))[3])  
    } 
   # Paste together the quarter, year and third row info
    column_name <- paste0(year,"_", quarter,"_", x[3,j])
    # Stick that column name where it belongs
    names(x)[j] <- column_name
  }
  
  # remove columns that contain "%" 
  x <- x[, !grepl("%", names(x))]
  # remove first 3 rows
  x <- x[4:nrow(x),]
  # gather
  x <- gather(x, key, value, 2:ncol(x))
  # strsplit the key on underscore creating year, quarter and description columns 
  list <- strsplit(as.character(x$key), '_')
  # turn list into data table object
  temp <- ldply(list)
  # make column names
  colnames(temp) <- c("year", "quarter", "class")
  # put back into x
  x <- cbind(x, temp)
  # remove extra columns in x 
  x <- x[, c("county", "year", "quarter", "class", "value")]
  # drop state total row
  x <- x[which(x$county != 'State Total'),]
  return(x)
  
  
}

# apply function to high_risk2
high_risk2 <- clean_high_2(high_risk2)

# create function to clean high_risk3 
clean_high_3 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]  
  # Get first column name
  names(x)[1] <- 'agency_name'
  # Standardize column names for the rest of the data
  for (j in 2:ncol(x)){
    column_indicator <- j
    # manipulate the date objects
    if(j == ncol(x)){
      column_indicator <- column_indicator - 2
    }else{
      if(is.na(x[2,column_indicator])){
        column_indicator <- column_indicator +1
        if(is.na(x[2, column_indicator])){
          column_indicator <- column_indicator - 2
        }
      } 
    }
    
    # Fix column indicator for last column
    column_indicator <- ifelse(column_indicator > ncol(x),
                               ncol(x)-1, column_indicator)
    
    # Get the date object
    date_object <- unlist(strsplit(as.character(x[2,column_indicator]), ' - '))
    # Deal with differential number vs. hyphenated date stuff
    if(length(date_object) == 2){
      date_object <- date_object[length(date_object)]
      # Extract the quarter
      quarter <- ifelse(grepl('03', date_object), 1,
                        ifelse(grepl('06', date_object), 2,
                               ifelse(grepl('09', date_object), 3,
                                      ifelse(grepl('12', date_object), 4, NA))))
      # Extract the year
      year <- as.numeric(unlist(strsplit(date_object, '/'))[3])  
    } 
    # Paste together the quarter, year and third row info
    column_name <- paste0(year,"_", quarter,"_", x[3,j])
    # Stick that column name where it belongs
    names(x)[j] <- column_name
  }
  
  # remove columns that contain "%" 
  x <- x[, !grepl("%", names(x))]
  # remove first 3 rows
  x <- x[4:nrow(x),]
  # gather
  x <- gather(x, key, value, 2:ncol(x))
  # strsplit the key on underscore creating year, quarter and description columns 
  list <- strsplit(as.character(x$key), '_')
  # turn list into data table object
  temp <- ldply(list)
  # make column names
  colnames(temp) <- c("year", "quarter", "class")
  # put back into x
  x <- cbind(x, temp)
  # remove extra columns in x 
  x <- x[, c("agency_name", "year", "quarter", "class", "value")]
  # drop state total row
  x <- x[which(x$agency_name != 'STATE TOTAL'),]
  
  return(x)
  
  
}

# apply function to high risk 3
high_risk3<- clean_high_3(high_risk3)

##### Read in all 3 sheets of Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx
low_risk2 <- read_excel('data/Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx', 2, col_names = FALSE)
low_risk3 <- read_excel('data/Nutrition_Education_Contacts_For_Low_Risk_Clients.xlsx', 3, col_names = FALSE)

# creat function to clean low_risk2 
clean_low_2 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]  
  # drop first row 
  x$X0 <- NULL
  # Get first column name
  names(x)[1] <- 'agency_name'
  # Standardize column names for the rest of the data
  for (j in 2:ncol(x)){
    column_indicator <- j
    # manipulate the date objects
    if(j == ncol(x)){
      column_indicator <- column_indicator - 2
    }else{
      if(is.na(x[3,column_indicator])){
        column_indicator <- column_indicator +1
        if(is.na(x[3, column_indicator])){
          column_indicator <- column_indicator - 2
        }
      } 
    }
    
    # Fix column indicator for last column
    column_indicator <- ifelse(column_indicator > ncol(x),
                               ncol(x)-1, column_indicator)
    
    # Get the date object
    date_object <- unlist(strsplit(as.character(x[3,column_indicator]), ' - '))
    # Deal with differential number vs. hyphenated date stuff
    if(length(date_object) == 2){
      date_object <- date_object[length(date_object)]
      # Extract the quarter
      quarter <- ifelse(grepl('03', date_object), 1,
                        ifelse(grepl('06', date_object), 2,
                               ifelse(grepl('09', date_object), 3,
                                      ifelse(grepl('12', date_object), 4, NA))))
      # Extract the year
      year <- as.numeric(unlist(strsplit(date_object, '/'))[3])  
    } 
    # Paste together the quarter, year and third row info
    column_name <- paste0(year,"_", quarter,"_", x[4,j])
    # Stick that column name where it belongs
    names(x)[j] <- column_name
  }
  
  # remove columns that contain "%" 
  x <- x[, !grepl("%", names(x))]
  # remove first 3 rows
  x <- x[5:nrow(x),]
  # gather
  x <- gather(x, key, value, 2:ncol(x))
  # strsplit the key on underscore creating year, quarter and description columns 
  list <- strsplit(as.character(x$key), '_')
  # turn list into data table object
  temp <- ldply(list)
  # make column names
  colnames(temp) <- c("year", "quarter", "class")
  # put back into x
  x <- cbind(x, temp)
  # remove extra columns in x 
  x <- x[, c("agency_name", "year", "quarter", "class", "value")]
  # drop state total row
  x <- x[which(x$agency_name != 'State Total'),]
  
  return(x)
  
  
}
# apply function to low_risk2 
low_risk2 <- clean_low_2(low_risk2)

# Create function to clean low_risk3

clean_low_3 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)]  
  # drop first row 
  x$X0 <- NULL
  # Get first column name
  names(x)[1] <- 'county'
  # Standardize column names for the rest of the data
  for (j in 2:ncol(x)){
    column_indicator <- j
    # manipulate the date objects
    if(j == ncol(x)){
      column_indicator <- column_indicator - 2
    }else{
      if(is.na(x[4,column_indicator])){
        column_indicator <- column_indicator +1
        if(is.na(x[4, column_indicator])){
          column_indicator <- column_indicator - 2
        }
      } 
    }
    
    # Fix column indicator for last column
    column_indicator <- ifelse(column_indicator > ncol(x),
                               ncol(x)-1, column_indicator)
    
    # Get the date object
    date_object <- unlist(strsplit(as.character(x[4,column_indicator]), ' - '))
    # Deal with differential number vs. hyphenated date stuff
    if(length(date_object) == 2){
      date_object <- date_object[length(date_object)]
      # Extract the quarter
      quarter <- ifelse(grepl('03', date_object), 1,
                        ifelse(grepl('06', date_object), 2,
                               ifelse(grepl('09', date_object), 3,
                                      ifelse(grepl('12', date_object), 4, NA))))
      # Extract the year
      year <- as.numeric(unlist(strsplit(date_object, '/'))[3])  
    } 
    # Paste together the quarter, year and third row info
    column_name <- paste0(year,"_", quarter,"_", x[5,j])
    # Stick that column name where it belongs
    names(x)[j] <- column_name
  }
  
  # remove columns that contain "%" 
  x <- x[, !grepl("%", names(x))]
  # remove first 3 rows
  x <- x[6:nrow(x),]
  # gather
  x <- gather(x, key, value, 2:ncol(x))
  # strsplit the key on underscore creating year, quarter and description columns 
  list <- strsplit(as.character(x$key), '_')
  # turn list into data table object
  temp <- ldply(list)
  # make column names
  colnames(temp) <- c("year", "quarter", "class")
  # put back into x
  x <- cbind(x, temp)
  # remove extra columns in x 
  x <- x[, c("county", "year", "quarter", "class", "value")]
  # drop state total row
  x <- x[which(x$county != 'State Total'),]
      
  return(x)
  
  
}

# apply function to low_risk3 
low_risk3 <- clean_low_3(low_risk3)

##### Read in all 3 sheets of Overweight_And_Obese_Children.xlsx 
over_obese1 <- read_excel('data/Overweight_And_Obese_Children.xlsx', 1, col_names = FALSE)
over_obese2 <- read_excel('data/Overweight_And_Obese_Children.xlsx', 2, col_names = FALSE)

# Create function to clean over_obese1 
clean_over <- function(x){
  
  # drop first row
  x$X0 <- NULL
  # drop rows with all NAs
  x <- x[complete.cases(x),]
  # remove columns with "or"
  for(j in 2:ncol(x)){
    if(grepl("or", x[1,j])){
      x[,j] <- NULL
    }
  }
  # change names of columns
  names(x)[1] <- "county"
  for(j in 2:ncol(x)){
        temp <- gsub("\\s+", "_", x[1,j])
        names(x)[j] <- temp
  }
  # drop first row 
  x <- x[2:nrow(x),]
  # gather x 
  x <- gather(x, class, percent, 2:ncol(x))
  # split class to separate date 
  x <- cSplit(x, "class", "_", fixed = FALSE)
  x <- as.data.frame(x)
  # fill class_7 NAS with 0
  x$class_7 <- as.character(x$class_7)
  x[is.na(x)] <- 0
  # create new column that with weight status
  x$weight_status <- ifelse(as.factor(x$class_7) == '(Overwt)', 'overweight', 'obese')
  # keep only necessary columns 
  x <- x[, c("county","percent", "class_1", "class_2", "weight_status")]
  # rename columns
  names(x) <- c("county", "percent", "month", "year", "weight_status")
  
  return(x)
  
}

# apply function to over_obese1
over_obese1 <- clean_over(over_obese1)

over_obese2 <- clean_over(over_obese2)

##### Read in all 4 sheets of Percent BF Infants in WIC June 2015.xlsx
percent_bf1_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 1, col_names = FALSE)
percent_bf2_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 2, col_names = FALSE)
percent_bf3_june <- read_excel('data/Percent BF Infants in WIC June 2015.xlsx', 3, col_names = FALSE)

# Make function to clean percent_bf1_june 
clean_per1 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # get only rows that have no NAs
  x <- x[complete.cases(x),]
  # drop first row 
  x <- x[,2:(ncol(x) -1)]
  # Get first column name
  names(x) <- c('agency_name', 'currently_bf', 'total_infants')
  x <- x[which(x$agency_name != 'State'),]
  # Make as numeric
  x$currently_bf <- as.numeric(x$currently_bf)
  x$total_infants <- as.numeric(x$total_infants)  
  return(x)

}

# apply function to percent_bf1_june 
percent_bf1_june <- clean_per1(percent_bf1_june)

# create function to clean percent_bf2_june 
clean_per2 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # get only rows that have no NAs
  x <- x[complete.cases(x),]
  # drop any row that has "total" in it
  x <- x[!grepl("Total", x$X0),]
  # drop first row 
  x <- x[,1:(ncol(x)-1)]
  # Get first column name
  names(x) <- c('LA','site', 'currently_bf', 'total_infants')
  # drop first row 
  x <- x[2:nrow(x),]
  
  return(x)
  
}

# apply function to percent_bf2_june
percent_bf2_june <- clean_per2(percent_bf2_june)

# create function to clean percent_bf3_june
clean_per3 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # get only rows that have no NAs
  x <- x[complete.cases(x),]
  # drop first row 
  x <- x[,1:(ncol(x) -1)]
  # Get first column name
  names(x) <- c('county', 'currently_bf', 'total_infants')
  # drop first row 
  x <- x[2:nrow(x),]
  # drop state total from x 
  x <- x[which(x$county != 'State'),]
  
  return(x)
  
  
}

# apply function to percent_bf3_june
percent_bf3_june <- clean_per3(percent_bf3_june)

##### Read in all 3 sheets of Percent_Of_Breastfed_Infants_In_WIC.xlsx
percent_bf1 <- read_excel('data/Percent_Of_Breastfed_Infants_In_WIC.xlsx', 1, col_names = FALSE)
percent_bf2 <- read_excel('data/Percent_Of_Breastfed_Infants_In_WIC.xlsx', 2, col_names = FALSE)

# make function to clean percent_bf1 
clean_bf1 <- function(x){
  
  # drop first column
  x$X0 <- NULL
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # only keep complete cases 
  x <- x[complete.cases(x),]
  # change names of columns
  names(x)[1] <- "agency_name"
  for(i in 2:ncol(x)){
    date_indicator <- x[1,i]
    names(x)[i] <- paste0('date',as.Date(as.numeric(date_indicator), origin = '1899-12-30'))
  }
  # Drop first row
  x <- x[2:nrow(x),]
  # drop state total 
  x <- x[1:(nrow(x) - 1),]
  # Gather x 
  x <- gather(x, date,percent, starts_with('date'))
  # drop date from date column
  x$date <- gsub("date","", x$date)
  # drop state total from x 
  x <- x[which(x$agency_name != 'State'),]
  # make into date object
  x$date <- as.Date(x$date, format = '%Y-%m-%d')
  
  
  return(x)
  
}

#apply function to percent_bf1 and percent_bf2
percent_bf1 <- clean_bf1(percent_bf1)

# Create function to clean percent_bf2
clean_bf2 <- function(x){
  
  # drop first column
  x$X0 <- NULL
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # only keep complete cases 
  x <- x[complete.cases(x),]
  # change names of columns
  names(x)[1] <- "county"
  for(i in 2:ncol(x)){
    date_indicator <- x[1,i]
    names(x)[i] <- paste0('date',as.Date(as.numeric(date_indicator), origin = '1899-12-30'))
  }
  # Drop first row
  x <- x[2:nrow(x),]
  # drop state total 
  x <- x[1:(nrow(x) - 1),]
  # Gather x 
  x <- gather(x, date,percent, starts_with('date'))
  # drop date from date column
  x$date <- gsub("date","", x$date)
  # drop state total from x 
  x <- x[which(x$county != 'State'),]
  
  return(x)
  
}

# apply function to percent_bf2
percent_bf2 <- clean_bf2(percent_bf2)


##### Read in all 3 sheets of Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx
percent_ever1 <- read_excel('data/Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx', 1, col_names = FALSE)
percent_ever2 <- read_excel('data/Percent_Of_WIC_Infants_And_Children_Ever_Breastfed.xlsx', 2, col_names = FALSE)

# use clean_bf to clean percent_ever1 and percent_ever2
percent_ever1 <- clean_bf1(percent_ever1)
percent_ever2 <- clean_bf2(percent_ever2)


##### Read in all 4 sheets of Prenatal Entry in First Trim in June 2015.xlsx 
pre_entry1 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 1, col_names = FALSE)
pre_entry2 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 2, col_names = FALSE)
pre_entry3 <- read_excel('data/Prenatal Entry in First Trim in June 2015.xlsx', 3, col_names = FALSE)

# make function to clean pre_entry1
clean_entry1 <- function(x){
  
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # get only rows that have no NAs
  x <- x[complete.cases(x),]
  # drop first and last columns
  x <- x[,2:(ncol(x) -1)]
  # Get first column name
  names(x) <- c('agency_name', 'certified_first_tri', 'all_prenatals')
  # drop first row 
  x <- x[2:nrow(x),]
  # drop state total from x 
  x <- x[which(x$agency_name != 'State'),]
  # make as numeric
  x$all_prenatals <- as.numeric(x$all_prenatals)
  x$certified_first_tri <- as.numeric(x$certified_first_tri)
  
  return(x)
  
}

# apply function to pre_entry1
pre_entry1 <- clean_entry1(pre_entry1)

# Make function to clean pre_entry2 
clean_entry2 <- function(x){
  
  # drop rows with "total"
  x <- x[!grepl('Total', x$X0),]
  # subset x by removing columns that are filled entirely with NAs
  x <- x[, colSums(is.na(x)) < nrow(x)] 
  # get only rows that have no NAs
  x <- x[complete.cases(x),]
  # drop first and last columns
  x <- x[,1:(ncol(x) -1)]
  # Get first column name
  names(x) <- c('agency', 'name', 'cert_first_tri', "all_prenatals")
  # drop first row 
  x <- x[2:nrow(x),]
  
  return(x)
}

# apply function to pre_entry2
pre_entry2 <- clean_entry2(pre_entry2)

# apply clean_entry1 to pre_entry3
pre_entry3 <- clean_entry1(pre_entry3)
