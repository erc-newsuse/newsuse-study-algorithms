library(arrow)
library(moments)
library(Rbeast)
library(dplyr)
library(lubridate)
library(tidyr)
set.seed(1892034)


#read in data
timeseries<-read_parquet("dataset.parquet")

#remove non-date parts from timestamp, then generate a set of year/week variables that refer to calender year and week.
timeseries$date<-as.Date(timeseries$timestamp)
timeseries$isoweek<-isoweek(timeseries$date)
timeseries$isoyear<-isoyear(timeseries$date)


#generate 1k random numbers to use as seeds. Not strictly necessary, but helps keep things simple in case things need to be rerun
seeds<-runif(100, min=1000000, max=10000000)


#generate by outlet means for mu and link, no longer used at present.
Quality_info<-timeseries %>%
  group_by(name) %>%
  summarise(
    mean_mu=mean(reactions_mu,na.rm=TRUE),
    mean_link=mean(reactions_link,na.rm=TRUE)
  )

#and append those weekly means to the original dataset, then use them to generate a normalized mu and mean column. At present, we prefer a log option.

timeseries<-timeseries %>%
  left_join(Quality_info)

timeseries<-timeseries %>%
  mutate(
    normalized_mu=reactions_mu/mean_mu,
    normalized_link=reactions_link/mean_link
  )



#Generate a weekly dataset, note, start_date here effectively converts the year/week calender
#variables back into the start of the calender week as one time series, so we no longer need isoweek/isoyear after this step.

ByWeek <- timeseries %>%
  group_by(isoyear,isoweek, name, quality) %>%
  summarise(
    start_date=floor_date(min(date)-1,"weeks")+1,
    reactions_mu=mean(reactions_mu),
    reactions_rel_mu=mean(reactions_rel_mu),
    reactions_rel_cv=mean(reactions_rel_cv),
    reactions_cv=mean(reactions_cv),
    reactions_link=mean(reactions_link),
    normal_mu=mean(normalized_mu),
    normal_link=mean(normalized_link))

#And then group those weekly outlet averages into a weekly overall average.

WeeklyAll<-ByWeek %>%
  group_by(start_date) %>%
  summarise(
    reactions_mu=mean(reactions_mu),
    reactions_rel_mu=mean(reactions_rel_mu),
    reactions_rel_cv=mean(reactions_rel_cv),
    reactions_cv=mean(reactions_cv),
    reactions_link=mean(reactions_link),
    normal_mu=mean(normal_mu),
    normal_link=mean(normal_link)
  )


#and take the logs of the final mu variabels
WeeklyAll<-WeeklyAll %>%
  mutate(
    log_mu=log(reactions_mu),
    log_rel_mu=log(reactions_rel_mu)
  )



#Next we set the BEAST parameters. Each list should be initialized, as we need variables in both metadata and prior
#Metadata sets our timescale correctly and notes that we have neither seasonal nor outleir components in this data, given the weeekly chunking.
#within prior, we set the minimum number of trend changepoints to 0, the maximum to 30 (more than detected in any run)
#and also a minimum distance of 13 weeks between changepoints
#Nothing is set within mcmc yet, but we'll be using mcmc$seed later and the options are here for ease of use

metadata                  = list()
metadata$isRegularOrdered = FALSE
metadata$whichDimIsTime   = 1
metadata$startTime        = as.Date("2016/01/04")
metadata$deltaTime        = 1/52
metadata$period           = NaN
metadata$omissionValue    = NaN
metadata$maxMissingRateAllowed = 0.7500
metadata$deseasonalize    = FALSE
metadata$detrend          = FALSE
metadata$hasOutlier       =TRUE

prior = list()
#prior$seasonMinOrder = 1 #min harmonic order allowed to fit seasonal cmpnt
#prior$seasonMaxOrder = 5 #max harmonic order allowed to fit seasonal cmpnt
#prior$seasonMinKnotNum = 0 #min number of changepnts in seasonal cmpnt
#prior$seasonMaxKnotNum = 10 #max number of changepnts in seasonal cmpnt
#prior$seasonMinSepDist = 10 #min inter-chngpts separation for seasonal cmpnt
prior$trendMinOrder = 0 #min polynomial order allowed to fit trend cmpnt
prior$trendMaxOrder = 1 #max polynomial order allowed to fit trend cmpnt
prior$trendMinKnotNum = 0 #min number of changepnts in trend cmpnt
prior$trendMaxKnotNum = 30  #max number of changepnts in trend cmpnt
prior$trendMinSepDist = 13 #min inter-chngpts separation for trend cmpnt
#prior$precValue = 10.0 #Initial value of the precision parameter (no
#prior$precPriorType = 'uniform' # Possible values: const, uniform, and componentwis

