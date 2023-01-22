#'@name ggwrap
#'@title wrap ggbeast plots
#'@author Wilson Frantine-Silva
#'@param ... one or more ggbeast plots separeted by collom.
#'@description This function grabs the data from independent plots and create an unique dataset for using with regularized aesthetics.
#'
#'@seealso [harvest_ebsp()], [scale_time()], [scale_Ne()], [ggplot2::scale_x_continuous()]
#'@export

ggwrap <- function(...){
  x <- list(...)
  lapply(1:length(x), function(i) cbind(x[[i]]$data, Run=as.factor(i))) |>
    Reduce(f=rbind)
}
