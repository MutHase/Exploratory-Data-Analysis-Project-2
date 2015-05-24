if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method ="curl")
unzip("./data/NEI_data.zip")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Select emissions from coal combustion-related sources from "Short.Name" colomn
Coal <- unique(grep("coal",SCC$Short.Name,ignore.case=TRUE,value=TRUE))
SCCC <- SCC[SCC$Short.Name %in% Coal,]["SCC"]


# Merge two data sets
DT <- merge(x=NEI, y=SCCC, by='SCC')
DT4 <- aggregate(DT[, 'Emissions'], by=list(DT$year), sum)
colnames(DT4) <- c('Year', 'Emissions')
head(DT4)

# In the United States, emissions from coal combustion-related sources through 1999-2008
# Create Plot
png("plot4.png",width=480,height=480)

ggplot(data=DT4, aes(x=Year, y=Emissions/1000)) + 
  geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
  ggtitle(expression('Coal combustion-related sources')) + 
  ylab(expression(paste('PM', ''[2.5], ' (kilotons)'))) + 
  geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=0.5, vjust=2)) + 
  theme(legend.position='none') + scale_colour_gradient(low='black', high='blue')

dev.off()
