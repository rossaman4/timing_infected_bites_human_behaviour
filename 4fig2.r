

# fig2.r

require(haven)


# read in human behaviour estimates (estimated in human_behaviour.do)
est_human<-read_dta("human_behaviour_ests.dta")

# read in biting estimates (estimated in  biting_getHrlyEsts_table2.r)
est_bites <- read.csv("biting_estd_hrly_rates.csv")


# hours for plotting
seqhr <- seq(1,12)
seqhrLabels <- c("6pm-7pm", "7pm-8pm", "8pm-9pm", "9pm-10pm", "10pm-11pm", "11pm-12am", "12am-1am", "1am-2am", "2am-3am", "3am-4am", "4am-5am","5am-6am")

# x-axis label positions for plotting
df.bar2 <- c( 1.4, 2.3, 3.3, 4.2, 5.1, 6.0, 7.0, 7.9, 8.9, 9.8, 10.8, 11.7)


# plots

#tiff(filename="fig2.tif", height=4, width=8, units="in", res=1200, pointsize=8, bg="white", compression="lzw")

par(oma=c(2,2,1,4))
par(mar=c(4,2,0,0))
par(las=2)

colBars <-c("gray27", "gray67", "gray96" )


par(mfrow=c(1,2))

# under school age plot
m<-t(est_human[,c("outdooru5","inoutofbedu5","inbedu5")]*100)
df.bar<-barplot(m, col=colBars)
axis(1, at=df.bar2, labels=seqhrLabels, las=2)
par(new=T)
plot(x=seq(1:12), est_bites$ang_in_mean, ylim=c(0, 1.5), yaxt="n", xaxt="n", xlab="", ylab="", type="n", col="red")
axis(4, at=seq(0, 1.5, 0.25), labels=NA)
lines(df.bar2, est_bites$ang_in_mean, col="blue", lwd=1.5)
lines(df.bar2, est_bites$ang_out_mean, col="blue", lty=3, lwd=1.5)
lines(df.bar2, est_bites$anf_in_mean, col="red", lwd=1.5)
lines(df.bar2, est_bites$anf_out_mean, col="red", lty=3, lwd=1.5)
mtext("percentage", side=2, line=2, las=0)



# school age and adult plot
m<-t(est_human[,c("outdooro5","inoutofbedo5","inbedo5")]*100)
df.bar<-barplot(m, col=colBars, yaxt="n")
axis(2, at=seq(0,100,20), labels=NA)
axis(1, at=df.bar, labels=seqhrLabels, las=2)
par(new=T)
plot(x=seq(1:12), est_bites$ang_in_mean, ylim=c(0, 1.5), yaxt="n", xaxt="n", xlab="", ylab="", type="n", col="red")
axis(4, at=seq(0, 1.5, 0.25))
lines(df.bar2, est_bites$ang_in_mean, col="blue", lwd=1.5)
lines(df.bar2, est_bites$ang_out_mean, col="blue", lty=3, lwd=1.5)
lines(df.bar2, est_bites$anf_in_mean, col="red", lwd=1.5)
lines(df.bar2, est_bites$anf_out_mean, col="red", lty=3, lwd=1.5)
mtext("bites per person per hour", side=4, line=3, las=0)



#dev.off()









