
#
# Read in electric power consumption data and plot a time series of global
# active power for the two days 2007-02-01 through 2007-02-02 to plot2.png.
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

# Create a time series of the global active power and save as plot2.png that is
# 480 x 480 (default for "png()")
#
# Note: it would be possible to make the PNG background opaque white (default)
# or transparent as in the source files for the README.md. I chose opaque white
# as that produces a result that looks like the results of the README.md. Either
# is okay per the discussion forum
# (https://class.coursera.org/exdata-007/forum/thread?thread_id=10)
#
# Note: slight rendering differences can occur due to OS differences in
# rendering. This can be noticed as a very slight difference in the color red,
# for example, very slight variation in text size, slight differences due to
# different anti-aliasing, etc. Per the discussion forums, these differences
# are not expected to be accounted for and so I am not trying to adjust for those
# (https://class.coursera.org/exdata-007/forum/thread?thread_id=41)
png("plot2.png", type = "windows")
plot(two.day[, DateTime], two.day[, Global_active_power], type = "n",
     xlab = "", ylab = "Global Active Power (kilowatts)")
lines(two.day[, DateTime], two.day[, Global_active_power])
dev.off()
