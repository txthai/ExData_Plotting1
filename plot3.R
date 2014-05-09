## Read text file into table, subset data, and convert column type
household <- read.table("household_power_consumption.txt", header=TRUE, sep=";", stringsAsFactors=FALSE)
household <- household[household[,1] == "1/2/2007" | household[,1] == "2/2/2007",]
household[,c(3:9)] <- sapply(household[,c(3:9)], as.numeric)

## Confirm the column type conversion using the following two commands
## sapply(household, mode)
## sapply(household, class)

## Create temporary vector and store converted and concatenate data time columns
temp <- seq(as.POSIXlt("1970-01-01"), by=("+1 hour"), length.out=length(household[,1]))
for(i in 1:length(temp)) {
	temp[i] <- strptime(paste(household[i,1], household[i,2]), format="%d/%m/%Y %H:%M:%S")
}

## Bind temporary date vector to household data frame column 1 and give decriptive column name
household <- cbind(temp, household)
colnames(household)[1] <- "datetime"

## To compare to reference
## png(file="plot3.png", h=504, w=504)

## Save as plot3.png
png(file="plot3.png", h=480, w=480, bg = "transparent")
	par(ps=12)
	plot(household$datetime,
		household$Sub_metering_1,
		type="l",
		xlab="",
		ylab="Energy sub metering"
	)
	lines(household$datetime,
		household$Sub_metering_2,
		col="red"
	)
	lines(household$datetime,
		household$Sub_metering_3,
		col="blue"
	)
	legend("topright",
		lty=c(1,1),
		col=c("black", "red", "blue"),
		legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
	)
dev.off()
