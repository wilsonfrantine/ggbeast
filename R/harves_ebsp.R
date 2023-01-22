#'@name hasvest_ebsp
#'@title process EBSP log file to data_frame
#'@description extract the main parameters from EBSP.log file and output a data.frame
#'@param path the file path to EBSP log or a data.frame from read table with the expected structure. To see that, take a look at data("ebsp") output.
#'@param burnin the amount of runs to discard from 0 (keep all) to 1 (discard all and result in a error). The Default is 0.1 (i.e. 10%).
#'
#'
#'This function also add an aesthetic layer to the data to help users to manipulate characteristics for each run.
#'Thus, each ggplot2 object data will have an extra column at $data slot with the name of the file that generated the data.
#'
#'This function is based on the work of Joseph Helled
#'
#'@references BEAST2 Tutorials Extended Bayesian Skyline Plot.
#'
#'@export
#'@examples
#'\dontrun{
#'path <- system.file("extdata/ebsp.txt", package="ggbeast")
#'harvest_ebsp(path) |> head()
#'}

harvest_ebsp <- function(path=NULL, burnin = 0.1){

  res <- removeBurnin( utils::read.table(path, header=T, sep='\t', as.is=T), burnin) |>
    processEBSPdata(isLinear=T)

  keep <- c("allTimes", "Nmedian", "NlowerHPD", "NupperHPD", "NlowerCPD", "NupperCPD")

  out <- res[keep] |>  Reduce(f=cbind) |> as.data.frame()

  colnames(out) <- keep

  return(cbind("ID"=path, out))

}
