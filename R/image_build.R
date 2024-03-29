# WARNING - Generated by {fusen} from dev/flat_first.Rmd: do not edit by hand

#' Title
#' image_build
#' Description
#' build docker image from Dockerfile
#' @param name the label of the built image
#' @param folder_dockerfile the dir where the dockerfile lies in 
#' @param use_podman logit, use podman as  backend when it is TRUE
#' @return str
#' 
#' @export
#' @examples
#' image_build("fallingstar10/gmadeomicsrocker:base","./dev/gmade_rocker-base")
image_build <- function(name,folder_dockerfile, use_podman = FALSE){
  if(dir.exists(folder_dockerfile)){
    commandline <- glue::glue("docker build -t {name} {folder_dockerfile}")
    if (use_podman) {
    commandline = stringr::str_replace(commandline,"docker","podman")
  }
    dockerfile <- glue::glue("{folder_dockerfile}/Dockerfile")
    message(glue::glue("info\\ your command is {commandline},checking the Dockerfile..."))
    if (file.exists(dockerfile)){
      system(commandline)
      return(name)
    } else {
      message("Dockerfile not found")
    }
  }else {
    message("the folder of Dockerfile not found")
  }
}

