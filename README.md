### dockerR



This is an R package wirtten for managing docker images and containers under R, warping most the docker cli commands.

install by:

<img src="https://gitee.com/rainoffallingstar/rainoffallingstar/blob/mydraft/_imgbed/logo_ny.png" height="200" align="right"/>

``` r
pak::pak("rainoffallingstar/dockerR")
```

#### Dependences(now & future)

-   docker
-   docker compose
-   podman(not support yet)

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

    ```         
    ```

#### RoadMap

-   clean the code (a bit mass now but runs well ,lol)

-   better test examples

-   more features with the docker cli commands

-   support for podman