print("R started")

library('ggplot2')

library(grid)

# Put full path here
data <- read.csv("/Users/tatemclallen/Desktop/BIOL230-info/RProject/OrganizedData.csv",header=TRUE)

# Make dataframe using CSV data and makes another DF with just transcription data by removing -1 
# values that indicate no data available for that gene

geneNames=data$GeneName
GCcontents=data$GCcontent
purContents=data$Purinecontent
lengths=data$Length
chroms=data$Chromosome
transLevels=data$TransLevels

dataInFrame <- data.frame(
  geneNames,
  GCcontents,
  purContents,
  lengths,
  chroms,
  transLevels
)

transData <- dataInFrame[!grepl(-1, dataInFrame$transLevels),]


# print(dataInFrame)


# Run and print T tests
tResultsGC <- oneway.test(GCcontents ~ chroms, data = dataInFrame)
tResultsPur <- oneway.test(purContents ~ chroms, data = dataInFrame)
tResultsLen <- oneway.test(lengths ~ chroms, data = dataInFrame)
tResultsTrans <- oneway.test(transLevels ~ chroms, data = transData)

print(tResultsGC)
print(tResultsPur)
print(tResultsLen)
print(tResultsTrans)

# GC get average, SD, and make plot

GCaverages <- aggregate(GCcontents ~ chroms, dataInFrame, mean)
GCdevs <- aggregate(GCcontents ~ chroms, dataInFrame, sd)
GCaverages$SDs <- GCdevs$GCcontents

#print(GCaverages)
#print(GCdevs)

GCplot <- ggplot(data=GCaverages, aes(x=chroms, y=GCcontents)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=GCcontents-SDs, ymax=GCcontents+SDs), width=.2, position=position_dodge(.9)) +
  expand_limits(y=c(0, 1))
#GCplot

# Purine get average, SD, and make plot

purAverages <- aggregate(purContents ~ chroms, dataInFrame, mean)
purDevs <- aggregate(purContents ~ chroms, dataInFrame, sd)
purAverages$SDs <- purDevs$purContents

purPlot <- ggplot(data=purAverages, aes(x=chroms, y=purContents)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=purContents-SDs, ymax=purContents+SDs), width=.2, position=position_dodge(.9)) +
  expand_limits(y=c(0, 1))
#purPlot


# Length get average, SD, and make plot

lenAverages <- aggregate(lengths ~ chroms, dataInFrame, mean)
lenDevs <- aggregate(lengths ~ chroms, dataInFrame, sd)
lenAverages$SDs <- lenDevs$lengths

lenPlot <- ggplot(data=lenAverages, aes(x=chroms, y=lengths)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=lengths-SDs, ymax=lengths+SDs), width=.2, position=position_dodge(.9)) 
#lenPlot




# Transscription data get average, SD, and make plot

# print(transData)
transAverages <- aggregate(transLevels ~ chroms, transData, mean)
transDevs <- aggregate(transLevels ~ chroms, dataInFrame, sd)
transAverages$SDs <- transDevs$transLevels

transPlot <- ggplot(data=transAverages, aes(x=chroms, y=transLevels)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=transLevels-SDs, ymax=transLevels+SDs), width=.2, position=position_dodge(.9)) 
#transPlot


# Scatterplot of GC content and purine content

scatterOne <- ggplot(dataInFrame, aes(x=GCcontents, y=purContents)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
#scatterOne


# Scatterplot of length and GC content levels

scatterTwo <- ggplot(dataInFrame, aes(x=GCcontents, y=lengths)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
#scatterTwo


# Print all created charts and save to pdf

pdf(file = "/Users/tatemclallen/Desktop/BIOL230-info/Rproject/Rplots.pdf", width = 9, height = 6) 

pushViewport(viewport(layout = grid.layout(2, 3)))
print(GCplot, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(purPlot, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(lenPlot, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(transPlot, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print(scatterOne, vp = viewport(layout.pos.row = 1, layout.pos.col = 3))
print(scatterTwo, vp = viewport(layout.pos.row = 2, layout.pos.col = 3))

dev.off()



