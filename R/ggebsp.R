#'@name ggebsp
#'@title Plot EBSP with ggplot2
#'@author Wilson Frantine-Silva
#'@param x the output from hasvest_ebsp fuction or a path to EBSP.log run file
#'@description This function outputs an ggplot2 object for a Extended Bayesian Skyline Plot output as described in the EBSP BEAST2 tutorial by Joseph Helled
#'
#'@details this function expects a processed data.frame, but if the user provides a path, it will run the `harvest_ebsp` function
#'
#'You can change the time scales with the functions `scale_time_raw`, `scale_time_years`, `scale_time_ka`. Each one of these scales convert to raw scale, years, or thousand of years from an assumed million of years scale. You can also customize it with `scale_x_continuous(suffix, scale)`. See ggplot2 documentation
#'
#'@seealso [harvest_ebsp()], [scale_time()], [scale_Ne()], [ggplot2::scale_x_continuous()]
#'@export
#'@import ggplot2

ggebsp <- function(x = NULL){

  if(!is.data.frame(x)){
    x <- harvest_ebsp(x)
    warning("You provided a file path, so harvest_ebsp() was executed with 10% of burnin. Run harvest_ebsp() first to control the burnin.")
  }

  out <- x |>
    ggplot2::ggplot(ggplot2::aes_string(x = "allTimes", y= "Nmedian", color="ID", fill="ID"))+
    ggplot2::geom_line(group=1)+
    ggplot2::geom_ribbon(ggplot2::aes_string(ymin="NlowerHPD", ymax="NupperHPD"), alpha=0.1 )+

    ggplot2::theme_classic()+
    ggplot2::theme(legend.position = "none")+

    ggplot2::scale_y_log10()+

    ggplot2::labs(y="Effective Population Size", x = "Time")
  return(out)
}