mcmc = list()
#mcmc$seed = 9543434# an arbitray seed for random number generator
#mcmc$samples = 3000 # samples collected per chain
#mcmc$thinningFactor = 3 # take every 3rd sample and discard others
#mcmc$burnin = 150 # discard the initial 150 samples per chain
#mcmc$chainNumber = 3 # number of chains
#mcmc$maxMoveStepSize = 4 # max random jump step when proposing new chngpts
#mcmc$trendResamplingOrderProb = 0.100 # prob of choosing to resample polynomial order
#mcmc$seasonResamplingOrderProb = 0.100 # prob of choosing to resample harmonic order
#mcmc$credIntervalAlphaLevel = 0.950 # the significance level for credible interval


#generate lists where we'll be storing beasts, reactionsmu is just reactions, beasts_cv is just the coefficient of variation and beasts_both is both as one model
#The rel versions use the relativized data.

beastsreactionsmu=list()
beasts_cv=list()
beasts_both=list()
beastsrelmu=list()
beasts_relcv=list()
beasts_relboth=list()

#Next run our first beast model. This reruns a thousand times, storing each output in beastsreactionsmu.
#beasts123 is the beasts call, it's run on WeeklyAll here, excluding the first and last rows, and using the 9th column (log_mu).
#First and last rows to be excluded, because data collection didn't start or stop exactly on a calender week, so they cover fewer days.

for(i in 1:10L){
  mcmc$seed = seeds[i]
  X = beast123(WeeklyAll[2:(nrow(WeeklyAll)-1),9],
                          metadata= metadata, mcmc=mcmc, prior=prior, season="none")
  beastsreactionsmu[[i]]<-X
}

#Generate a dataframe to extract the changepoints and name columns appropriately. ID refers to the run # and shoudl be 1-10L, date is the detected changepoint date
#formatted as a fraction of a year. Prob is the probability with which a changepoint was detected at that date.
changepointsmu<-data.frame(matrix(NA, nrow = 30, ncol = 3))
changepointsmu<-changepointsmu %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )
changepointsmu[,1]<-1
changepointsmu[,2]<-beastsreactionsmu[[1]]$trend$cp
changepointsmu[,3]<-beastsreactionsmu[[1]]$trend$cpPr

#Put the first run's data there, for convenience.

#create an empty dataframe to match with the former, then store each changepoint there from each run.

X<-data.frame(matrix(NA, nrow = 30, ncol = 3))
X<-X %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )

for(i in 2:10L){
  X[,1]<-i
  X[,2]<-beastsreactionsmu[[i]]$trend$cp
  X[,3]<-beastsreactionsmu[[i]]$trend$cpPr
  changepointsmu<-rbind(changepointsmu,X)
}


#Each run detected up to 30 changepoints, but most should have gotten far less. We remove the corresponding empty rows in the dataframe, then convert
#dates back into calender dates, then further convert each to the first day of the week, to match the dates inputted into the model.
#finally, write it all up as a csv.

changepointsmu2<-changepointsmu[complete.cases(changepointsmu),]
changepointsmu2$calendardate<-as.Date(date_decimal(changepointsmu2$date))
changepointsmu2$start_date<-floor_date(changepointsmu2$calendardate, "weeks", week_start = 1)

write.csv(changepointsmu2,file="10L runs all data as one mu.csv",row.names = FALSE)





#Next run our first beast model. This reruns a thousand times, storing each output in beastsreactionsmu.
#beasts123 is the beasts call, it's run on WeeklyAll here, excluding the first and last rows, and using the 5th column (variation)
#First and last rows to be excluded, because data collection didn't start or stop exactly on a calender week, so they cover fewer days.

