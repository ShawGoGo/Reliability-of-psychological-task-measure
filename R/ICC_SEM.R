library(irr)
setwd("D:\\post_doc\\Project_reliablity\\sample data and scripts\\")
sample_data <- read.table('sample_data_test_retest.csv', sep = ",", header = T)
df <- data.frame(sample_data$session1,sample_data$session2)

# estimate ICC
# no specific indication about the model or type
# using ICC to have six outputs corresponding to the models suggested by McGraw & Wong 1996
# Reference: McGraw, K. O., Wong, S. P., "Forming Inferences About Some Intraclass Correlation Coefficients", Psychological Methods, Vol. 1, No. 1, pp. 30-46, 1996
ICC(df)

# Alternatively, you can specify the exact model and type by adding the parameter information in icc function
  # model = "twoway" or "oneway"
  # type = "agreement" or "consistency"
  # unit ="single" or "average"
icc(df, model = "twoway",
  type = "agreement", unit = "single")


# estimate measurement error
# caculate the mean of all scores
m_t <- mean(as.matrix(df))
# caculate the mean for each session / rater
m_b <- colMeans(df)
# caculate the mean for each subject
m_p <- rowMeans(df)
# 1) caculate variance between sessions
SS_B <- sum('^'(m_b-m_t,2))*nrow(df)
# 2) caculate variance within each session
SS_w <- sum('^'(df$sample_data.session1-m_b[1],2))+sum('^'(df$sample_data.session2-m_b[2],2))
# 3) caculate variance of subjects
SS_s <- sum('^'(m_p-m_t,2))*ncol(df)
# 4) caculate residule variance
SSe <- SS_w-SS_s
# 3) SEM is the sum of between sessions/raters variance and residual variance
SEM <- '^'(SSe/((nrow(df)-1)*(ncol(df)-1))+SS_B/(ncol(df)-1),0.5)

  