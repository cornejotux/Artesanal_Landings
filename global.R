## Author: Jorge F. Cornejo
## Date: Jan 24, 2018
## Goal: Create an intereactive presentation to show how
##       escapment have changed over time at the SASAP.Region level

##### This section download the data from KNB and prepare it for Shiny app
rm(list=ls())


library(dplyr)
library(tidyr)
require(ggplot2)
require(lubridate)


#library(data.table)
#require(lubridate)

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
# caletas <- read_excel("c:/Users/jorge.cornejo/Google Drive/Projecto ERE/SIAC 460107519.xlsx", skip = 1)
# caletas <- caletas %>%
#   clean_names() %>%
#   gather(mes, captura, 7:18) %>%
#   na.omit(captura) %>%
#   mutate(mes=replace(mes, mes=="ene", 1)) %>% 
#   mutate(mes=replace(mes, mes=="feb", 2)) %>% 
#   mutate(mes=replace(mes, mes=="mar", 3)) %>% 
#   mutate(mes=replace(mes, mes=="abr", 4)) %>% 
#   mutate(mes=replace(mes, mes=="may", 5)) %>% 
#   mutate(mes=replace(mes, mes=="jun", 6)) %>% 
#   mutate(mes=replace(mes, mes=="jul", 7)) %>% 
#   mutate(mes=replace(mes, mes=="ago", 8)) %>% 
#   mutate(mes=replace(mes, mes=="sep", 9)) %>% 
#   mutate(mes=replace(mes, mes=="oct", 10)) %>% 
#   mutate(mes=replace(mes, mes=="nov", 11)) %>% 
#   mutate(mes=replace(mes, mes=="dic", 12)) %>% 
#   mutate(ano = as.Date(paste(ano, mes, "01",sep="-"), "%Y-%m-%d")) %>% 
#   select(-total, -mes)


# Se lee todo el ambiente, incluendo los datos de las caletas.
load(file="data/data.RData")

# caletas <- caletas %>%
#   group_by(region, provincia, comuna, caleta, especie, ano=year(ano)) %>%
#   summarize(captura=sum(captura)) #%>% 
#   #rename(ano=year(ano), captura=sum(captura))
# 
# regiones <- read.csv(file="c:/Users/jorge.cornejo/Downloads/regiones.csv", sep=";")
# names(regiones) <- c("region", "nombre")
# regiones$nombre <- c("Tarapacá", "Antofagasta", "Atacama", "Coquimbo", "Valparaíso", 
#                      "Libertador General Bernardo O’Higgins", "Maule", "Concepción", "La Araucania",
#                      "Los Lagos", "Aysén del General Carlos Ibañez del Campo", "Magallanes y de la Antártica Chilena", 
#                      "Los Rios", "Arica y Parinacota", "Ñuble")
# caletas <- left_join(caletas, regiones)
# rm(regiones)


## Nombre de las regiones



selectYears <- function(data=caletas)
{
    minY <- min(caletas$ano, na.rm = T)
    maxY <- max(caletas$ano, na.rm = T)
    output <- c(minY, maxY)
    return(output)
}

#sp <- c("chinook", "coho", "chum", "pink", "sockeye")
tab <<- 0
S <<- 'ALMEJA'
R <<- "Concepción"
Provincia <<- "Arauco"
