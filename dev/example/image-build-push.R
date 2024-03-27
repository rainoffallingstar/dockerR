library(dockerR)
dockerR::image_build("fallingstar10/gmadeomicsrocker:base","./dev/example/gmade_rocker-base") %>%
  dockerR::image_push(username = "fallingstar10")
