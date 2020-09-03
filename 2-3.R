library(ggplot2)

fish <- read.csv("2-2-1-fish.csv")
head(fish, n=3)

ggplot(data = fish, mapping = aes(x = length)) +
  geom_histogram(alpha = 0.5, bins = 20) +
  labs(title = "ヒストグラム")

ggplot(data = fish, mapping = aes(x = length)) +
  geom_density(size = 1.5) +
  labs(title = "カーネル密度推定")

ggplot(data = fish, mapping = aes(x = length, y = ..density..)) +
  geom_histogram(alpha = 0.5, bins = 20) +
  geom_density(size = 1.5) +
  labs(title = "グラフの重ね合わせ")

install.packages("gridExtra")
library(gridExtra)

p_hist <- ggplot(data = fish, mapping = aes(x = length)) +
  geom_histogram(alpha = 0.5, bins = 20) +
  labs(title = "ヒストグラム")

p_density <- ggplot(data = fish, mapping = aes(x = length)) +
  geom_density(size = 1.5) +
  labs(title = "カーネル密度推定")

grid.arrange(p_hist, p_density, ncol = 2)

head(iris, n=3)

p_box <- ggplot(data = iris,
                mapping = aes(x = Species, y = Petal.Length)) +
  geom_boxplot() +
  labs(title = "箱ひげ図")

p_violin <- ggplot(data = iris,
                   mapping = aes(x = Species, y = Petal.Length)) +
  geom_violin() +
  labs(title = "バイオリンプロット")

grid.arrange(p_box, p_violin, ncol = 2)

ggplot(iris, aes(x = Petal.Width, y = Petal.Length, color = Species)) +
  geom_point()

Nile
nile_data_frame <- data.frame(
  year = 1871:1970,
  Nile = as.numeric(Nile)
)
head(nile_data_frame, n=3)

ggplot(nile_data_frame, aes(x = year, y = Nile)) +
  geom_line()

install.packages("ggfortify")
library(ggfortify)
autoplot(Nile)
