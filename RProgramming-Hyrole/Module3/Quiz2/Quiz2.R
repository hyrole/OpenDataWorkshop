## Q1
library(httr)
library(httpuv)
oauth_endpoints("github")
myapp <- oauth_app("github", "6251694d38cfb0b868a8", "739960805d002f764e366db6bf2b8974a8490c13")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
content(req)
BROWSE("https://api.github.com/users/jtleek/repos",authenticate("d921a531f0af66a41648e4fd4b610d847dcdd5aa","x-oauth-basic","basic"))


## Q2
## download file from internet
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
acs <- download.file(file, destfile="./data/acs.csv")

library(data.table)
filePath <- "./data/acs.csv"
DT <- fread(filePath)
View(DT)



