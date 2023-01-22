#'@name scale_time
#'@title Scale time axis
#'@description This family of functions are just wraps to scale_x_continuous from ggplot2.
#'
#'scale_time_raw() returns the time scaled as output from Beast
#'
#'scale_time_years() returns the time scaled in yeas considering input in millions of years (1e6)
#'
#'scale_time_ka() returns the time scaled in thousand of years (1e3)
#'
#'scale_time_Ma() returns the time scaled in million years (usually the beast default)
#'
#'scale_time_Ga() returns the time scaled in billion years (1e-3)
#'
#'@details In molecular clock approaches users usually input a clock rat considering millions of years. For instance, 0.013 mutations/site/million of years, so the output scale in beast might be interpreted as chronological time. This family of functions only transform the visual axis in a different scale assuming the input in millions of years.
#'
#'Users may create custom scales with the following syntax
#' your_plot_object + scale_x_continuous(labels = scales::label_number(suffix="your suffix", scale=1))
#'But changing 1 by the transformation in the data, as 1e6 will multiply the axis label by 1e6.
#'@export

#'@rdname scale_time
#'@export
scale_time_raw   <- function() ggplot2::scale_x_continuous(labels=scales::label_number(suffix="",scale=1))
#'@rdname scale_time
#'@export
scale_time_years <- function() ggplot2::scale_x_continuous(labels=scales::label_number(suffix="yr",scale=1e6))
#'@rdname scale_time
#'@export
scale_time_Ka <- function() ggplot2::scale_x_continuous(labels=scales::label_number(suffix="Ka",scale=1e3))
#'@rdname scale_time
#'@export
scale_time_Ma <- function() ggplot2::scale_x_continuous(labels=scales::label_number(suffix="Ma",scale=1))
#'@rdname scale_time
#'@export
scale_time_Ga <- function() ggplot2::scale_x_continuous(labels=scales::label_number(suffix="Ga",scale=1e-3))

#'@name scale_Ne
#'@title Scale Effective Population Size (Ne) axis
#'@description This family of functions are just alias to scale_y_log10 and scale_y_continuous() with more intuitive names.
#'@export
#'@rdname scale_Ne
scale_Ne_log <- function() ggplot2::scale_y_log10()
#'@export
#'@rdname scale_Ne
scale_Ne_linear <- function() ggplot2::scale_y_continuous()
