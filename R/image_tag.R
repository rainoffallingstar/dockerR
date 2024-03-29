# WARNING - Generated by {fusen} from dev/flat_first.Rmd: do not edit by hand

#' Title
#' image_tag
#' Description
#' change the tag of image
#' @param oldtag the old/original image label,str
#' @param newtag the new image label,str
#' @param .keep whether to keep the oldtag image
#' @param use_podman logit, use podman as  backend when it is TRUE
#' @return str
#' 
#' @export
#' @examples
#'   image_tag("diygod/rsshub","fall/rsshub")
image_tag <- function(oldtag,newtag,.keep = TRUE, use_podman = FALSE){
  commandline <- glue::glue("docker tag {oldtag} {newtag}")
  if (use_podman) {
    commandline = stringr::str_replace(commandline,"docker","podman")
  }
  message(glue::glue("info\\ your command is {commandline},checking the imageids..."))
  allimage <- lsimage(use_podman = use_podman)
  if (oldtag %in% allimage$REPOSITORY){
    system(commandline)
    if (.keep == FALSE){
      image_rmi(oldtag)
    }
    return(newtag)
  }else{
    message("the oldtag does not exist")
    return(oldtag)
  } 
}

