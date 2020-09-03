library(rstan)
library(bayesplot)
library(ggfortify)
library(gridExtra)

source("plotSSM.R", encoding = "utf-8")

fish_ts <- read.csv("5-9-1-fish-num-ts.csv")
fish_ts$date <- as.POSIXct(fish_ts$date)
head(fish_ts, 3)

autoplot(ts(fish_ts[, -1]))

data_list <- list(
  y = fish_ts$fish_num,
  ex = fish_ts$temperature,
  T = nrow(fish_ts)
)

dglm_poisson <- stan(
  file = "5-9-1-dglm-poisson.stan",
  data = data_list,
  seed = 1,
  iter = 8000,
  warmup = 2000,
  thin = 6,
  control = list(adapt_delta = 0.99, max_treedepth = 15)
)

print(dglm_poisson,
      par = c("s_z", "s_r", "b", "lp__"),
      probs = c(0.025, 0.5, 0.975))

mcmc_sample <- rstan::extract(dglm_poisson)

p_all <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = fish_ts$date,
                 obs_vec = fish_ts$fish_num,
                 state_name = "lambda_exp",
                 graph_title = "状態推定値",
                 y_label = "釣獲尾数",
                 date_labels = "%Y年%m月%d日")

p_smooth <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = fish_ts$date,
                 obs_vec = fish_ts$fish_num,
                 state_name = "lambda_smooth",
                 graph_title = "ランダム効果を除いた状態推定値",
                 y_label = "釣獲尾数",
                 date_labels = "%Y年%m月%d日")

p_fix <- plotSSM(mcmc_sample = mcmc_sample,
                 time_vec = fish_ts$date,
                 obs_vec = fish_ts$fish_num,
                 state_name = "lambda_smooth_fix",
                 graph_title = "気温を固定した状態推定値",
                 y_label = "釣獲尾数",
                 date_labels = "%Y年%m月%d日")

grid.arrange(p_all, p_smooth, p_fix)
