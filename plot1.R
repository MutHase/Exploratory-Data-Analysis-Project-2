if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method ="curl")
unzip("./data/NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#  Create Plot-Data : calculate total emmision of yeach year
DT1 <- aggregate(NEI[c("Emissions")], list(year = NEI$year), sum)

#  Create Plot
plot(DT1$year, DT1$Emissions, type = "l",xaxt="n",
     main = "Total Emissions from PM2.5 in the US",
     xlab = "Year", ylab = "Emissions")
axis(side=1, at=c(1999,2002,2005,2008))

dev.copy(png,file="plot1.png")  #Copy my plot to PNG file
dev.off()   ##close the PNG device

