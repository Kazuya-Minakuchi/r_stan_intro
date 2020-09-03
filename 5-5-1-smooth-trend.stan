data {
  int T;        // データ取得期間の長さ
  vector[T] y;  // 観測値
}
parameters {
  vector[T] mu;
  real<lower=0> s_z;
  real<lower=0> s_v;
}
model {
  for(i in 3:T){
    mu[i] ~ normal(2*mu[i-1] - mu[i-2], s_z);
  }
  for(i in 1:T){
    y[i] ~ normal(mu[i], s_v);
  }
}
