head(mtcars)

cars=mtcars

norm_cars=apply(mtcars,2,function(column){

  colsum=sum(column)
  
  return(column/colsum)
  
})

print(cor(cars))
print(cor(norm_cars))
print("The difference between these matrices is minimal, they are essentially identical:")
print(sum(cor(cars)-cor(norm_cars)))

lcars=cor(log(cars))
lncars=cor(log(norm_cars))

lcars[is.na(lcars)]=0
lncars[is.na(lncars)]=0

print("Similar Story for the log of correlations here:")
print(sum(lcars)-sum(lncars))

#So by this logic taking the log of the data should have some noticiable effect. Perhaps I should take the log of the data
#But it does not make sense