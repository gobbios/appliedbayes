data {
  int<lower=1> N; // number of observations
  vector[N] y; // the response
  vector[N] predictor; // the predictor
}
parameters {
  real the_intercept; // declare intercept to be estimated
  real the_slope; // declare slope to be estimated
  real<lower=0> standard_dev; // declare SD to be estimated
}
model {
  // very explicit with loop (could be vectorized)
  for (i in 1:N) {
    real lp = the_intercept + the_slope * predictor[i]; // the 'deterministic' part
    y[i] ~ normal(lp, standard_dev); // the distributional part ('stochastic')
  }
}
