### dockerR

<img src="https://github.com/rainoffallingstar/dockerR/blob/master/dev/logo_ny.png" height="200" align="right"/>

This is an R package wirtten for managing docker images and containers under R, warping most the docker cli commands.

install by:

``` r
pak::pak("rainoffallingstar/dockerR")
```

#### Dependences(now & future)

-   docker
-   docker compose
-   podman(support by parameter {"use_podman = TRUE"})

#### Feature

-   %\>% pipline eg. image_rmi("diygod/rsshub") %\>% image_pull() %\>% image_tag("fall/rsshub").

-   Full workflow with docker image pull,container creatation, container control and container update.

-   docker compose supoort.

#### Functions

-   lscontainer : list all the containers

-   lsimage : list all the images

-   image_rmi : remove imges

-   image_pull : pull images

-   image_tag : change the tags of image

-   image_build : build an image from dockerfile

-   image_push: push build images to dockerhub

-   image_save : save images as tar format

-   image_load: load/import image from a tar file

-   container_run : run/create a container with all parameters

-   container_control: control the statue of containers by stop, start ,restart and delete(rm)

-   container_update : update the container when the upstream image changes

-   container_updateParameter : update the parameter of a running container

-   container_exec : run commands inside the container

-   container_dockercompose: run/initial a container by a yaml file with docker compose

-   docker_info: show docker info

-   docker_version : show docker version

-   docker_stats: show container stats under running

#### Tips

-   How to schdule a rscript in windows

    > by run the following commands in the terminal

    ``` bash
    schtasks /create /tn "Run R Script at 6 AM" /tr "C:\Program Files\R\R-4.3.3\bin\x64\Rscript.exe D:\fallingstarGitcode\dockerR\dev\example\container-autoupdate.R" /sc daily /st 06:00
    ```

#### RoadMap

-   clean the code (a bit mass now but runs well ,lol)

-   better test examples

-   more features with the docker cli commands
