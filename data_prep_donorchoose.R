#########################################################################################################################
#########################################################################################################################

## R script to prepare the data of DonorChoose competition for modeling

# https://www.kaggle.com/c/donorschoose-application-screening/
#########################################################################################################################
#########################################################################################################################

# ## set working directory to current directory
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

#########################################################################################################################
## load the necessary packages
library('ggplot2') # plotting
library('dplyr') #datase manipulation

passenger <- read.csv(file="../data/train.csv", header=TRUE, sep=",", na.strings=c("","NA")) #read CSV
str(passenger)  #take a quick look at the data types in the different columns 

cols <- tolower(colnames(passenger))  #change column names to lowercase and store
colnames(passenger) <- cols   #store the lowercase column names
summary(passenger)  #take a look at summary of each column

head(passenger)
# dataset <- rename(dataset, NEW variable name = OLD variable name) #change variable name

sum(complete.cases(passenger)) #check how many entries have complete information
sum(!complete.cases(passenger)) #check how many entries have INCOMPLETE information
summary(complete.cases(passenger)) #summary of how many cases are complete with TRUE FALSE counts

## another way to count incomplete entries (this is more self explanatory)
z <- complete.cases(passenger) #store TRUE/FALSE in a vector
table(z)["TRUE"] #table of TRUE in Z
length(z[z==TRUE]) #(because NA indexing returns values)
sum(z) #10x faster than length(), careful as because NA indexing returns values
# sum(z, na.rm=NA) #returns inaccurate count! careful as because NA indexing returns values

# only 183 entries are complete! this is a problem! we will omit cabin info in the model
passenger %>% summarise_all(funs(sum(is.na(.)))) #display how many NA are present by variables
sapply(passenger, function(x)sum(is.na(x)|x=="")) #another way to count NA by columns
# age & cabin are the major culprits with lots of missing values