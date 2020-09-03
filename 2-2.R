fish <- read.csv("2-2-1-fish.csv")
head(fish, n=3)

hist(fish$length)

kernel_density <- density(fish$length)
plot(kernel_density)

kernel_density_quarter <-density(fish$length, adjust=0.25)
kernel_density_quadruple <-density(fish$length, adjust=4)
plot(kernel_density,
     lwd=2,
     xlab="",
     ylim=c(0, 0.26),
     main = "バンド幅を変える")
lines(kernel_density_quarter, col=2)
lines(kernel_density_quadruple, col=4)
legend("topleft",
       col=c(1,2,4),
       lwd=1,
       bty="n",
       legend=c("標準","バンド幅1/4","バンド幅4倍"))

mean(fish$length)
median(fish$length)
quantile(fish$length, probs=c(0.5))
quantile(fish$length, probs=c(0.25, 0.75))

birds <- read.csv("2-1-1-birds.csv")
cor(birds$body_length, birds$feather_length)

Nile
acf(
  Nile,
  type="covariance",
  plot=F,
  lag.max=5
)
acf(
  Nile,
  plot=F,
  lag.max=5
)
acf(Nile)

