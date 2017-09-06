## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(cache = FALSE, autodep = TRUE, collapse = TRUE, comment = "#>"
                      # , fig.height = 3, fig.width = 3
                      )

## ----complete------------------------------------------------------------
library(bnclassify)
data(car)
nb <- lp(nb('class', car), car, smooth = 0)
gr <- as_grain(nb)
library(microbenchmark)
microbenchmark(bnclassify = predict(nb, car),
               gRain  = gRain::predict.grain(gr, 'class', newdata = car),
               times = 1)

## ------------------------------------------------------------------------
microbenchmark(
  tan_hc = {set.seed(0); t <- b <- tan_hc('class', car, k = 10, 
                                          epsilon = 0)},
  tan_hc5 = {set.seed(0); t <- b <- tan_hc('class', car, k = 5, 
                                          epsilon = 0)}, 
  times = 1)

## ----cv------------------------------------------------------------------
tan_hc5 <- tan_hc('class', car, k = 5, epsilon = 0)
tan_hc5 <- lp(tan_hc5, car, smooth = 1)
microbenchmark(tan_hc = {set.seed(0); cv(tan_hc5, car, k = 5)},
               times = 1)

## ---- eval = FALSE-------------------------------------------------------
#  library(mlbench)
#  data(Soybean)
#  soy_complete <- na.omit(Soybean)
#  dim(soy_complete)
#  microbenchmark(
#    tan_hc = {set.seed(0); tan_hc('Class', soy_complete, k = 5,
#                                    epsilon = 0)},
#    times = 1)

## ----incomplete----------------------------------------------------------
nb <- bnc('nb', 'class', car, smooth = 1)
car_na <- car
car_na[1, 4] <- NA
microbenchmark(predict(nb, car), 
               predict(nb, car_na),
               times = 1)