for(i in 1:10L){
  mcmc$seed = seeds[i]
  X = beast123(WeeklyAll[2:(nrow(WeeklyAll)-1),5],
               metadata= metadata, mcmc=mcmc, prior=prior, season="none")
  beasts_cv[[i]]<-X
}

#Generate a dataframe to extract the changepoints and name columns appropriately. ID refers to the run # and shoudl be 1-10L, date is the detected changepoint date
#formatted as a fraction of a year. Prob is the probability with which a changepoint was detected at that date.
changepointscv<-data.frame(matrix(NA, nrow = 30, ncol = 3))
changepointscv<-changepointscv %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )
changepointscv[,1]<-1
changepointscv[,2]<-beasts_cv[[1]]$trend$cp
changepointscv[,3]<-beasts_cv[[1]]$trend$cpPr

#Put the first run's data there, for convenience.

#create an empty dataframe to match with the former, then store each changepoint there from each run.

X<-data.frame(matrix(NA, nrow = 30, ncol = 3))
X<-X %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )

for(i in 2:10L){
  X[,1]<-i
  X[,2]<-beasts_cv[[i]]$trend$cp
  X[,3]<-beasts_cv[[i]]$trend$cpPr
  changepointscv<-rbind(changepointscv,X)
}


#Each run detected up to 30 changepoints, but most should have gotten far less. We remove the corresponding empty rows in the dataframe, then convert
#dates back into calender dates, then further convert each to the first day of the week, to match the dates inputted into the model.
#finally, write it all up as a csv.

changepointscv2<-changepointscv[complete.cases(changepointscv),]
changepointscv2$calendardate<-as.Date(date_decimal(changepointscv2$date))
changepointscv2$start_date<-floor_date(changepointscv2$calendardate, "weeks", week_start = 1)

write.csv(changepointscv2,file="10L runs all data as one cv.csv",row.names = FALSE)


#Next run our first beast model. This reruns a thousand times, storing each output in beastsreactionsmu.
#beasts123 is the beasts call, it's run on WeeklyAll here, excluding the first and last rows, and using the 5th and 9th columns together
#First and last rows to be excluded, because data collection didn't start or stop exactly on a calender week, so they cover fewer days.

for(i in 1:10L){
  mcmc$seed = seeds[i]
#   X = beast123(WeeklyAll[2:(nrow(WeeklyAll)-1),c(2,3)],
  X = beast123(Y,
               metadata= metadata, mcmc=mcmc, prior=prior, season="none")
  beasts_both[[i]]<-X
}

#Generate a dataframe to extract the changepoints and name columns appropriately. ID refers to the run # and shoudl be 1-10L, date is the detected changepoint date
#formatted as a fraction of a year. Prob is the probability with which a changepoint was detected at that date.
changepointsboth<-data.frame(matrix(NA, nrow = 30, ncol = 3))
changepointsboth<-changepointsboth %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )

changepointsboth[,1]<-1
changepointsboth[,2]<-beasts_both[[1]]$trend$cp
changepointsboth[,3]<-beasts_both[[1]]$trend$cpPr

#Put the first run's data there, for convenience.

#create an empty dataframe to match with the former, then store each changepoint there from each run.

X<-data.frame(matrix(NA, nrow = 30, ncol = 3))
X<-X %>%
  rename(
    id=X1,
    date=X2,
    prob=X3
  )

for(i in 2:10L){
  X[,1]<-i
  X[,2]<-beasts_both[[i]]$trend$cp
  X[,3]<-beasts_both[[i]]$trend$cpPr
  changepointsboth<-rbind(changepointsboth,X)
}


#Each run detected up to 30 changepoints, but most should have gotten far less. We remove the corresponding empty rows in the dataframe, then convert
#dates back into calender dates, then further convert each to the first day of the week, to match the dates inputted into the model.
#finally, write it all up as a csv.

changepointsboth2<-changepointsboth[complete.cases(changepointsboth),]
changepointsboth2$calendardate<-as.Date(date_decimal(changepointsboth2$date))
changepointsboth2$start_date<-floor_date(changepointsboth2$calendardate, "weeks", week_start = 1)

write.csv(changepointsboth2,file="10L runs all data as one mu.csv",row.names = FALSE)
