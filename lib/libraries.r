library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(readr)
library(dplyr)
library(tibble)

library(XML)
library(rvest)
library(stringr)

library(digest)

library(readxl)
library(methods)
library(dplyr)
library(ggplot2)
library(ggmap)
library(data.table)
library(rgeos)
library(mosaic)
library(rgdal)
library(maptools)
library(tmap)
source("lib/uvozi.zemljevid.r",encoding="UTF-8")

options(gsubfn.engine="R")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")

