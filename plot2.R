if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method ="curl")
unzip("./data/NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#  Create Plot-Data

DT <- subset(NEI, fips == "24510")
DT2 <- aggregate(DT[c("Emissions")], list(year = DT$year), sum)
png('plot2.png', width=480, height=480)
plot(DT2$year, DT2$Emissions, type = "l",xaxt="n",
     main = "Total Emissions from PM2.5 in Baltimore City",
     xlab = "Year", ylab = "Emissions")
axis(side=1, at=c(1999,2002,2005,2008))
dev.off()   ##close the PNG device

