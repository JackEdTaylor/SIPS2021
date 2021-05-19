library(tidyverse)
library(faux)
library(brms)

n_stim <- 5000
set.seed(1)

stim_pool <- tibble(
  stim_id = sprintf("face_%g", 1:n_stim),
  gender = as.factor(sample(c("m", "f"), size=n_stim, replace=TRUE)),
  age = sample(18:60, size=n_stim, replace=TRUE),
  task_rt = round(rshifted_lnorm(n_stim, 6, 0.5, 130), 2)
) %>%
  bind_cols(
    rnorm_multi(
      n_stim,
      mu = c(64, 114),
      sd = c(2.5, 3.3),
      r = -0.62,
      varnames = c("face_width", "face_length")
    )
  ) %>%
  mutate(face_width = round(face_width, 2), face_length = round(face_length, 2)) %>%
  mutate(face_width = if_else(gender=="f", face_width-2.5, face_width))

write_csv(stim_pool, "stim_pool.csv")
