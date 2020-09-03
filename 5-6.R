library(rstan)
library(bayesplot)
library(ggfortify)
library(gridExtra)

source("plotSSM.R", encoding = "utf-8")

sales_df_4 <- read.csv("5-6-1-sales-ts-4.csv")
sales_df_4$date <- as.POSIXct(sales_df_4$date)
head(sales_df_4, 3)

autoplot(ts(sales_df_4[, -1]))

data_list <- list(
  y = sales_df_4$sales,
  T = nrow(sales_df_4)
)

basic_structual <- stan(
  file = "5-6-1-basic-structual-time-series.stan",
  data = data_list,
  seed = 1,
  iter = 8000,
  warmup = 2000,
  thin = 6,
  control = list(adapt_delta = 0.97, max_treedepth = 15)
)

print(basic_structual,
      par = c("s_z", "s_s", "s_v", "lp__"),
      probs = c(0.025, 0.5, 0.975))

mcmc_sample <- rstan::extract(basic_structual)

p_all <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = sales_df_4$date,
                 obs_vec = sales_df_4$sales,
                 state_name = "alpha",
                 graph_title = "すべての成分を含んだ状態推定値",
                 y_label = "sales")

p_trend <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = sales_df_4$date,
                 obs_vec = sales_df_4$sales,
                 state_name = "mu",
                 graph_title = "周期成分を除いた状態推定値",
                 y_label = "sales")

p_cycle <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = sales_df_4$date,
                 state_name = "gamma",
                 graph_title = "周期成分",
                 y_label = "gamma")

grid.arrange(p_all, p_trend, p_cycle)
