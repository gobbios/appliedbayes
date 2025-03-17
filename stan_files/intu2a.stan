data {
  int nobs;
  array[nobs] int noffspring;
  vector<lower=0.0>[nobs] age;
}
parameters {
  real intercept;
  real ageslope;
}
model {
  // likelihood
  noffspring ~ poisson(exp(intercept + ageslope * age));
  // priors
  intercept ~ normal(0, 20);
  ageslope ~ normal(0, 20);
}
generated quantities {
  real intercept_prior = normal_rng(0, 20);
  real ageslope_prior = normal_rng(0, 20);
  array[nobs] int noffspring_rep = poisson_rng(exp(intercept + ageslope * age));
}
