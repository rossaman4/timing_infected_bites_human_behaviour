

# 4fig4.r


rm(list=ls())

require(plotrix)
require(haven)


exposure<-read_dta("fig4_ests.dta")
colnames(exposure)<-c("outu6", "inbedinnetu6", "inbednonetu6","inoutofbedu6", "outo6", "inbedinneto6","inbednoneto6","inoutofbedo6")



# make stacked variables

# under school-age
stack_exp_nonets0_u6 <- exposure$outu6 + exposure$inoutofbedu6 + exposure$inbedinnetu6 + exposure$inbednonetu6
stack_exp_innets0_u6 <- exposure$outu6 + exposure$inoutofbedu6 + exposure$inbedinnetu6 
stack_exp_inawake0_u6 <- exposure$outu6 + exposure$inoutofbedu6


# over school-age and adults
stack_exp_nonets1_o6 <- exposure$outo6 + exposure$inoutofbedo6 + exposure$inbedinneto6 + exposure$inbednoneto6
stack_exp_innets1_o6 <- exposure$outo6 + exposure$inoutofbedo6 + exposure$inbedinneto6 
stack_exp_inawake1_o6 <- exposure$outo6 + exposure$inoutofbedo6



# variables for x-axis
seqhr <-seq(1,12)
seqhrLabels <-c("6PM-7PM", "7PM-8PM","8PM-9PM","9PM-10PM","10PM-11PM","11PM-12AM","12AM-1AM","1AM-2AM", "2AM-3AM", "3AM-4AM", "4AM-5AM", "5AM-6AM")
zeros <- rep(0,length(seqhr))





# plot

*tiff(filename="Fig4.tif", height=4, width=8, units="in", res=1200, pointsize=8, bg="white", compression="lzw")

par(mfrow=c(1,2))

par(oma=c(1.5,4,0,0))
par(mar=c(4,0,2,1))
# where labels are placed (axis title, axis labels, axis line)
par(mgp=c(2.8,0.4,0))   
# text size
par(cex.lab=1, cex.axis=1)
# length of tick marks
par(tcl=-0.2)


plot(seqhr, stack_exp_nonets0_u6, type="l", las=1, ylim=c(0, 0.006), frame=FALSE, xaxt="n",xlab="", ylab="infectious bites per hour x proportion in location", xlim=c(1,15))
axis(1,at=c(1,2,3,4,5,6,7,8,9,10,11,12), labels=seqhrLabels, las=2)
polygon(c(seqhr, rev(seqhr)), c(stack_exp_innets0_u6, rev(stack_exp_inawake0_u6)), col="lightsteelblue1")
polygon(c(seqhr, rev(seqhr)), c(stack_exp_inawake0_u6, rev(exposure$outu6)), col="cornflowerblue")
polygon(c(seqhr, rev(seqhr)), c(exposure$outu6, zeros), col="firebrick2")
text(4, 0.006,"Children below school age")
floating.pie(13.4,0.0051,c(3,12,1,84), edges=600, radius=1.8, startpos=0.59, explode=0,
            col=c("cornflowerblue","firebrick2","white","lightsteelblue1"))
# labels if Linamf data
pie.labels(13.4, 0.0051, angles=c(0.7,1.2,1.5,4),radius=c(2,1,2,0.5),labels=c("3%","11%","1%","84%"))


# legend
par(lheight=.8)
legend(12.1,0.003,legend=c("outdoors"), fill=c("firebrick2"), bty="n")
legend(12.1,0.0025,legend=c("indoors\n out of bed"), fill=c("cornflowerblue"), bty="n")
legend(12.1,0.002,legend=c("indoors\n in bed\n using ITN"), fill=c("lightsteelblue1"), bty="n")
legend(12.1,0.0011,legend=c("indoors\n in bed not\n using ITN"), fill=c("white"), bty="n")



par(new=F)


plot(seqhr, stack_exp_nonets1_o6, type="l", las=1, ylim=c(0, 0.006), frame=FALSE, xaxt="n", yaxt="n", xlab="", ylab="", xlim=c(1,15))
axis(1,at=c(1,2,3,4,5,6,7,8,9,10,11,12), labels=seqhrLabels, las=2)
axis(2, at=c(0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006), labels=NA)
polygon(c(seqhr, rev(seqhr)), c(stack_exp_innets1_o6, zeros), col="lightsteelblue1")
polygon(c(seqhr, rev(seqhr)), c(stack_exp_inawake1_o6, zeros), col="cornflowerblue")
polygon(c(seqhr, rev(seqhr)), c(exposure$outo6, zeros), col="firebrick2")
text(5, 0.006,"School-aged children and adults")
floating.pie(13.4,0.0051,c(5,18,1,76), edges=600, radius=1.8, startpos=0.12, explode=0,
             col=c("cornflowerblue","firebrick2","white","lightsteelblue1"))
# Linamf data labels
pie.labels(13.4, 0.0051, angles=c(0.3,1.1,1.5,4),radius=c(2,1,2,0.5),labels=c("6%","17%","1%","76%"))



*dev.off()






