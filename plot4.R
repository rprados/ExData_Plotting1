############################
## Loading and cleaning data
############################

## Get the column names
tmp = read.csv("household_power_consumption.txt", sep=";", nrows=1)

## Just some rows
classes = c("character", "character", rep("numeric", 7))
data = read.csv("household_power_consumption.txt", sep=";", 
                skip=60000, nrows=10000, colClasses = classes, na.strings = "?")

## Set the right column names
names(data) = names(tmp)

## Convert the Date and Time variables to Date/Time classes
data$DateTime = strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
data$Year = as.numeric(format(data$DateTime, format="%Y"))
data$Month = as.numeric(format(data$DateTime, format="%m"))
data$Day = as.numeric(format(data$DateTime, format="%d"))
data$Hour = as.numeric(format(data$DateTime, format="%H"))
data$Minute = as.numeric(format(data$DateTime, format="%M"))

## Just data from the dates 2007-02-01 and 2007-02-02
data = subset(data, data$Year == 2007 & data$Month == 2 & (data$Day == 1 | data$Day == 2))

## Looking for missing values
columns = names(data)
for (column in columns) {
  print(paste("The column",column, "has",sum(data[,column] == "?"),"? values"))
}

## Cleaning objects useless
rm(tmp)
rm(classes)
rm(columns)
rm(column)



############################
## Creating the plot
############################
Sys.setlocale("LC_ALL", "English")
par(mfrow = c(2, 2))

## Top left
plot(data$DateTime, data$Global_active_power, ylab="Global Active Power", xlab="", type="l")

## Top right
plot(data$DateTime, data$Voltage, ylab="Voltage", xlab="datetime", type="l")

## Bottom left
plot(data$DateTime, data$Sub_metering_1, ylab="Energy sub metering", xlab="", type="l", col="black")
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       bty="n", pt.cex=1, cex=0.5, y.intersp=0.75,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Bottom right
plot(data$DateTime, data$Global_reactive_power, ylab="Global_reactive_power", xlab="datetime", type="l")



############################
## Saving the plot
############################
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()

