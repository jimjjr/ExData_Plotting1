## This script contains all the code necessary to download the Electric power
## consumption data taken from the UC Irvine Machine Learning Repository,
## load the data into R, generate histogram plot of the Global_active_power 
## variable for the dates of 2007-02-01 and 2007-02-02 and save the resulting 
## plot to a PNG file named "plot1.png" in the working directory.


## Check that required packages are installed and install any that are missing
required_packages <- c("dplyr", "lubridate")
missing_packages <- required_packages[!(required_packages %in% 
                                            installed.packages()[,"Package"])]
if(length(missing_packages)) {
    install.packages(missing_packages)
}

## Load required packages
library(dplyr)
library(lubridate)

## Download Household Power Consumption Data to temp folder
ElectricPowerConsumption_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(ElectricPowerConsumption_URL, temp)

## Unzip temp file and load all data to an R data.frame
HPC_filename <- "household_power_consumption.txt"
HPC_data <- read.table(unz(temp, HPC_filename), 
                       header=TRUE, sep=";",
                       na.strings="?", 
                       colClasses=c("character", "character", "numeric",
                                    "numeric", "numeric", "numeric", "numeric",
                                    "numeric", "numeric"),
                       comment.char="", stringsAsFactors=FALSE)

## Delete temporary file
unlink(temp)

## Convert to dplyr tbl_df for convenience
HPC_data <- tbl_df(HPC_data)

## Create and add useful datetime column to HPC_data from text in 
## Date and Time columns
HPC_data <- mutate(HPC_data, datetime=dmy(Date) + hms(Time))

## Select only the data for the dates of interest, stored to new variable
start_date <- ymd("2007-02-01")
end_date <- ymd("2007-02-03")
HPC_filtered <- filter(HPC_data, datetime > start_date & datetime < end_date)

## Remove unneeded original data from namespace to clear up memory space
remove(HPC_data)

## Generate histogram plot of Global_active_power variable and save to .png
## file name "plot1.png"
png("plot1.png", bg="transparent")
p1 <- hist(HPC_filtered[["Global_active_power"]], col="red", 
           xlab = "Global Active Power (kilowatts)",
           main = "Global Active Power")
dev.off()