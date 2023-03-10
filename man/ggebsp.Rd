% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggebsp.R
\name{ggebsp}
\alias{ggebsp}
\title{Plot EBSP with ggplot2}
\usage{
ggebsp(x = NULL)
}
\arguments{
\item{x}{the output from hasvest_ebsp fuction or a path to EBSP.log run file}
}
\description{
This function outputs an ggplot2 object for a Extended Bayesian Skyline Plot output as described in the EBSP BEAST2 tutorial by Joseph Helled
}
\details{
this function expects a processed data.frame, but if the user provides a path, it will run the \code{harvest_ebsp} function

You can change the time scales with the functions \code{scale_time_raw}, \code{scale_time_years}, \code{scale_time_ka}. Each one of these scales convert to raw scale, years, or thousand of years from an assumed million of years scale. You can also customize it with \code{scale_x_continuous(suffix, scale)}. See ggplot2 documentation
}
\seealso{
\code{\link[=harvest_ebsp]{harvest_ebsp()}}, \code{\link[=scale_time]{scale_time()}}, \code{\link[=scale_Ne]{scale_Ne()}}, \code{\link[ggplot2:scale_continuous]{ggplot2::scale_x_continuous()}}
}
\author{
Wilson Frantine-Silva
}
