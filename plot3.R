############################
## Loading and cleaning data
############################

## Get the column names
tmp = read.csv("household_power_consumption.txt", sep=";", nrows=1)

## Just some rows containing the required records
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

## Cleaning objects useless
rm(tmp)
rm(classes)



############################
## Creating the plot
############################
Sys.setlocale("LC_ALL", "English")
plot(data$DateTime, data$Sub_metering_1, ylab="Energy sub metering", xlab="", type="l", col="black")
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))



############################
## Saving the plot
############################
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()
