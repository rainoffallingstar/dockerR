% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/container_updateparameter.R
\name{container_updateParameter}
\alias{container_updateParameter}
\title{Title
container_updateParameter
Description
update the Parameter during the runing of container}
\usage{
container_updateParameter(containerid, updateParameter)
}
\arguments{
\item{containerid}{the name of the container}

\item{updateParameter}{new parameter used to update the container}
}
\value{
str
}
\description{
Title
container_updateParameter
Description
update the Parameter during the runing of container
}
\examples{
container_updateParameter("rsshubnew","--restart=always")
}
