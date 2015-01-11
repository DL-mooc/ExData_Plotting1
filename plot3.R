#######################################
# reading in data for the dates to explore
#######################################
obsExploreStartDate <- strptime("2007-02-01 00:00:00", "%Y-%m-%d %H:%M:%S")

# need to read a line for every minute in two days
numLines <- 60 * 24 * 2

# looked it up in the file:
# - read a few first lines as is: samples seem ordered by date, start from 2006-12-16 17:24
# - need to skip all minutes between 2006-12-16 17:24 and 2007-02-01 00:00
# - also need to skip the first line
obsDataStartDate <- strptime("2006-12-16 17:24:00", "%Y-%m-%d %H:%M:%S")
lastLineBefore <- as.numeric(difftime(obsExploreStartDate, obsDataStartDate, units="mins")) + 1

# will be reading only a portion in the middle of the file,
# so the column names won't be read automatically
# have to provide them
colNames <- c("Date",
             "Time",
             "Global_active_power",
             "Global_reactive_power",
             "Voltage",
             "Global_intensity",
             "Sub_metering_1",
             "Sub_metering_2",
             "Sub_metering_3") 

archiveFile <- "./data/exdata_data_household_power_consumption.zip"
fileNameInArchive <- "household_power_consumption.txt"

ds <- read.table(unz(archiveFile, fileNameInArchive),
               sep = ";", 
               na.strings = "?", 
               skip = lastLineBefore, 
               nrows = numLines,
               col.names = colNames)

#######################################
# plotting data to a png file
#######################################
plotFilename <- "plot3.png"

datetime <- strptime(paste(ds[,"Date"], ds[,"Time"]),"%d/%m/%Y %H:%M:%S")

png(plotFilename, width=480, height=480)

plot(datetime, ds[,"Sub_metering_1"], ylab="Energy sub metering", xlab="", type="n")
lines(datetime, ds[,"Sub_metering_1"], type="l")
lines(datetime, ds[,"Sub_metering_2"], type="l", col="red")
lines(datetime, ds[,"Sub_metering_3"], type="l", col="blue")

colors<-c("black", "red", "blue")
vars <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend("topright", lty=1, col=colors, legend=vars)

dev.off()
