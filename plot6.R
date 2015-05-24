if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method ="curl")
unzip("./data/NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Select the data which include the word "vehicles" in EI.Sector of SCC
VEH <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
SCCV <-SCC[SCC$EI.Sector %in% VEH, ]["SCC"]

# Data of "emissions from motor vehicle sources changed in Baltimore"
Bal <-NEI[NEI$SCC %in% SCCV$SCC & NEI$fips == "24510",]

# Data of "emissions from motor vehicle sources changed in Los Angeles"
LA <-NEI[NEI$SCC %in% SCCV$SCC & NEI$fips == "06037",]

# Bind Baltimore's data and Los Angeles's data, make sum of each year
DT6 <- rbind(Bal,LA)
PDT6 <-aggregate (Emissions ~ fips * year, data =DT6, FUN = sum ) 

# Replace name of list to name of city
PDT6$fips <- ifelse(PDT6$fips == "06037", "Los Angeles", "Baltimore")
names(PDT6)<-c("City","year","Emissions")

# Create Plot & PNG file
png("plot6.png",width=480,height=480)
qplot(year, Emissions, data=PDT6, geom="line",color=City) + ggtitle(expression("Motor Vehicle Emission " ~ PM[2.5] ~ " in Los Angeles and Baltimore")) + xlab("Year") + ylab(expression("Levels of" ~ PM[2.5] ~ " Emissions"))
dev.off()

