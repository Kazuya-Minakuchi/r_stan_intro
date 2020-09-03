library(rstan)
library(brms)

germination_dat <- read.csv("3-9-1-germination.csv")
head(germination_dat, 3)

summary(germination_dat)

ggplot(data = germination_dat,
       mapping = aes(x = nutrition, y = germination, color = solar)) +
  geom_point() +
  labs(title = "種子の発芽数と、日照の有無・栄養素の量の関係")

glm_binom_brms <- brm(
  germination | trials(size) ~ solar + nutrition,
  family = binomial(),
  data = germination_dat,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"))
)
glm_binom_brms

newdata_1 <- data.frame(
  solar = c("shade", "sunshine", "sunshine"),
  nutrition = c(2,2,3),
  size = c(10,10,10)
)
newdata_1

fitted(glm_binom_brms, newdata_1, scale = "linear")
fitted(glm_binom_brms, newdata_1, scale = "linear")[,1]
linear_fit <- fitted(glm_binom_brms, newdata_1, scale = "linear")[,1]
fit <- 1 / (1 + exp(-linear_fit))
fit

odds_1 <- fit[1] / (1 - fit[1])
odds_2 <- fit[2] / (1 - fit[2])
odds_3 <- fit[3] / (1 - fit[3])

fixef(glm_binom_brms)
coef <- fixef(glm_binom_brms)[,1]
coef

odds_2 / odds_1
exp(coef["solarsunshine"])

odds_3 / odds_2
exp(coef["nutrition"])

eff <- marginal_effects(glm_binom_brms,
                        effects = "nutrition:solar")
plot(eff, points = TRUE)
plot(eff, points = FALSE)
