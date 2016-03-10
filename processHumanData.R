library("huge")
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

#Writing Genes for Later Use by the Java Program and possibly GO Term Analysis
write.table(expressionData$geneName,"geneNamesHuman.csv",quote=FALSE, row.names=FALSE, col.names=FALSE)

#Removing NA values. Hopefully this will resolve the problems with the graph. Right now I am seeing values only 
#along the diagnal. This should hopefully fix that problem.
expressionValues[is.na(expressionValues)]=0

#Randomly sampling about 500 rows from the matrix to check what kind of sparsity I get.
########################################################################################################
randomRows=sample(1:nrow(expressionValues),500,replace = FALSE)
expressionValues=expressionValues[randomRows,]
########################################################################################################

expressionMatrix=as.matrix(t(expressionValues))
print(dim(expressionValues))
print("Everything except Graph model done")
#No need to do a Log transform and calculate RPM. Rizi already has done all this stuff. Moreover she used TPM

#Trying the output for a lot of lambdas. This should give me a sparcity vector in the output.
#######################################################################################################
lambdas=seq(0.01,1,by=0.01)
graphModel = huge(expressionMatrix, method="glasso", lambda=lambdas)
print("Done!")
#######################################################################################################

#Plotting relationship between sparsity and lambda
pdf("HumanSparcityGraph.pdf")
plot(lambdas,graphModel$sparsity,type='l',main="Plot of Lambda cutoff vs Sparcity of Human graph",xlab="Lambda", ylab = "Sparsity of output")
dev.off()
#Reading output inverse covariance matrix for specified matrix. 
#output=as.matrix(graphModel$icov[[1]])
#colnames(output)=unlist(expressionData$geneName)

#write.table(output,"graph_outputHuman.csv", sep=",", quote=FALSE, row.names = FALSE)

#Converting to Zero Based Indexing for Java.
#rownames(output)=as.character(0:(nrow(expressionData)-1))

#write.table(output,"graph_outputHumanForJava.csv", sep=",", quote=FALSE)
