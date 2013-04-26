require(rCharts)
require(RColorBrewer)
require(PerformanceAnalytics)

data(managers)

#get columns 3 through 12 and 14 as statistics with similar ranges
pastats <- data.frame(table.Stats(managers[,c(1,8,9)])[c(3:12,14),],
                   stringsAsFactors = FALSE)

#make rownames a column
pastats <- data.frame(rownames( pastats ), pastats, row.names = NULL)
#add date to column names and remove . from column names to not confuse js
colnames( pastats ) <- c("metric",
                      gsub(x = colnames( pastats[-1] ),
                           pattern = "[.]",
                           replacement = "" ) )

#build the plot
m3 <- mPlot( x = "metric", 
             y = colnames( pastats )[-1],
             data = pastats,
             type = "Bar",
             width = 1000)

#not pretty colors but an example how we can specify
m3$set(barColors = brewer.pal(9, "PuBuGn")[c(7,6,3)])
#set to add % at end
m3$set(postUnits = "%")
#set to always show hover
m3$set(hideHover = 'auto')
m3