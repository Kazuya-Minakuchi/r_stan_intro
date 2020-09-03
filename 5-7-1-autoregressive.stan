data {
  int T;        // データ取得期間の長さ
  vector[T] y;  // 観測値
}
parameters {
  real<lower=0> s_w;
  real b_ar;
  real Intercept;
}
model {
  for(i in 2:T){
    y[i] ~ normal(Intercept + y[i-1]*b_ar, s_w);
  }
}
