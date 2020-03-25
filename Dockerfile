FROM gcr.io/cloud-datalab/datalab:latest

ENV R_BASE_VERSION 3.6.3
RUN pip install jupyter && \
    echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list && \
    echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default && \
    apt-get update && \
    apt-get install -y  -t unstable --no-install-recommends --allow-unauthenticated \
      file \
      libssh2-1-dev \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
      littler \
      r-cran-littler \
      r-base=${R_BASE_VERSION}* \
      r-base-dev=${R_BASE_VERSION}* \
      r-recommended=${R_BASE_VERSION}* && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
    ln -sf /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
    ln -sf /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -sf /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
    ln -sf /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
    install.r docopt && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm -rf /var/lib/apt/lists/* && \
    R -e 'install.packages("devtools")' && \
    R -e 'install.packages("googleAuthR"); library(googleAuthR); gar_gce_auth()' && \
    R -e 'install.packages("bigQueryR"); install.packages("googleCloudStorageR")' && \
    R -e 'install.packages("feather")' && \
    R -e 'install.packages("tensorflow")' && \
    R -e 'devtools::install_github("apache/spark@v2.2.0", subdir="R/pkg")' && \
    R -e 'devtools::install_github("IRkernel/IRkernel")' && \
    R -e 'IRkernel::installspec(user = FALSE)'
