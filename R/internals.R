###All this file is copy and pasted from Joseph Haled Extended Bayesian Skyline Plot BEAST 2 tutorial

#'@noRd
getPopSize <- function(t, changeTimes, changePops, isLinear) {

  i <- findInterval(t, changeTimes)

  if (isLinear) {
    if (i>=length(changeTimes))
      return (changePops[length(changePops)])

    if (i<1)
      return (changePops[1])

    return (changePops[i] + (t-changeTimes[i])/(changeTimes[i+1]-changeTimes[i])*(changePops[i+1]-changePops[i]))
  } else {
    return (changePops[min(length(changePops), max(0, i))])
  }
}

# Adds a population function to an existing plot

plotPopFunction <- function(changeTimes, changePops, isLinear, maxTime=NA, ...) {
  if (isLinear) graphics::lines(changeTimes, changePops, ...) else graphics::lines(changeTimes, changePops, 's', ...)

  if (!is.na(maxTime) && maxTime>changeTimes[length(changeTimes)])
    graphics::lines(c(changeTimes[length(changeTimes)], maxTime), rep(changePops[length(changePops)],2), ...)
}

# This is an approximation that assumes HPD is a single interval
computeHPD <- function(x, alpha=0.95, sorted=FALSE) {
  if (sorted) y <- x else y <- sort(x)

  n <- length(y)
  m <- round(alpha*n)

  i <- 1
  delta <- y[n] - y[1]
  lower <- y[1]
  upper <- y[n]

  while (i+m <= n) {
    thisDelta <- y[i+m] - y[i]
    if (thisDelta < delta) {
      delta <- thisDelta
      lower <- y[i]
      upper <- y[i+m]
    }

    i <- i + 1
  }

  res <- list()
  res$lower <- lower
  res$upper <- upper

  return(res)
}

# Compute all relevant statistics from EBSP data.
processEBSPdata <- function(df, isLinear) {

  frameLen <- dim(df)[1]
  nTimes <- dim(df)[2] - 2

  allTimes <- rep(0, nTimes)

  changeTimes <- list()
  changePops <- list()

  Nmedian <- rep(0, nTimes)
  NupperHPD <- rep(0, nTimes)
  NlowerHPD <- rep(0, nTimes)
  NupperCPD <- rep(0, nTimes)
  NlowerCPD <- rep(0, nTimes)

  for (i in 1:frameLen) {
    theseChangeTimes <- NULL
    theseChangePops <- NULL
    p <- 0
    for (j in 1:nTimes) {
      pair = strsplit(as.character(df[i,1+j]), ":")[[1]]
      time <- as.double(pair[1])
      allTimes[j] <- allTimes[j] + time

      if (length(pair)>1) {
        p <- p + 1
        theseChangeTimes[p] <- time
        theseChangePops[p] <- as.double(pair[2])
      }
    }

    changeTimes[[i]] <- theseChangeTimes
    changePops[[i]] <- theseChangePops
  }

  allTimes <- allTimes/frameLen

  for (i in 1:nTimes) {
    thisN <- rep(0, frameLen)
    for (j in 1:frameLen) {
      thisN[j] <- getPopSize(allTimes[i], changeTimes[[j]], changePops[[j]], isLinear)
    }
    Nmedian[i] <- stats::median(thisN)

    # Compute confidence intervals

    hpd <- computeHPD(thisN, alpha=0.95)
    NlowerHPD[i] <- hpd$lower
    NupperHPD[i] <- hpd$upper

    NlowerCPD[i] <- stats::quantile(thisN, probs=0.025)
    NupperCPD[i] <- stats::quantile(thisN, probs=0.975)
  }

  res <- list()
  res$allTimes <- allTimes
  res$changeTimes <- changeTimes
  res$changePops <- changePops
  res$Nmedian <- Nmedian
  res$NlowerHPD <- NlowerHPD
  res$NupperHPD <- NupperHPD
  res$NlowerCPD <- NlowerCPD
  res$NupperCPD <- NupperCPD

  return(res)
}

