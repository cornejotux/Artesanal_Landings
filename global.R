## Author: Jorge F. Cornejo
## Fecha: 25 de Junio 2021
## Objetivo: Toma el registro de los desembarque de sardina y anchoveta
##           y los pone en una tabla de registro de cuotas

##### Lo primero que hacemos es descargar los datos desde el sernapesca
##### Para luego procesarlos y trabajar en la plataforma del Shiny
rm(list=ls())

library(dplyr)
library(tidyr)
require(ggplot2)
require(lubridate)
library(readxl)
library(stringr)
library(DT)


#library(ggthemes)
#library(shinythemes)

#### Aqui preparo los datos para que sean depues usados en el Shiny
#### Esta seccion solo se usar ahora y luego se mantiene comentada

today()
ff <- str_remove_all(today()-1, "-")

ff <- str_remove_all(today()-2, "-")
url <- paste("http://www.sernapesca.cl/sites/default/files/16_cuota_anchoveta-sardina_comun_v-x_", ff, ".xlsx", sep = "")


download.file(url=url, destfile = "controlCuota.xlsx")

controlCuota <- read_excel("controlCuota.xlsx", sheet="Compilado")
controlCuota$Recurso <- ifelse(controlCuota$Recurso == "SArdina común", "Sardina común", controlCuota$Recurso)
controlCuota <- filter(controlCuota, Organización_titular_area != "Organización_titular_area")

# ggplot(data=controlCuota, aes(y = Porcentaje, x = Organización_titular_area)) +
#   geom_col()

