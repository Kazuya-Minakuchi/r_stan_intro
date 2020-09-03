library(rstan)
library(brms)

fish_num_climate <- read.csv("3-8-1-fish-num-1.csv")
head(fish_num_climate, 3)

summary(fish_num_climate)

ggplot(data = fish_num_climate,
       mapping = aes(x = temperature, y = fish_num)) +
  geom_point(aes(color = weather)) +
  labs(title = "釣獲尾数と気温・天気の関係")

glm_pois_brms <- brm(
  formula = fish_num ~ weather + temperature,
  family = poisson(),
  data = fish_num_climate,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"))
)

glm_pois_brms

eff <- marginal_effects(glm_pois_brms,
                        effects = "temperature:weather")
plot(eff, points = TRUE)

set.seed(1)
eff_pre <- marginal_effects(glm_pois_brms,
                            method = "predict",
                            effects = "temperature:weather",
                            probs = c(0.005, 0.995))
plot(eff_pre, points = TRUE)

formula_pois <- formula(fish_num ~ weather + temperature)
design_mat <- model.matrix(formula_pois, fish_num_climate)
design_mat
