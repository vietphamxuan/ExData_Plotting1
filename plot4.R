# Plot all four graphs
# and save the plots as png file
plot4 <- function()
{
  DownloadAndReadData()
  
  # plot 4
  par(mfrow = c(2, 2))
  with(finalData, {
      plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
      plot(DateTime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
      plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
      lines(DateTime, Sub_metering_2, col = "red")
      lines(DateTime, Sub_metering_3, col = "blue")
      legend("topright", col = c("black", "red", "blue"), cex = 0.7, lty = 1, bty = "n",
             legend = c("Sub_metering_1", 
                        "Sub_metering_2",
                        "Sub_metering_3"))
      plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global Reactive Power")
  })
  # copy plot to png file
  dev.copy(png, file = "plot4.png")
  # close connection to png device
  dev.off()
}

# Download the zip file, extract it out
# Read the entire data set which don't have "?"
# Select only the data which has date range 2007-02-01 and 2007-02-02
# Save the final data into a global finalDate variable
DownloadAndReadData <- function(){
    
    # If a temp folder doesn't exist, create it in the working directory
    if(!file.exists("temp")){
        dir.create("temp")
    }
    
    # if the power_consumption.zip doesn't exist go and download it
    # and extract the household_power_consumption.txt to the temp folder
    if(!file.exists("./temp/power_consumption.zip")){
        # The file URL & destination file
        sourceFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        destination <- "./temp/power_consumption.zip"
        
        # download the file
        download.file(sourceFileUrl, destination)
        
        # unzip the file household_power_consumption.txt into the temp folder
        unzip(destination,"household_power_consumption.txt", exdir="temp")
    }
    
    # Read all data into allData variable
    allData <- read.csv("./temp/household_power_consumption.txt", sep=";", na.string ="?")
    
    # Add a new column with date and time combined
    # This is used in plot2, plot3, plot4
    allData$DateTime <- strptime(paste(allData$Date, allData$Time), format = "%d/%m/%Y %T")
    
    # Convert the Date from factor to Date type
    allData$Date <- as.Date(allData$Date, "%d/%m/%Y")
    
    # select only the date range between "2007-02-01" & "2007-02-02"
    # and save it into global env so that finalData will not be out of scope
    finalData <<- allData[(allData$Date>=as.Date("2007-02-01") & allData$Date<=as.Date("2007-02-02")),]
}