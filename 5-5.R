library(rstan)
library(bayesplot)
library(ggfortify)
library(gridExtra)

source("plotSSM.R", encoding = "utf-8")

sales_df_3 <- read.csv("5-5-1-sales-ts-3.csv")
sales_df_3$date <- as.POSIXct(sales_df_3$date)
head(sales_df_3, 3)

autoplot(ts(sales_df_3[, -1]))

data_list <- list(
  y = sales_df_3$sales,
  T = nrow(sales_df_3)
)

local_level <- stan(
  file = "5-2-1-local-level.stan",
  data = data_list,
  seed = 1
)

print(local_level,
      par = c("s_w", "s_v", "lp__"),
      probs = c(0.025, 0.5, 0.975))

smooth_trend <- stan(
  file = "5-5-1-smooth-trend.stan",
  data = data_list,
  seed = 1,
  iter = 8000,
  warmup = 2000,
  thin = 6,
  control = list(adapt_delta = 0.9, max_treedepth = 15)
)

print(smooth_trend,
      par = c("s_z", "s_v", "lp__"),
      probs = c(0.025, 0.5, 0.975))

local_linear_trend <- stan(
  file = "5-5-2-local-linear-trend.stan",
  data = data_list,
  seed = 1,
  iter = 8000,
  warmup = 2000,
  thin = 6
)

print(local_linear_trend,
      par = c("s_w", "s_z", "s_v", "lp__"),
      probs = c(0.025, 0.5, 0.975))

mcmc_sample_ll <- rstan::extract(local_level)
mcmc_sample_st <- rstan::extract(smooth_trend)
mcmc_sample_llt <- rstan::extract(local_linear_trend)

p_ll <- plotSSM(mcmc_sample = mcmc_sample_ll,
                time_vec = sales_df_3$date,
                obs_vec = sales_df_3$sales,
                state_name = "mu",
                graph_title = "ローカルレベルモデル",
                y_label = "sales")

p_st <- plotSSM(mcmc_sample = mcmc_sample_st,
                time_vec = sales_df_3$date,
                obs_vec = sales_df_3$sales,
                state_name = "mu",
                graph_title = "平滑化トレンドモデル",
                y_label = "sales")

p_llt <- plotSSM(mcmc_sample = mcmc_sample_llt,
                time_vec = sales_df_3$date,
                obs_vec = sales_df_3$sales,
                state_name = "mu",
                graph_title = "ローカル線形トレンドモデル",
                y_label = "sales")

grid.arrange(p_ll, p_st, p_llt)

plotSSM(mcmc_sample = mcmc_sample_llt,
        time_vec = sales_df_3$date,
        state_name = "delta",
        graph_title = "ドリフト成分",
        y_label = "delta")
