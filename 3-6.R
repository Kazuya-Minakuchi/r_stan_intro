library(rstan)
library(brms)

sales_weather <- read.csv("3-6-1-beer-sales-3.csv")
head(sales_weather, 3)

summary(sales_weather)
ggplot(data = sales_weather, mapping = aes(x = weather, y = sales)) +
  geom_violin() +
  geom_point(aes(color = weather)) +
  labs(title = "ビールの売上と天気の関係")

anova_brms <- brm(
  formula = sales ~ weather,
  family = gaussian(),
  data = sales_weather,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "sigma"))
)
anova_brms

eff <- marginal_effects(anova_brms)
plot(eff, points = FALSE)

formula_anova <- formula(sales ~ weather)
design_mat <- model.matrix(formula_anova, sales_weather)

data_list <- list(
  N = nrow(sales_weather),
  K = 3,
  Y = sales_weather$sales,
  X = design_mat
)
data_list

anova_stan <- stan(
  file = "3-4-1-lm-design-matrix.stan",
  data = data_list,
  seed = 1
)

print(anova_stan, probs = c(0.025, 0.5, 0.975))
