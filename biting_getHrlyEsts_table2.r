
rm(list=ls())


require(haven)
require(lme4)
require(dplyr)


# set working directory
#setwd("..")



# estimate biting rates 

biting <- read_dta("biting_data.dta")



# Run biting rate estimates in glmm in R with crossed random effects for household and day

getEstPerHr <- function(dataX, nmosq) {
  resultStore <- array(-9, dim=c(n_hours,n_cols))
  for (i in 1:n_hours) {
      print(i)
      m1 <- glmer( nmosq ~ relevel(as.factor(formrow), ref=i) +  (1 | houseid) + ( 1 | day), data=dataX, family="poisson",  control = glmerControl(optimizer="bobyqa") )
      out1 <- summary(m1)$coeff
      logm <- out1[1,1]
      logse <- out1[1,2]
      meanb <- exp(logm)
      lb <- exp( logm - 1.96*logse)
      ub <- exp( logm + 1.96*logse)
      resultStore[i,]<-c(logm, logse, meanb, lb, ub)
  }
return(resultStore)
}


n_hours = 12
n_cols = 5

# datasets for indoors and outdoors
temp_in <- biting[biting$location_code==1,]
temp_out <- biting[biting$location_code==0,]

# get estimates
ang_out <- getEstPerHr(temp_out, temp_out$Angambiae)
ang_in <- getEstPerHr(temp_in, temp_in$Angambiae)

anf_out <- getEstPerHr(temp_out, temp_out$Anfunestus)
anf_in <- getEstPerHr(temp_in, temp_in$Anfunestus)

tot_out <- getEstPerHr(temp_out, temp_out$total)
tot_in <- getEstPerHr(temp_in, temp_in$total)




# combine results into a dataset

results_all <- cbind( ang_out, ang_in, anf_out, anf_in, tot_out, tot_in )
colnames(results_all) <- c("ang_out_logm", "ang_out_logse", "ang_out_mean", "ang_out_lb", "ang_out_ub", 
                           "ang_in_logm", "ang_in_logse", "ang_in_mean", "ang_in_lb", "ang_in_ub", 
                           "anf_out_logm", "anf_out_logse", "anf_out_mean", "anf_out_lb", "anf_out_ub", 
                           "anf_in_logm", "anf_in_logse", "anf_in_mean", "anf_in_lb", "anf_in_ub",
                           "tot_out_logm", "tot_out_logse", "tot_out_mean", "tot_out_lb", "tot_out_ub", 
                           "tot_in_logm", "tot_in_logse", "tot_in_mean", "tot_in_lb", "tot_in_ub")

results_all <- data.frame(results_all)
                           

# print out results for table 2

# indoor An Arabiensis
results_all[,c("ang_in_mean", "ang_in_lb", "ang_in_ub")]

# indoor An funestus
results_all[,c("anf_in_mean", "anf_in_lb", "anf_in_ub")]

# outdoor An arabiensis
results_all[,c("ang_out_mean", "ang_out_lb", "ang_out_ub")]

# outdoor An funestus
results_all[,c("anf_out_mean", "anf_out_lb", "anf_out_ub")]



write.csv(results_all, "biting_estd_hrly_rates.csv")












      


