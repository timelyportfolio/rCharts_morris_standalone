require(rCharts)
require(reshape2)
require(PerformanceAnalytics)

data(edhec)

xtsMelt <- function(xtsData,metric){
  df <- data.frame(index(xtsData),coredata(xtsData),stringsAsFactors=FALSE)
  df.melt <- melt(df,id.vars=1)
  df.melt <- data.frame(df.melt,rep(metric,NROW(df.melt)))
  #little unnecessary housekeeping
  df.melt <- df.melt[,c(1,2,4,3)]
  colnames(df.melt) <- c("date","indexname","metric","value")
  df.melt$date <- as.Date(df.melt$date)
  return(df.melt)
}

#nice with Morris that we can do with melt or without
edhec.df <- data.frame(format( index(edhec), "%Y-%m-%d" ),
                       apply( 1 + coredata(edhec), MARGIN = 2, FUN = cumprod ),
                       stringsAsFactors = FALSE)
colnames(edhec.df) <- c("date",
                        gsub(x=colnames(edhec),
                             pattern=" ",
                             replacement="") )

m1a <- mPlot( x = "date",
              y = colnames(edhec.df)[2:NCOL(edhec.df)],
              data = edhec.df,
              type = "Line")
m1a$set ( pointSize = 0)
m1a$set ( hoverCallback = '#!function (index, options, content) {debugger;console.log(index);console.log(options);console.log(content);}!#')
m1a

edhec.melt <- xtsMelt(xtsData = cumprod(1+edhec), metric = "cumulreturn")
#remove troublesome . using modified method from this Stack Overflow
#http://stackoverflow.com/questions/2851015/convert-data-frame-columns-from-factors-to-characters
i <- sapply(edhec.melt, is.factor)
edhec.melt[i] <- lapply(edhec.melt[i], gsub, pattern="\\.", replacement="")

#get date in format that rickshaw likes
edhec.melt$date <- format(edhec.melt$date,"%Y-%m-%d")

m1b <- mPlot(value ~ date,
            group = "indexname",
            data = edhec.melt,
            type = "Line")
m1b$set ( pointSize = 0)
m1b