expressionData=read.csv("hg-annoHeaderCorrection.csv", header=TRUE)

expressionValues=expressionData[,(2:ncol(expressionData))]

#Need to do this because Rizi dropped all values having TPM<1 in her analysis
expressionValues[expressionValues==0]=NA

inverseLogExpressionValues=2^expressionValues

#Converting NA values back to zero
inverseLogExpressionValues[is.na(inverseLogExpressionValues)]=0

#Checking if TPM was done correctly. If it was then the sums should be very similar, the distribution of Sums should not
#be very spread out.
ColumnSums=apply(inverseLogExpressionValues,2,sum)

print(length(ColumnSums))

hist(log10(ColumnSums),100)

RowSums=apply(inverseLogExpressionValues,1,sum)

print(length(RowSums))

hist(log10(RowSums),100)

#This is concerning none of these distributions are tightly distributed. Something is wrong here. I need to get the Raw reads
#from Rizi. But First I think I need to think of whether the correlation analysis will control for this or not. My guess it that it will
#Lets check this and see what next to do
