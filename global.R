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



url <- "http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas"

library(RCurl)
library(XML)

doc.raw <- getURL(url)

a <- str_split(doc.raw, "Pelágicos - Anchoveta-Sardina Común V-X")[[1]][1]

aa <- str_split(a, "16_cuota_anchoveta-sardina_comun_v-x_2022")[[1]][2]
aa3 <- str_split(aa, ".xlsx")[[1]][1]

xlsUrl <- paste("http://www.sernapesca.cl/sites/default/files/16_cuota_anchoveta-sardina_comun_v-x_2022", 
                aa3, ".xlsx", sep="")

archivo <- paste('16_cuota_anchoveta-sardina_comun_v-x_2022', aa3, '.xlsx', sep="")

if (!file.exists(paste(aa3, ".xlsx", sep="")))
{
  download.file(xlsUrl, paste(aa3, ".xlsx", sep=""), mode="wb")
}

ccAnchoveta <- read_excel(paste(aa3, ".xlsx", sep=""), sheet = "Anchoveta", skip = 2)

ccAnchoveta2 <- ccAnchoveta %>% 
    filter(!is.na(...1)) %>%
    mutate(Asignatario = tolower(Asignatario)) %>% 
    filter(!grepl("cuota residual",Asignatario)) %>% 
    mutate(Asignatario = gsub("asociación gremial de", "ag", Asignatario), 
           Asignatario = gsub("asociación gremial", "ag", Asignatario),
           Asignatario = gsub("asociacion gremial", "ag", Asignatario),
           Asignatario = gsub("sindicato  de trabajadores  independientes", "sti", Asignatario),
           Asignatario = gsub("sindicato de trabajadores independientes", "sti", Asignatario),
           #Asignatario = gsub("asociacion gremial", "ag", Asignatario),
           
            Movimiento = ifelse(is.na(Movimiento), 0, Movimiento),
           `Captura (T)` = ifelse(is.na(`Captura (T)`), 0, `Captura (T)` ),
           `Cargos Por excesos` = ifelse(is.na(`Cargos Por excesos`), 0, `Cargos Por excesos`),
            Cierre = ifelse(Cierre == "-", "", Cierre),
            Cierre = as.Date(as.numeric(Cierre), origin =  "1899-12-30"))

for (i in 2:length(ccAnchoveta2$Región))
{
  if(is.na(ccAnchoveta2$Región[i])) ccAnchoveta2$Región[i] <- ccAnchoveta2$Región[i-1]
}


ccSardina <- read_excel(paste(aa3, ".xlsx", sep=""), sheet = "Sardina comun", skip = 2)

ccSardina2 <- ccSardina %>% 
  filter(!is.na(...1)) %>%
  mutate(Asignatario = gsub("asociación gremial de", "ag", Asignatario), 
         Asignatario = gsub("asociación gremial", "ag", Asignatario),
         Asignatario = gsub("asociacion gremial", "ag", Asignatario),
         Asignatario = gsub("sindicato  de trabajadores  independientes", "sti", Asignatario),
         Asignatario = gsub("sindicato de trabajadores independientes", "sti", Asignatario),
         #Asignatario = gsub("asociacion gremial", "ag", Asignatario),
          Movimiento = ifelse(is.na(Movimiento), 0, Movimiento),
         `Captura (T)` = ifelse(is.na(`Captura (T)`), 0, `Captura (T)` ),
         `Cargos por exceso` = ifelse(is.na(`Cargos por exceso`), 0, `Cargos por exceso`),
         Cierre = ifelse(Cierre == "-", "", Cierre),
         Cierre = as.Date(as.numeric(Cierre), origin =  "1899-12-30"))

for (i in 2:length(ccSardina2$Región))
{
  if(is.na(ccSardina2$Región[i])) ccSardina2$Región[i] <- ccSardina2$Región[i-1]
}

# ggplot(data=controlCuota, aes(y = Porcentaje, x = Organización_titular_area)) +
#   geom_col()



temp <- ccAnchoveta2 %>% 
  filter(Región == "VIII Región del Biobio")



