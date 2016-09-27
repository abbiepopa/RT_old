
###set the working directory to what you will be using
setwd("/Users/abbiepopa/Documents/UHR Tasks/Scripts")

###PRE-PROCESS FILES FOR IMPORT
###before processing a file you will need to open it with excel
###then, delete the first row, which will say something like:
###"C:\Documents and Settings\CABIL\Desktop\RT\RT-M-9999-1.edat2"
###finally save the file as a .csv using excel, now you are ready to import it into R!


###Move file to your working directory

###change file name in the following line to the participant you are processing

AMPRT<-read.csv("826.csv")


###selects columns
AMPcols<-c("Subject","Session","Procedure.Block.","AlienLeft.RT.Trial.","AlienRight.RT.Trial.","Procedure.Trial.")

###selects rows
AMProws<-which(AMPRT$Procedure.Block=="ExperimentBlock")

###makes the shorter dataframe
AMPRTShort<-AMPRT[AMProws,AMPcols]

###calculate mean for left and right
AMPLeft<-mean(AMPRTShort$AlienLeft.RT.Trial., na.rm=T)
AMPRight<-mean(AMPRTShort$AlienRight.RT.Trial., na.rm=T)

###calculate overall mean
AMPMeanRT<-mean(c(AMPLeft,AMPRight))

###find subsets for each SOA
AMPRT1200<-subset(AMPRTShort, Procedure.Trial.=="left1200" | Procedure.Trial.=="right1200")
AMPRT800<-subset(AMPRTShort, Procedure.Trial.=="left800" | Procedure.Trial.=="right800")
AMPRT400<-subset(AMPRTShort, Procedure.Trial.=="left400" | Procedure.Trial.=="right400")

###calculate means for each SOA
AMPMean1200<-(mean(AMPRT1200$AlienLeft.RT.Trial., na.rm=T)+mean(AMPRT1200$AlienRight.RT.Trial.,na.rm=T))/2
AMPMean800<-(mean(AMPRT800$AlienLeft.RT.Trial., na.rm=T)+mean(AMPRT800$AlienRight.RT.Trial.,na.rm=T))/2
AMPMean400<-(mean(AMPRT400$AlienLeft.RT.Trial., na.rm=T)+mean(AMPRT400$AlienRight.RT.Trial.,na.rm=T))/2

### make structure to export
AMPRTMat<-matrix(data=c(AMPRTShort$Subject[1], AMPRTShort$Subject[1], AMPRTShort$Subject[1], 1200, 800, 400, AMPMean1200, AMPMean800, AMPMean400), nrow=3, ncol=3)

colnames(AMPRTMat)<-c("studyid","SOA","mean")

###export processed data
write.csv(AMPRTMat, file = paste(AMPRTShort$Subject[1], "RT.csv", sep="_"))
