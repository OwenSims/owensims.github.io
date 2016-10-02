# 0: "Sleeping"
# 1: "Personal Care"
# 2: "Eating & Drinking"
# 3: "Education"
# 4: "Work"
# 5: "Housework"
# 6: "Shopping"
# 7: "Leisure"
# 8: Sports
# 9: Misc."
# 10: "Traveling"
# Begin: 04:00

randomLength <- data.frame(activity = seq(0:10),
                           mean = c(200, 20, 45,  120, 200, 20, 60, 120, 0, 120, 15),
                           sd = c(15, 2.5, 5, 20, 25, 2, 10, 20, 0, 5, 7.5))
periods <- data.frame(period = c(0,
                                 1, 1, 1, 
                                 2, 2, 2, 2,
                                 3, 3,
                                 4, 4, 4, 4, 
                                 5, 5, 5, 5, 
                                 6, 6, 6, 6,
                                 7, 7, 7, 7),
                      activity = c(0,
                                   0, 1, 10, 
                                   1, 2, 3, 4,
                                   10, 2,
                                   2, 3, 4, 10,
                                   4, 2, 6, 3,
                                   10, 7, 6, 5,
                                   0, 7, 9, 3),
                      prob = c(1,
                               0.9, 0.06, 0.04,
                               0.83, 0.07, 0.05, 0.05,
                               0.9, 0.1,
                               0.8, 0.05, 0.05, 0.1,
                               0.8, 0.15, 0.03, 0.02,
                               0.5, 0.24, 0.13, 0.13,
                               0.72, 0.1, 0.1, 0.08))
totalDays <- 365
for (j in 1:length(unique(periods$period))) {
  phase <- subset(periods, periods$period == unique(periods$period)[j])
  for (k in 1:nrow(phase)) {
    # print(paste0("Loop ", k, " of Phase ", j, "."))
    currentActivity <- phase$activity[k]
    act <- rep(phase$activity[k], 
               ceiling(totalDays * phase$prob[k]))
    time <- round(rnorm(ceiling(totalDays * phase$prob[k]),
                        mean = randomLength$mean[currentActivity + 1],
                        sd = randomLength$sd[currentActivity + 1]))
    if (k == 1) {
      actTime <- cbind(act, time)
    } else {
      actTime <- rbind(actTime, cbind(act, time))
    }
  }
  if (j == 1) {
    routine <- data.frame(actTime[1:totalDays, ])
  } else {
    routine <- cbind(routine, actTime[1:totalDays, ])
  }
}
write.table(routine,
            file = "~/Sites/owensims.github.io/projects/dailyRoutine/data/routine.tsv",
            sep = ",",
            col.names = FALSE,
            row.names = FALSE,
            eol = "\"\n\"")
