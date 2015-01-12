fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./power_consumption.zip",method="curl")
unzip("power_consumption.zip")
length(readLines("household_power_consumption.txt"))
# memory required = no. of column * no. of rows * 8 bytes
# 2,075,259 rows and 9 columns
memoryneeded<-2075259*9*8/(10^9)
library(data.table)
# Subset the data to only include the dates
# thanks to Alexey Burlutskiy for help subsetting before reading in the data
# https://class.coursera.org/exdata-010/forum/thread?thread_id=20#comment-85
# Measurements are taken every minute so the time difference between 2/1/07  and 
# end of day 2/2/07 will be the number of rows of data to read in
dtime <- difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),units="mins")
rowsToRead <- as.numeric(dtime)
library(data.table)
DT <- fread("household_power_consumption.txt", skip="1/2/2007", 
            nrows = rowsToRead, na.strings = c("?", ""))
# set column names to descriptive names pulled from line 1 of the dataset
variablenames<-names(read.table("household_power_consumption.txt", sep=";",nrows=1, header=TRUE))
setnames(DT,variablenames)

#Create third plot
DT$DateTime<- as.POSIXct(paste(DT$Date,DT$Time), format="%d/%m/%Y %H:%M:%S")
png(file="plot3.png")
with(DT, 
     {plot(DateTime, Sub_metering_1, type="l",ylab="Energy sub metering",
             xlab="") ## Create plot with first line
      lines(DateTime,Sub_metering_2, col="red") ## Add second line to plot
      lines(DateTime,Sub_metering_3, col="blue") ## Add 3rd line to plot
      legend("topright",
             c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
             lty=c(1,1,1),
             col=c("black", "red", "blue")) ## Create legend
           })
dev.off()

