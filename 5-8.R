library(rstan)
library(bayesplot)
library(KFAS)

source("plotSSM.R", encoding = "utf-8")

data("boat")
boat

boat_omit_NA <- na.omit(as.numeric(boat))

data_list <- list(
  T       = length(boat),
  len_obs = length(boat_omit_NA),
  y       = boat_omit_NA,
  obs_no  = which(!is.na(boat))
)

dglm_binom <- stan(
  file = "5-8-1-dglm-binom.stan",
  data = data_list,
  seed = 1,
  iter = 30000,
  warmup = 10000,
  thin = 20
)

print(dglm_binom,
      par = c("s_w", "lp__"),
      probs = c(0.025, 0.5, 0.975))

years <- seq(from = as.POSIXct("1829-01-01"),
             by = "1 year",
             len = length(boat))
head(years, 3)

mcmc_sample <- rstan::extract(dglm_binom)

plotSSM(mcmc_sample = mcmc_sample,
        time_vec = years,
        obs_vec = as.numeric(boat),
        state_name = "probs",
        graph_title = "ケンブリッジ大学の勝率の推移",
        y_label = "勝率",
        date_labels = "%Y年")

mean(boat_omit_NA)
