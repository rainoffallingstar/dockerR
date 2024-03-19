# dockerR

check_program_installed <- function(program_name) {
  cmd <- paste(program_name, "--version")
  output <- system(cmd, intern = TRUE)
  if (grepl("not found", output)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

lscontainer <- function(base_command = "docker ps",
                             additional = "-a"){
  
  if (!is.na(additional)){
    commandline <- glue::glue("{base_command} {additional}")
  } else {
    commandline <- base_command
  }
  message(glue::glue("info:: your command is {commandline},runing..."))
  output <- system(command = commandline,
                   intern = TRUE)
  header <- output[1]
  data_lines <- output[-1]
  data <- do.call(rbind, lapply(data_lines, function(x) {
    strsplit(x, "\\s{2,}")[[1]]
  }))
  header_clean <- strsplit(header, "\\s{2,}")[[1]]
  if (ncol(data) == length(header_clean)) {
    colnames(data) <- header_clean
    data <- as.data.frame(data)
    return(data)
  }else{
    message("something went wrong, check your command")
    return(NA)
  }
}
lscontainer(additional = "-a")

lsimage <- function(base_command = "docker images",
                    additional = NA){
  
  if (!is.na(additional)){
    commandline <- glue::glue("{base_command} {additional}")
  } else {
    commandline <- base_command
  }
  message(glue::glue("info:: your command is {commandline},runing..."))
  output <- system(command = commandline,
                   intern = TRUE)
  header <- output[1]
  data_lines <- output[-1]
  data <- do.call(rbind, lapply(data_lines, function(x) {
    strsplit(x, "\\s{2,}")[[1]]
  }))
  header_clean <- strsplit(header, "\\s{2,}")[[1]]
  if (ncol(data) == length(header_clean)) {
    colnames(data) <- header_clean
    data <- as.data.frame(data)
    return(data)
  }else{
    message("something went wrong, check your command")
    return(NA)
  }
}
lsimage()

image_rmi <- function(id){
    commandline <- glue::glue("docker rmi {id}")
    message(glue::glue("info:: your command is {commandline},checking the imageids..."))
    allimage <- lsimage()
    if (id %in% c(allimage$REPOSITORY,allimage$`IMAGE ID`)){
      system(commandline)
    }else{
      message("the imageid is not correct")
    }
    return(id)
}

image_pull <- function(id){
  commandline <- glue::glue("docker pull {id}")
  message(glue::glue("info:: your command is {commandline},checking the imageids..."))
  allimage <- lsimage()
  if (id %in% allimage$REPOSITORY){
    message("the image already exist")
  }else{
    system(commandline)
  }
  return(id)
}

image_pull("diygod/rsshub")
image_rmi("diygod/rsshub")

library(dplyr)
image_rmi("diygod/rsshub") %>% 
  image_pull()


image_tag <- function(oldtag,newtag,.keep = TRUE){
  commandline <- glue::glue("docker tag {oldtag} {newtag}")
  message(glue::glue("info:: your command is {commandline},checking the imageids..."))
  allimage <- lsimage()
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
image_rmi("diygod/rsshub") %>% 
  image_pull() %>% 
  image_tag("fall/rsshub")

image_build <- function(name,folder_dockerfile){
  if(dir.exists(folder_dockerfile)){
    commandline <- glue::glue("docker build -t {name} {folder_dockerfile}")
    dockerfile <- glue::glue("{folder_dockerfile}/Dockerfile")
    message(glue::glue("info:: your command is {commandline},checking the Dockerfile..."))
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
image_build("fallingstar10/gmadeomicsrocker:tiny","D:/fallingstarGitcode/gmadeomicsrocker/gmade_rocker-tiny")

image_push <- function(containername,username,password){
  message("info::this function will push your image to dockerhub")
  dockerlogin <- glue::glue("docker login -u {username} -p {password}")
  dockerpush <- glue::glue("docker push {containername}")
  if (grepl(username,containername)){
    system(paste(
      dockerlogin, "&&",dockerpush
    ))
    return(containername)
  }else {
    message("conflit found in the containername and the username,please re-taging...")
  }
}

image_save <- function(imageid,tarfile){
  # 先判断是不是在列表里
  # docker save -o my_ubuntu_v3.tar runoob/ubuntu:v3
  if (!dir.exists(dirname(tarfile))){
    fs::dir_create(
      dirname(tarfile)
    )
  }
  commandline <- glue::glue("docker save -o {tarfile} {imageid}")
  message(glue::glue("info:: your command is {commandline},checking the imageid..."))
  allimage <- lsimage()
  if (imageid %in% c(allimage$REPOSITORY,allimage$`IMAGE ID`)){
    system(commandline)
  }else{
    message("the imageid is not correct")
  }
  return(tarfile)
}

image_load <- function(tarfile,import = FALSE,imageid = NULL){
  #docker load --input fedora.tar
  message(glue::glue("info:: your command is {commandline},checking the imageid..."))
  allimage <- lsimage()
  if (!is.null(imageid) | !(imageid %in% c(allimage$REPOSITORY,allimage$`IMAGE ID`))){
    importvalidation = TRUE
  } else {
    importvalidation = FALSE
  }
  if (file.exists(tarfile)){
    if (import == FALSE){
      system(command = glue::glue("docker load --input {tarfile}"))
      return(tarfile)
    }else if (importvalidation){
      system(command = glue::glue("docker import {tarfile} {imageid}"))
      return(imageid)
    } else {
      message("please input a specific imageid ,which should has no confilct with existed names")
    }
  } else {
    message("tarfile does not exists")
  }
}


container_run <- function(imageid,
                          name,
                          volume = NULL,
                          ports,
                          environmentvarible = NULL,
                          ifD = TRUE, 
                          restart = TRUE,
                          run_at_once = TRUE){
  if (run_at_once){
    run <- "run"
  } else {
    run <- "create"
  }
  if (restart){
    restart <- "--restart=always"
  } else {
    restart <- ""
  }
  if (ifD){
    ifD <- "-d"
  }else{
    ifD <- ""
  }
  if (is.null(volume)){
    volume <- ""
  }
  if (is.null(environmentvarible)){
    environmentvarible <- ""
  }
  commandline <- glue::glue("docker {run} {ifD} {restart} --name={name} {ports} {volume} {environmentvarible} {imageid}")
  message(glue::glue("info:: your command is {commandline},checking the imageid..."))
  allimage <- lsimage()
  if (imageid %in% c(allimage$REPOSITORY,allimage$`IMAGE ID`)){
    system(commandline)
  }else{
    message("the imageid is not correct")
  }
  return(name)

} 

container_run("diygod/rsshub","rsshub",ports = "-p 1200:1200")


container_control <- function(containerid,mod = c("stop","start","restart","rm"),
                              forcerm = FALSE
){
  if (mod != "rm"){
    commandline <- glue::glue("docker {mod} {containerid}")
  } else if(forcerm) {
    commandline <- glue::glue(" docker {mod} -f {containerid}")
  } else {
    commandline <- glue::glue(" docker {mod}  {containerid}")
  }
  
  message(glue::glue("info:: your command is {commandline},checking the containerid..."))
  allcontainer <-lscontainer()
  if (containerid %in% c( allcontainer$NAMES,allcontainer$`CONTAINER ID`,allcontainer$PORTS)){
    system(commandline)
  }else{
    message("the containerid is not correct")
  }
  return(containerid)
}

container_update <- function(containerid,imageid,
                             force_rm_container = FALSE,
                             volume = NULL,
                             ports,
                             environmentvarible = NULL,
                             ifD = TRUE, 
                             restart = TRUE,
                             run_at_once = TRUE){
  # stop
  message("stop the container")
  container_control(containerid,"stop") %>% 
    container_control("rm",forcerm = force_rm_container )
  # rm image
  message("deleting the old images and pull a new one")
  image_rmi(imageid)  %>% 
    image_pull() 
  # rerunimage
  message("re-run the container")
  container_run(imageid,
                containerid,
                volume,
                ports,
                environmentvarible,
                ifD,
                restart,
                run_at_once)
  return(containerid)
}
container_update("rsshub","diygod/rsshub",ports = "-p 1200:1200")


container_updateParameter <- function(containerid,updateParameter){
  commandline <- glue::glue("docker container update {updateParameter} {containerid}")
  message(glue::glue("info:: your command is {commandline},checking the containerid..."))
  allcontainer <-lscontainer()
  if (containerid %in% c( allcontainer$NAMES,allcontainer$`CONTAINER ID`,allcontainer$PORTS)){
    system(commandline)
  }else{
    message("the containerid is not correct")
  }
  return(containerid)
}

container_exec <- function(containerid,command){
  # docker exec -it 9df70f9a0714 /bin/bash
  commandline <- glue::glue("docker exec -it {containerid} /bin/bash {command} ")
  message(glue::glue("info:: your command is {commandline},checking the containerid..."))
  allcontainer <-lscontainer()
  if (containerid %in% c( allcontainer$NAMES,allcontainer$`CONTAINER ID`,allcontainer$PORTS)){
    system(commandline)
  }else{
    message("the containerid is not correct")
  }
  return(containerid)
}

container_dockercompose <- function(yamlfile){
  if (file.exists(yamlfile)){
    system(command = glue::glue("docker-compose -f {yamlfile} up -d"))
  } else {
    message("yamlfile does not exist")
  }
}



  