getTimes <- function(df) {

  frameLen <- dim(df)[1]
  nTimes <- dim(df)[2] - 2

  times <- rep(0, frameLen*nTimes)
  k <- 1

  for (i in 1:frameLen) {
    for (j in 1:nTimes) {
      times[k] <- as.double(strsplit(df[i,1+j], ":")[[1]][1])
      k <- k + 1
    }

  }

  return(times)
}
removeBurnin <- function(df, burnin=0.1) {
  frameLen <- dim(df)[1]
  return(df[-(1:ceiling(burnin*frameLen)),])
}

plotEBSP <- function(fileName, burnin=0.1, isLinear=TRUE, useHPD=TRUE, showLegend=TRUE, plotPopFunctions=FALSE, popFunctionAlpha=0.05, ...) {

  df <- removeBurnin(utils::read.table(fileName, header=T, sep='\t', as.is=T), burnin)
  res <- processEBSPdata(df, isLinear)

  ellipsis <- list(...)

  if (length(ellipsis$xlab) == 0)
    ellipsis$xlab = "Time"

  if (length(ellipsis$ylab) == 0)
    ellipsis$ylab = "Population"

  if (length(ellipsis$ylim) == 0) {
    if (useHPD)
      ellipsis$ylim = c(0.9*min(res$NlowerHPD), 1.1*max(res$NupperHPD))
    else
      ellipsis$ylim = c(0.9*min(res$NlowerCPD), 1.1*max(res$NupperCPD))
  }

  args <- c(list(res$allTimes, res$Nmedian, 'l'), ellipsis)

  do.call(plot, args)

  if (!plotPopFunctions) {
    if (useHPD)
      graphics::polygon(c(res$allTimes, rev(res$allTimes)), c(res$NlowerHPD, rev(res$NupperHPD)),
              col="grey", border=NA)
    else
      graphics::polygon(c(res$allTimes, rev(res$allTimes)), c(res$NlowerCPD, rev(res$NupperCPD)),
              col="grey", border=NA)
  } else {
    maxTime <- max(res$allTimes)
    for (i in 1:length(res$changeTimes)) {
      plotPopFunction(res$changeTimes[[i]], res$changePops[[i]], isLinear, maxTime=maxTime, col=grDevices::rgb(0, 0.5, 0, popFunctionAlpha))
    }
  }

  if (useHPD) {
    graphics::lines(res$allTimes, res$NupperHPD, lwd=1)
    graphics::lines(res$allTimes, res$NlowerHPD, lwd=1)
  } else {
    graphics::lines(res$allTimes, res$NupperCPD, lwd=1)
    graphics::lines(res$allTimes, res$NlowerCPD, lwd=1)
  }

  graphics::lines(res$allTimes, res$Nmedian, lty=2, lwd=2)

  if (showLegend) {
    if (useHPD)
      CIlabel <- "95% HPD"
    else
      CIlabel <- "95% CPD"

    graphics::legend('topright', inset=0.05, c("Median", CIlabel), lty=c(2, 1), lwd=c(2, 1))
  }
}

plotEBSPTimesHist <- function(fileName, burnin=0.1, alpha=0.95, ...) {

  df <- removeBurnin(utils::read.table(fileName, header=T, sep='\t', as.is=T), burnin)
  times <- getTimes(df)

  xmax <- stats::quantile(times, alpha)

  graphics::hist(times, breaks=c(seq(0, xmax, length.out=100), max(times)), xlim=c(0, xmax),
       xlab="Time", prob=T, main="Histogram of tree event times in log")

}

### Data-sets Documentation #####

#' Simulated Extended Bayesian Skyline Plot log output from Beast2
#'
#' This is a simulated subset of data from EBSP .log file ran in
#'  Beast2 and processed with harvest_ebsp function, from this package.
#' This might help users to check whether their codes are working fine.
#' A data frame with 101 rows and 103 columns:
#' \describe{
#'   \item{Sample}{The chain ID}
#'   \item{popsSize0}{estimated effective population size from 0:time}
#'   \item{demographic.alltrees.times.0, ..., demographic.alltrees.time.101}{time estimated for each change}
#' }
#'
#' @name ebsp
#' @docType data
#' @author Wilson Frantine-Silva
#' @keywords data
#' @source this package
