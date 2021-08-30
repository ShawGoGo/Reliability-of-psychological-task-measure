library(coefficientalpha)
library(splithalfr)
library(psych)
library(dplyr)
#setwd("D:\\post_doc\\Project_reliablity\\sample data and scripts\\R\\")
df <- read.table('sample_data_internalconsistency.csv', sep = ",", header = T)


# Score function; calculates mean of answers
fn_score  <- function (sets) {
  return (mean(sets$score))
}

# reshape data set from long format to wide format

df_wide <- reshape(
  df,
  direction = "wide",
  timevar = "item",
  idvar = "participants"
)
df_wide <- df_wide[, -1]

# tau equivalent test
#tau.test(df_wide)

# Cronbach's Alpha
fit <- psych::alpha(df_wide)
cronbachs_alpha <- fit$total$raw_alpha

# Macdonal
fit <- psych::omega(df_wide)
omega_coef <- fit$omega_h


# Following script is adopted from Thomas Pronk, pronkthomas@gmail.com, 2019-05-24, updated on 2020-08-03

# get two sets of randomly selected item scores with the same length of orignal data set
participant_count <- 40
replications <- 1
split_scores = by_split(df,
                           df$participants,
                           method = "random",
                              replace = TRUE,
                              split_p = 1,
                              replications = 1,
                              function(ds) {
                                print(ds)

                              },
                              ncores = 1,
                              verbose = F)
# aggregate item scores                   
    names(split_scores)[4] <- paste("score_1")
    names(split_scores)[7] <- paste("score_2")
 
    score_1_m<-aggregate(split_scores[, 4], list(split_scores$participant), mean)
    score_2_m<-aggregate(split_scores[, 7], list(split_scores$participant), mean)
    split_scores_agt<-data.frame(participant=1:participant_count,
                                   score_1=score_1_m$x,
                                   score_2=score_2_m$x,
                                   replication=rep(1,participant_count))
# get the mean of the Pearson correlation coeffecients for all replications
coefs <-  mean(split_coefs(split_scores_agt, cor))    

write.csv(split_scores,"D:\\post_doc\\Project_reliablity\\sample data and scripts\\R\\temp.csv")