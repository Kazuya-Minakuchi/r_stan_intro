data {
  int N;           // サンプルサイズ
  vector[N] sales_a; // Aデータ
  vector[N] sales_b; // Bデータ
}

parameters {
  real mu_a;             // A平均
  real<lower=0> sigma_a; // A標準偏差
  real mu_b;             // B平均
  real<lower=0> sigma_b; // B標準偏差
}

model {
  // 平均mu, 標準偏差sigmaの正規分布に従ってデータが得られたと仮定
  sales_a ~ normal(mu_a, sigma_a);
  sales_b ~ normal(mu_b, sigma_b);
}

generated quantities {
  real diff;
  diff = mu_b - mu_a;
}
