## Set my language to ENGLISH
##_____________________________________________________________________________________
Sys.setlocale("LC_ALL", "English")

## I will use the sqldf package for load only the needed data
##_____________________________________________________________________________________
if(!require('sqldf')){
  install.packages('sqldf')
}
library(sqldf)

## Download the Dataset:
##_____________________________________________________________________________________
TmpFile <- "exdata-data-household_power_consumption.zip"


if (!file.exists(TmpFile)){
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(URL, TmpFile)
  
} 

## Unzip the file if needed:
##_____________________________________________________________________________________
DatFile <- "household_power_consumption.txt"
if (!file.exists(DatFile)) { 
  unzip(TmpFile) 
}

## Extract only the Needed DATA.
##_____________________________________________________________________________________
Data_Power_Consumption <- read.csv.sql(DatFile, sql="SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'", sep=';'
                                       ,colClasses=c("character", "character", rep("numeric", 7))
                                       ,header=T)

## Transform the Date and Time variables into Date-Time classes
##_____________________________________________________________________________________
Data_Power_Consumption$Date <- as.Date(Data_Power_Consumption$Date , "%d/%m/%Y")
Data_Power_Consumption$Time <- paste(Data_Power_Consumption$Date, Data_Power_Consumption$Time, sep=" ")
Data_Power_Consumption$Time <- strptime(Data_Power_Consumption$Time, "%Y-%m-%d %H:%M:%S")

# Generate the Plot 
##_____________________________________________________________________________________
png("plot3.png", width = 480, height = 480)
with(Data_Power_Consumption, {
  plot(Time, Sub_metering_1, type='l', xlab='', ylab="Energy sub metering")
  lines(Time, Sub_metering_2, type='l', col='red')
  lines(Time, Sub_metering_3, type='l', col='blue')
})

legend('topright', legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lwd='1', col=c('black', 'red', 'blue'))
dev.off()

