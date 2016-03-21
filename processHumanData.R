
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

allGeneNames=sapply(expressionData$geneName,toupper)
colnames(expressionMatrix)=allGeneNames
commonMouseAndHumanGenes=unlist(read.csv("commonMouseAndHumanGenes.txt",header=FALSE))
expressionMatrix=expressionMatrix[,commonMouseAndHumanGenes]
print(dim(expressionMatrix))

randomCells1=sample(1:nrow(expressionMatrix),size = 500,replace=FALSE)
head(randomCells1)
randomCells2=sample(1:nrow(expressionMatrix),size = 500,replace=FALSE)
head(randomCells2)
randomCellsFromExpressionMatrix1=expressionMatrix[randomCells1,]
dim(randomCellsFromExpressionMatrix1)
randomCellsFromExpressionMatrix2=expressionMatrix[randomCells2,]
dim(randomCellsFromExpressionMatrix2)

print("Everything except Graph model done")

graphModel1 = huge(randomCellsFromExpressionMatrix1, method="glasso", lambda=c(0.055))
graphModel2 = huge(randomCellsFromExpressionMatrix2, method="glasso", lambda=c(0.055))

print("Done!")
#######################################################################################################

print(dim(graphModel1$icov[[1]]))
print(dim(graphModel2$icov[[1]]))

output1=as.matrix(graphModel1$icov[[1]])
colnames(output1)=colnames(expressionMatrix)

output2=as.matrix(graphModel2$icov[[1]])
colnames(output2)=colnames(expressionMatrix)

#Getting Adjacency matrices and setting the diagnal to FALSE i.e. no self edges.
logicalOutput1=(output1!=0)
diag(logicalOutput1)=FALSE
logicalOutput2=(output2!=0)
diag(logicalOutput2)=FALSE
pdf("Edge_Distribution_Statistics.pdf")
edgeDistribution1=apply(logicalOutput1,2,sum)
hist(edgeDistribution1,100, main = "Edge Distribution for First Random Sample of 500 Cells")
edgeDistribution2=apply(logicalOutput2,2,sum)
hist(edgeDistribution2,100, main = "Edge Distribution for Second Random Sample of 500 Cells")

#Getting Intersection of both outputs
intersectofOutputs=((logicalOutput1+logicalOutput2)>1)
diag(intersectofOutputs)=FALSE

intersectEdgeDistribution=apply(intersectofOutputs,2,sum)
hist(intersectEdgeDistribution,100, main = "Edge Distribution for Intersect of Random Samples")
dev.off()

sink("sparsityValues.txt")
print("Sparsity for Random Sample 1:")
sparsity1=sum(logicalOutput1)/(nrow(logicalOutput1)*ncol(logicalOutput1))
print(sparsity1)
print("Sparsity for Random Sample 2:")
sparsity2=sum(logicalOutput2)/(nrow(logicalOutput2)*ncol(logicalOutput2))
print(sparsity2)
print("Sparsity for Intersect of Random Samples:")
intersectSparsity=sum(intersectofOutputs)/(nrow(intersectofOutputs)*ncol(intersectofOutputs))
print(intersectSparsity)
