---
title: "Using Docker images with NextFlow"
date: 2022-09-20T10:15:45+01:00
draft: false
---

Bioinformatics pipelines are often difficult to reproduce, consisting of a mixture of Bash executions and scripting, involving the use of modules and libraries with large lists of dependencies.

The problem of reproducibility has come more sharply into focus as science consists increasingly of analyses of large-scale data sets. In the short history of the field of Bioinformatics, it has been common practice for pipelines to be constructed as large, indecipherable and sparsely documented shell scripts.

Enter workflow managers and Docker. My preference in this regard has been to use the [Nextflow](https://www.nextflow.io/) framework, which allows seemless integration of software containers. To build a Docker container image for a NextFlow pipeline, we simply create a `Dockerfile` in the project's main directory. This file contains the instructions that Docker will use to build the image required to run the pipeline; everything from the base distribution used to the software and packages required. Below is an example Dockerfile that I constructed for the [StrainSeq pipeline](https://github.com/adamd3/StrainSeq/). OpenSource have an excellent set of tips [here](https://opensource.com/article/20/5/optimize-container-builds) for optimising container builds. You can also find best practices for the formatting of the Dockerfile file [on the Docker website](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

```dockerfile
FROM ubuntu:22.04
LABEL maintainer="Adam Dinan <adam1989ie@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

ADD https://raw.githubusercontent.com/adamd3/StrainSeq/main/requirements.txt .

# Requirements file for pip installation
COPY requirements.txt /tmp
WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates \
        curl libssl-dev libcurl4-openssl-dev libxml2-dev \
        python3-numpy python3-pip gawk pigz r-base-dev fastqc \
        trim-galore kallisto && \
    apt-get clean autoclean

# Install Python modules
RUN pip install --no-cache-dir -r requirements.txt

# Set repo for R package installation
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.rstudio.com'; \
    options(repos = r);" > ~/.Rprofile

# Install R libraries
RUN R -e 'install.packages(c(  \
    "optparse", "RColorBrewer", "reshape2", "ggplot2", "tidyr",  \
    "scales", "pheatmap", "matrixstats", "umap", "BiocManager"))'

# Install Bioconductor packages
RUN R -e 'BiocManager::install(c("edgeR", "DESeq2"))'
```

To summarise, the `FROM` statement indicates the base container (e.g. an OS image), which will be pulled if not locally available. Ideally, the base OS should be as small as possibly while retaining functionality. Ubuntu is a solid choice because they provide minimal versions of the OS as Docker images (these exclude unnecessary documentation, editors, etc.), and this reduces the size of the standard server image by 50%. Alpine Linux is even more minimilistic and is another good option. For a debian-based OS, we can disable interactive installation of necessary software by setting `DEBIAN_FRONTEND=noninteractive` with the `ARG` statement.

The `RUN` statement can be used to execute shell commands. Environment variables, similar to regular Bash variables, can be defined using the `ENV` statement, and `ENTRYPOINT` is the instruction used to define the command to be executed when the container is started; arguments can be provided by appending them to the call to `docker run` after building. Default parameters can be specified with the `CMD` statement, and these can be overridden by appending arguments to `docker run`. Exhaustive documentation for more complex functionality is available [on Docker Docs](https://docs.docker.com/engine/reference/builder/).

To minimise the size of the container, it's also good practice to clean up the cache with a command such as `apt-get clean` when done installing programs. When using Ubuntu, you can also remove unnecessary files created by `apt-get`, such as those in `/var/lib/apt/lists/`, which just stores information on packages and is downloaded which each call to `apt-get update`.

In the specific case of R, it's important to note that many bioinformatics packages are housed in the specialised Bioconductor repository, and hence are not installable through a standard call to a function such as `install.packages` in R.
Such packages can be installed by first installing the `BiocManager` package from CRAN (as below), and then including a separate call to `BiocManager::install`. By setting `ask = TRUE`, we also automate the installation of updates non-interactively.

Before building, make sure that you have a registered account at [Docker Hub](https://hub.docker.com/). Build the image like so: `docker build -t adamd3/strainseq .`, which allows you to also tag the Docker Hub repo, and then test using `docker run -ti strainseq`. Try loading any of the Python modules or R packages to see that it worked OK.

When you're ready, push the Dockerfile to Docker Hub.
