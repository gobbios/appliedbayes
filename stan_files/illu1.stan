data {
  int n;
  int n_ids;
  array[n] int idx_id;
  vector[n] mating_season;
  array[n] int noffspring;
}
parameters {
  real intercept;
  real slope;
  matrix[2, n_ids] blups_z;
  vector<lower=0.0>[2] sds;
  cholesky_factor_corr[2] chol_ids;
}
transformed parameters {
  matrix[n_ids, 2] blups = transpose(diag_pre_multiply(sds, chol_ids) * blups_z);
}
model {
  vector[n] lp = rep_vector(0.0, n);
  lp = lp + intercept + blups[idx_id, 1];
  lp = lp + (slope + blups[idx_id, 2]) .* mating_season;
  noffspring ~ poisson_log(lp);
  
  intercept ~ normal(-1, 0.2);
  slope ~ normal(0.5, 0.2);
  chol_ids ~ lkj_corr_cholesky(5);
  blups_z[1, ] ~ normal(0, 1);
  blups_z[2, ] ~ normal(0, 1);
  sds[1] ~ exponential(2);
  sds[2] ~ exponential(1);
}
generated quantities {
  real cor_val = multiply_lower_tri_self_transpose(chol_ids)[1, 2];
  real cor_prior = multiply_lower_tri_self_transpose(lkj_corr_cholesky_rng(2, 5))[1, 2];
  vector[2] sds_prior;
  real intercept_prior = normal_rng(-1, 0.2);
  real slope_prior = normal_rng(0.5, 0.2);
  sds_prior[1] = exponential_rng(2);
  sds_prior[2] = exponential_rng(1);
}
