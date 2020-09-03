data {
  int N;          // サンプルサイズ
  int K;          // デザイン行列の列数(説明変数の数+1)
  vector[N] Y;    // 応答変数
  matrix[N, K] X; //デザイン行列
}

parameters {
  vector[K] b;
  real<lower=0> sigma;
}

model {
  vector[N] mu = X * b;
  Y ~ normal(mu, sigma);
}

