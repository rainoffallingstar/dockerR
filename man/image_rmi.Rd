% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/image_rmi.R
\name{image_rmi}
\alias{image_rmi}
\title{Title
image_rmi
Description
remove images}
\usage{
image_rmi(id, use_podman = FALSE)
}
\arguments{
\item{id}{the image id ,str}

\item{use_podman}{logit, use podman as  backend when it is TRUE}
}
\value{
str
}
\description{
Title
image_rmi
Description
remove images
}
\examples{
image_rmi("frooodle/s-pdf:latest")
}
