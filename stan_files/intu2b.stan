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
  intercept ~ normal(-1.5, 2);
  ageslope ~ normal(0.5, 0.5);
}
generated quantities {
  real intercept_prior = normal_rng(-1.5, 2);
  real ageslope_prior = normal_rng(0.5, 0.5);
  array[nobs] int noffspring_rep = poisson_rng(exp(intercept + ageslope * age));
}
