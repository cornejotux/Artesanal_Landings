## Author: Jorge F. Cornejo
## Date: Jan 24, 2018
## Goal: Create an intereactive presentation to show how
##       escapment have changed over time at the SASAP.Region level

##### This section download the data from KNB and prepare it for Shiny app
rm(list=ls())


library(dplyr)
library(tidyr)

#library(data.table)
#require(lubridate)
#require(ggplot2)
#require(ggjoy)
#require(scales)
#library(ggthemes)
#library(shinythemes)
#library(Hmisc)
#library(mgcv)

#### Aqui preparo los datos para que sean depues usados en el Shiny
#### Esta seccion solo se usar ahora y luego se mantiene comentada
# library(readxl)
# require(janitor)
# 
# caletas <- read_excel("data/SIAC 460107519.xlsx", skip = 1)
# caletas <- caletas %>% 
#   clean_names() %>% 
#   select(-total) %>% 
#   gather(mes, captura, 7:18) %>% 
#   na.omit(captura)

# Se lee todo el ambiente, incluendo los datos de las caletas.
load(file="data/data.RData")


selectYears <- function(data=caletas)
{
    minY <- min(caletas$ano, na.rm = T)
    maxY <- max(caletas$ano, na.rm = T)
    output <- c(minY, maxY)
    return(output)
}

sp <- c("chinook", "coho", "chum", "pink", "sockeye")
tab <<- 0
S <<- 'JAIBA PELUDA O PACHONA'
R <<- "1"
