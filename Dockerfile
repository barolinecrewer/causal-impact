FROM rocker/shiny:4.4.1

# System libs for common R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CRAN packages used by the app
RUN R -e "install.packages(c('shiny', 'ggplot2', 'lubridate', 'zoo', 'dplyr', 'remotes'), repos = 'https://cloud.r-project.org')"

# Install CausalImpact from GitHub
RUN R -e "remotes::install_github('google/CausalImpact')"

# Put the app at the Shiny Server root so it serves at /
WORKDIR /srv/shiny-server
COPY app.R /srv/shiny-server/app.R

# Shiny Server default port
EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
