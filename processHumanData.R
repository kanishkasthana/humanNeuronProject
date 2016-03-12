
library("huge")

expressionData=read.csv("hg-annoHeaderCorrection.csv", header=TRUE, stringsAsFactors = FALSE)

print(dim(expressionData))

duplicatedGenesLogicalIndices=duplicated(expressionData$geneName)
duplicatedGeneNames= expressionData$geneName[duplicatedGenesLogicalIndices]
print("Duplicated Genes:")
print(duplicatedGeneNames)

expressionData=expressionData[!duplicatedGenesLogicalIndices,]
print(dim(expressionData))

#Getting Expression Values for all Genes across all single cells.
expressionValues=expressionData[,(2:ncol(expressionData))]

#Writing Genes for Later Use by the Java Program and possibly GO Term Analysis
write.table(expressionData$geneName,"geneNamesHuman.csv",quote=FALSE, row.names=FALSE, col.names=FALSE)

#Removing NA values. Hopefully this will resolve the problems with the graph. Right now I am seeing values only 
#along the diagnal. This should hopefully fix that problem.
expressionValues[is.na(expressionValues)]=0

print(dim(expressionValues))

expressionMatrix=as.matrix(t(expressionValues))
print(dim(expressionMatrix))

print("Everything except Graph model done")

graphModel = huge(expressionMatrix, method="glasso", lambda=c(0.055))
print("Done!")
#######################################################################################################

print(dim(graphModel$icov[[1]]))

#Reading output inverse covariance matrix for specified matrix. 
output=as.matrix(graphModel$icov[[1]])
colnames(output)=unlist(expressionData$geneName)

write.table(output,"graph_outputHumanAfterBugFix.csv", sep=",", quote=FALSE, row.names = FALSE)
