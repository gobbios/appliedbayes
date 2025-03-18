# A primer on applied Bayesian modelling

If you want to recreate the slides you will need

- [`quarto`](https://quarto.org)

- [`Stan`](https://mc-stan.org)

- `R` packages from CRAN: `knitr`, `kableExtra`

- `R` packages from GitHub: [`cmdstanr`](https://github.com/stan-dev/cmdstanr), [`EloRating.Bayes`](https://github.com/gobbios/EloRating.Bayes)

- for the optional `shiny` app, you will also need, well, `shiny`

To render, download or clone the repository and then in the command line do:

```
quarto preview 00_main.qmd --to revealjs --presentation --no-watch-inputs --no-browse
```

Or, if you use RStudio, open `00_main.qmd` and click the Render button.

If you just want to run the shiny app, download the app file (`resources/app.R`), and then run from R:

```
library(shiny)
runApp("path/to/my/documents/app.R")
```

# Recommended text books

Richard McElreath: [Statistical Rethinking](https://doi.org/10.1201/9780429029608)

Ben Lambert: [A Student's Guide to Bayesian Statistics](https://uk.sagepub.com/en-gb/eur/book/student’s-guide-bayesian-statistics)


