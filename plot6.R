source("loadData.R")
library(ggplot2)
vehicleSubset <- subset(SCC,Data.Category=='Onroad')$SCC
vehicleData <- subset(NEI,NEI$SCC %in% vehicleSubset)
vehicleDataBaltimore <- subset(vehicleData,vehicleData$fips=="24510")
vehicleDataLA <- subset(vehicleData,vehicleData$fips=="06037")
vehicleEmissionDataBalt <-  aggregate(x=vehicleDataBaltimore$Emissions,by=list(year=vehicleDataBaltimore$year),FUN=sum)
vehicleEmissionDataLA <-  aggregate(x=vehicleDataLA$Emissions,by=list(year=vehicleDataLA$year),FUN=sum)

#processing Data
vehicleEmissionDataBalt$Location <-  "Baltimore"
BaltStart <- vehicleEmissionDataBalt[vehicleEmissionDataBalt$year==1999,]$x
vehicleEmissionDataBalt$Difference <- ((vehicleEmissionDataBalt$x - BaltStart)/ BaltStart)*100

vehicleEmissionDataLA$Location <-  "Los Angeles"
LAStart <- vehicleEmissionDataLA[vehicleEmissionDataLA$year==1999,]$x
vehicleEmissionDataLA$Difference <- ((vehicleEmissionDataLA$x - LAStart)/ LAStart)*100

mainData <- rbind(vehicleEmissionDataBalt, vehicleEmissionDataLA)


png("plot6.png" , width = 900, height = 800)
g <- ggplot(mainData, aes(y=Difference, x=year, group=Location, color=Location))
g + labs( x="Year", y="Total emisions change Percentage", title=expression("Vehicle Related Emissions Change in Baltimore & Los Angeles from 1999"))+ geom_point(size = 3) + geom_line() + theme_bw()
dev.off()