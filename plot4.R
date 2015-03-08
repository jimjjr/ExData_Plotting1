## This script contains all the code necessary to download the Electric power
## consumption data taken from the UC Irvine Machine Learning Repository,
## load the data into R, and generate a PNG graphical image of four sub-plots 
## of data from Household Electrical Power Consumption Data over the dates
## 2007-02-01 and 2007-02-02, saving the image to the PNG file "plot4.png" 
## in the working directory.
## Regarding the plots:
## The top-left plot shows Global Active Power usage over time.
## The top-right plot shows Voltage over time.
## The bottom-left plot shows energy sub metering data over time.
## The bottom-right plot of global reactive power over time.


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

## Generate a PNG graphical image of four sub-plots from Household Electrical
## Power Consumption Data and save to "plot4.png"
png("plot4.png", bg="transparent")
par(mfrow=c(2,2))

## Create top-left plot of Global Active Power usage over time
with(HPC_filtered, {
    plot(datetime, Global_active_power, type="l", 
         xlab = "", ylab = "Global Active Power")
})

## Create top-right plot of Voltage over time
with(HPC_filtered, {
    plot(datetime, Voltage, type = "l")
})

## Create bottom-left plot of the three energy sub metering data over time
with(HPC_filtered, {
    plot(datetime, Sub_metering_1, type = "l", col = "black", 
         xlab = "", ylab = "Energy sub metering")
    points(datetime, Sub_metering_2, type = "l", col = "red")
    points(datetime, Sub_metering_3, type = "l", col = "blue")
    legend("topright", 
           c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty = 1,
           col = c("black", "red", "blue"),
           bty = "n"
    )
})

## Create bottom-right plot of global reactive power over time
with(HPC_filtered, {
    plot(datetime, Global_reactive_power, type = "l")
})

## Remember to close PNG device once we're done writing to it
dev.off()

## Reset for 1x1 plots (normal default) if script is used in an interactive 
## session
if (interactive()){
    par(mfrow = c(1,1))
}