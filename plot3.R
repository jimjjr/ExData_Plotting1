## This script contains all the code necessary to download the Electric power
## consumption data taken from the UC Irvine Machine Learning Repository,
## load the data into R, generate a plot of energy sub metering over time for 
## the dates of 2007-02-01 and 2007-02-02, with a color-coded curve for each of
## the three power stations. The resulting plot is saved to the PNG file 
## "plot3.png" in the working directory.


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

## Generate a plot of energy sub metering over time with a color-coded curve
## for each of the three power stations. Note that x-axis scaling and labeling
## are automatically added by the plotting system. 
## Save plot to PNG file "plot3.png"
png("plot3.png", bg="transparent")
with(HPC_filtered, {
    plot(datetime, Sub_metering_1, type = "l", col = "black", 
         xlab = "", ylab = "Energy sub metering")
    points(datetime, Sub_metering_2, type = "l", col = "red")
    points(datetime, Sub_metering_3, type = "l", col = "blue")
    legend("topright", 
           c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty = 1,
           col = c("black", "red", "blue"),
           #          bty = "n"
    )
})
dev.off()