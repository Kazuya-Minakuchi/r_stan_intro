data {
  int N;           // サンプルサイズ
  int fish_num[N]; // 釣獲尾数
  vector[N] temperature;  // 気温データ
  vector[N] weathersunny; // 晴れダミー変数
}

parameters {
  real Intercept; // 切片
  real b_temp;    // 係数（気温）
  real b_sunny;   // 係数（晴れの影響）
}

model {
  vector[N] lambda = exp(Intercept + b_temp*temperature + b_sunny*weathersunny);
  fish_num ~ poisson(lambda);
}
