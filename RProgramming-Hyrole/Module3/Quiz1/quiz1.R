## check if directory not exists then create the directory
if (!file.exists('data')){
  dir.create('data')
}

## Q1
## download file from internet
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(file, destfile="./data/survey.csv")
list.files("./data") #list file after downloaded
dateDownloaded <- date()

## read data in the file
filePath <- "./data/survey.csv"
getDataTable <- read.table(filePath, sep=",", header = TRUE)

df = data.frame(getDataTable)
filterdf <- df[which(df$VAL==24),]  # select rows where VAL column is !NA and VAL=24
nrow(filterdf)

## Q2
## download file from internet
install.packages("xlsx")

# deactive java env var to working with rJava - for 64-bit
if (Sys.getenv("JAVA_HOME")!="")
  Sys.setenv(JAVA_HOME="")
library(rJava)
library(xlsx)
fileGas <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileGas, destfile="./data/gas.xlsx", mode="wb") #use mod='wb' to convert ascii into binary
list.files("./data") #list file after downloaded


library(xlsx)
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./data/gas.xlsx", sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex, header = TRUE)
#head(fileData)
sum(dat$Zip*dat$Ext,na.rm=T) 

## Q3 
install.packages("XML")
library(XML)
fileRes <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
fileURL <- sub('https', 'http', fileRes) # xml dosent support https, this will be used to convert to http
doc <- xmlTreeParse(fileURL, useInternal = TRUE)
rootNode <- xmlRoot(doc)
#xmlName(rootNode)
zip <- xpathSApply(rootNode, "//zipcode", xmlValue)
length(which(zip==21231))
#View(zip)


## Q5
## download file from internet
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(file, destfile="./data/housing.csv")
list.files("./data") #list file after downloaded
dateDownloaded <- date()

## read data in the file
library(data.table)
filePath <- "./data/housing.csv"
DT <- fread(filePath)
View(DT)
DT[,mean(pwgtp15),by=SEX] # calculte average of pwgtp15 and group by SEX

