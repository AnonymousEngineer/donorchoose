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
## load packakages
library('ggplot2') # plotting
library('dplyr') #datase manipulation

train <- read.csv(file="../data/train.csv", header=TRUE, sep=",", na.strings=c("","NA")) #read CSV
str(train)  #take a quick look at the data types in the different columns 

cols <- tolower(colnames(train))  #change column names to lowercase and store
colnames(train) <- cols   #store the lowercase column names
summary(train)  #take a look at summary of each column

head(train)
# dataset <- rename(dataset, NEW variable name = OLD variable name) #change variable name

sum(complete.cases(train)) #check how many entries have complete information
sum(!complete.cases(train)) #check how many entries have INCOMPLETE information
summary(complete.cases(train)) #summary of how many cases are complete with TRUE FALSE counts

## another way to count incomplete entries (this is more self explanatory)
z <- complete.cases(train) #store TRUE/FALSE in a vector
table(z)["TRUE"] #table of TRUE in Z
length(z[z==TRUE]) #(because NA indexing returns values)
sum(z) #10x faster than length(), careful as because NA indexing returns values
# sum(z, na.rm=NA) #returns inaccurate count! careful as because NA indexing returns values

# only 183 entries are complete! this is a problem! we will omit cabin info in the model
train %>% summarise_all(funs(sum(is.na(.)))) #display how many NA are present by variables
sapply(train, function(x)sum(is.na(x)|x=="")) #another way to count NA by columns
# age & cabin are the major culprits with lots of missing values