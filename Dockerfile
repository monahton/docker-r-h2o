# building a personal docker image to host all needed to run R scripts in the portable mode
# using official R base image in the beginning
# all personal R scripts will be based on this image
# dockerfile contains instructions to install all needed packages listed in a separate file

FROM rocker/r-base:latest

MAINTAINER 'Vladimir Zhbanko' vladimir.zhbanko@gmail.com

## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
libxml2-dev \
libcairo2-dev \
libsqlite3-dev \
libmariadbd-dev \
libpq-dev \
libssh2-1-dev \
unixodbc-dev \
libcurl4-openssl-dev \
libssl-dev

## Get Java (for h2o R package)
RUN apt-get update -qq \
  && apt-get -y --no-install-recommends install \
    cmake \
    default-jdk \
    default-jre \
  && R CMD javareconf

## create directories
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output

## copy files
COPY 02_code/install_packages.R /install_packages.R

## run the script on running container
RUN Rscript /install_packages.R
