if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method ="curl")
unzip("./data/NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Data of "emissions from motor vehicle sources changed in Baltimore City"
# Select the data which include the word "vehicles" in EI.Sector of SCC

VEH <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
SCCV <-SCC[SCC$EI.Sector %in% VEH, ]["SCC"]

NEIV<- NEI[NEI$SCC %in% SCCV$SCC & NEI$fips == "24510",]
DT5 <- aggregate(NEIV[c("Emissions")], list(year = NEIV$year), sum)

# Create Plot & PNG file
png("plot5.png",width=480,height=480)
ggplot(data=DT5, aes(x=year, y=Emissions)) + 
  geom_line(aes(group=1,col="red")) + geom_point(aes(size=2,col="red")) + 
  ggtitle(expression('PM2.5 Emission from Moter Vehicle in Baltimore City')) + 
  ylab(expression(paste('PM', ''[2.5], ' (tons)'))) + 
  geom_text(aes(label=round(Emissions,digits=2), size=2, hjust=0.5, vjust=2)) + 
  theme(legend.position='none') 
dev.off()

