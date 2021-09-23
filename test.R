library(tidyverse)
library(grf)
library(policytree)

#setwd("~/vs759/Chapter3/Data")
setwd("~/scratch/ch3")
# load("DF.RData")
# 
# outcomes <- c("inpatient","ilos","outpatient","ov")
# 
# #DF1 <- sample_frac(DF1,0.01)
#
# #Outpatient
# Y.op <- as.numeric(DF1$ov)
# Y.ip <- as.numeric(DF1$ilos)
# W <- as.numeric(DF1$D)-1
# X <- DF1 %>% dplyr::select(-c(all_of(outcomes),D,wt,renum,poor,sick))
# 
# cf.op <- causal_forest(X,Y=Y.op,W)
# cf.ip <- causal_forest(X,Y=Y.ip,W)
# 
# save.image("test.RData")

load("test.RData")

mu.hat.op <- conditional_means(cf.op)
mu.hat.ip <- conditional_means(cf.ip)

scores.op <- double_robust_scores(cf.op)
scores.ip <- double_robust_scores(cf.ip)

#Selected vars to include in policy learning model
select.cols <- c("nik","comp","noncomp","work","school","housework",
                 "otherwork","unemployed","age","urban","atf1",
                 "house1","house2","house3","house4","house5",
                 "secondhouse","disaster","size","n_children",
                 "househh","housefam","rooms","pce")
X_sub <- X[,select.cols]


tree1.op <- policy_tree(X_sub, scores.op, 1)
tree1.ip <- policy_tree(X_sub, scores.ip, 1)
plot(tree1.op)
plot(tree1.ip)

tree2.op<-policy_tree(X_sub, scores.op, 2)
tree2.ip<-policy_tree(X_sub, scores.ip, 2)
plot(tree2.op)
plot(tree2.ip)

#tree3.op <- policy_tree(X_sub, scores.op, 3)
#tree3.ip <- policy_tree(X_sub, scores.ip, 3)
#plot(tree3.op)
#plot(tree3.ip)

save.image("policytree.RData")
