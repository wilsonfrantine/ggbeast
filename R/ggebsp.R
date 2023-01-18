#'@name ggebsp
#'@title Plot EBSP with ggplot2
#'@author Wilson Frantine-Silva
#'@param file the path to EBSP.log run file
#'@param burnin the burnin quantity parameter. By defaut it is 0.1 (10%), but users may adjust as tracer output
#'@description this function outputs an ggplot2 object for a Extended Bayesian Skyline plot output as described in details in the EBSP BEAST2 tutorial by Joseph Helled
#'@export
#'@import ggplot2

ggebsp <- function(file = NULL, burnin=0.1){

  df <- removeBurnin(read.table(file, header=T, sep='\t', as.is=T), burnin)
  res <- processEBSPdata(df, isLinear=T)

  keep <- c("allTimes", "Nmedian", "NlowerHPD", "NupperHPD", "NlowerCPD", "NupperCPD")

  ggdata <- res[keep] |>  Reduce(f=cbind) |> as.data.frame()

  colnames(ggdata) <- keep

  out <- ggdata |>
    ggplot2::ggplot(aes(x = allTimes, y=Nmedian))+
    ggplot2::geom_line(group=1)+
    ggplot2::geom_ribbon(aes(ymin=NlowerHPD, ymax=NupperHPD), alpha=0.1 )+

    ggplot2::theme_classic()+

    ggplot2::scale_y_log10()+
    ggplot2::scale_x_continuous(labels = scales::label_number(suffix=" Ka", scale = 1e3))+

    ggplot2::labs(y="Effective Population Size", x = "Time (Ka)")
}
