# packages --- note the masking of functions!
library("analogue")
library("rioja")

# load SWAP diatom and pH data
data(swapdiat, package = "analogue")
data(swappH, package = "analogue")

# load the RLGH core data
data(rlgh, package = "analogue")

# merge the training set and RLGH data
dat <- join(swapdiat, rlgh, verbose = TRUE)

# split back out and convert to proportions --- data are percentages originally
swap <- dat$swapdiat / 100
rlgh <- dat$rlgh / 100

# WA transfer function --- inverse deshrinking is default
swap_wa <- analogue::wa(swappH ~ ., data = swap)
swap_wa

# fit the model with monotonic spline deshrinking
swap_mono <- analogue::wa(swappH ~ ., data = swap, deshrink = "monotonic")
swap_mono

# performance metrics
analogue::performance(swap_wa)
analogue::performance(swap_mono)

# as above but with rioja
swap_rio <- rioja::WA(swap, swappH)
swap_rio

# plot the model diagnostics
op <- par(mfrow = c(2, 2))
plot(swap_wa)
plot(swap_mono)
par(op)

# predict for the RLGH core
rlgh_wa <- predict(swap_wa, rlgh)
rlgh_mono <- predict(swap_mono, rlgh)

# plot the reconstruction
op <- par(mfrow = c(2, 1))
reconPlot(rlgh_wa, use.labels = TRUE)
reconPlot(rlgh_mono, use.labels = TRUE)
par(op)

# cross validation --- boostrapping
boot_wa <- bootstrap(swap_wa, n.boot = 999)
boot_mono <- bootstrap(swap_mono, n.boot = 999)

boot_wa
boot_mono

# prediction for RLGH with sample-specific errors
rlgh_boot <- predict(swap_mono, newdata = rlgh, CV = "bootstrap", n.boot = 999)
rlgh_boot

# plot the reconstruction
reconPlot(rlgh_boot, errors = "bar", use.labels = TRUE)

# which samples have close analogues in the training set?
rlgh_min_dij <- minDC(swap_mono, rlgh, method = "chord")

# plot the minimum Dij
plot(rlgh_min_dij, use.labels = TRUE)
