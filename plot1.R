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
## png(file="plot1.png", h=504, w=504)

## Plot histogram with paramenters to modify font size, title, axis labels, bar color, axis sequences, and unprinted axes
png(file="plot1.png", h=480, w=480, bg = "transparent")
	par(ps=12)
	hist(household$Global_active_power,
		main="Global Active Power",
		xlab="Global Active Power (kilowatts)",
		ylab="Frequency",
		col="red",
		xlim=c(0, 7),
		ylim=c(0, 1200),
		xaxt="n",
		yaxt="n"
	)
	## Add axes to histogram with proper sequence
	axis(side=1, at=seq(0,6,2), labels=seq(0,6,2))
	axis(side=2, at=seq(0,1200,200), labels=seq(0,1200,200))
dev.off()
