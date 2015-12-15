#Script Written by Kanishk Asthana
#Reading in Modified Data File
expressionData=read.csv("hg-annoHeaderCorrection.csv", header=TRUE, stringsAsFactors = FALSE)
#Getting Duplicated Gene Entries
duplicatedGenesLogicalIndices=duplicated(expressionData$geneName)
duplicatedGeneNames= expressionData$geneName[duplicatedGenesLogicalIndices]
print("Duplicated Genes:")
print(duplicatedGeneNames)
#I'm removing the duplicated genes from the analysis. This should not affect the analysis very much.
expressionData=expressionData[!duplicatedGenesLogicalIndices,]

#Getting Expression Values for all Genes across all single cells.
expressionValues=expressionData[,(2:ncol(expressionData))]

#Removing NA values
expressionValues[is.na(expressionValues)]=0
#Excluding Genes
logicalExpressedValues=(expressionValues>0)
totalCells=ncol(logicalExpressedValues)

genesToInclude=apply(logicalExpressedValues,1,function(row){
  value=(sum(row)/totalCells)*100
})

print(sum(genesToInclude>2))

graphOutput=read.csv("graph_outputHuman.csv", header=TRUE)
#This does not return any NA values. I think we are good, the analysis seems correct for now.
sum(graphOutput)
