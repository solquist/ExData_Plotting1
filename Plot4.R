
#
# Read in electric power consumption data and plot a 2 x 2 grid of plots:
#   * Upper left - global activity power time series
#   * Upper right - voltage time series
#   * Lower left - three sub metering time series
#   * Lower right - global reactive power time series
#
# for the two days 2007-02-01 through 2007-02-02 to Plot4.png.
#

library(data.table)

# Read the data (note NA's are marked with the character "?"). Using fread()
# as it is much faster reading the large data set.
power.consumption <- fread("household_power_consumption.txt", na.strings = "?")

# Limit data set to 1/2/2007 - 2/2/2007
setkey(power.consumption, Date)
two.day <- power.consumption[c("1/2/2007", "2/2/2007"),]
rm(power.consumption)  # as this is a big structure, go ahead and remove

# The processing of NA strings in fread() resulted in the numeric columns being
# read in as character (bug #2660), so we have to coerce them back to numeric --
# but it is still much faster.
two.day[, `:=` (Global_active_power = as.numeric(Global_active_power),
                Global_reactive_power = as.numeric(Global_reactive_power),
                Voltage = as.numeric(Voltage),
                Global_intensity = as.numeric(Global_intensity),
                Sub_metering_1 = as.numeric(Sub_metering_1),
                Sub_metering_2 = as.numeric(Sub_metering_2))]

# Create a date/time column to help with the date-based plots. Note there is no
# time zone listed for the data (not on the UCI site either), so just letting
# it default to local time zone, which won't matter for the purpose of the
# assignment. Also note that POSIXlt is not supported with data.table, so using
# POSIXct.
setkey(two.day, Date, Time)
two.day[, DateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %T")]

# Create a 2 x 2 grid of plots as follows:
#   * Upper left - global activity power time series
#   * Upper right - voltage time series
#   * Lower left - three sub metering time series
#   * Lower right - global reactive power time series
#
# and save as Plot4.png that is 480 x 480 (default for "png()").
png("Plot4.png", type = "windows")

par(mfrow = c(2, 2))  # 2 x 2 plot

# Upper left global activity power time series
plot(two.day[, DateTime], two.day[, Global_active_power], type = "n",
     xlab = "", ylab = "Global Active Power")
lines(two.day[, DateTime], two.day[, Global_active_power])

# Upper right voltage time series
plot(two.day[, DateTime], two.day[, Voltage], type = "n",
     xlab = "datetime", ylab = "Voltage")
lines(two.day[, DateTime], two.day[, Voltage])

# Lower left three sub metering time series
plot(two.day[, DateTime], two.day[, Sub_metering_1], type = "n",
     xlab = "", ylab = "Energy sub metering")
lines(two.day[, DateTime], two.day[, Sub_metering_1], col = "black")
lines(two.day[, DateTime], two.day[, Sub_metering_2], col = "red")
lines(two.day[, DateTime], two.day[, Sub_metering_3], col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, bty = "n")

# Lower right global reactive power time series
plot(two.day[, DateTime], two.day[, Global_reactive_power], type = "n",
     xlab = "datetime", ylab = "Global_reactive_power")
lines(two.day[, DateTime], two.day[, Global_reactive_power])

dev.off()
