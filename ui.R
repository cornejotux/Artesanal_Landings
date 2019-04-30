
#pageWithSidebar(
fluidPage(
    title="Explorador de Desembarcos Artesanales",
    #theme = shinytheme("flatly"),
    headerPanel(
        HTML('<td style="width: 100%"></td>
              
              <td style="width: 0%"></td>')
    ),
    sidebarPanel(
        HTML('
             '),
        conditionalPanel(
          condition="input.tabselected==1",uiOutput("Region"), uiOutput("Provincia"),uiOutput("Caleta"),uiOutput("Especies"), uiOutput("sliderYear")
         ),
         conditionalPanel(
          condition="input.tabselected==2", uiOutput("Especies2"), uiOutput("sliderYear2")
          ),
        conditionalPanel(
          condition="input.tabselected==3", uiOutput("Region3"), uiOutput("sliderYear3")
        )
        

        ),
    mainPanel(
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    tabPanel("Mean Length", value = 1, 
                             plotOutput('plotRegionSp')),
                    tabPanel("By Regions", value = 2, 
                             plotOutput('plotAllRegions')),
                    tabPanel("By Species", value = 3, 
                             plotOutput('plotAllSpecies')),
                    tabPanel("Info", value = 4, HTML(
                        '<b>Origen de los Datos</b>:<br> 
                          Sernapesca!.
                          
Esta aplicacion se encuentra en desarrollo, para consultas escribir a Jorge Cornejo, cornejotux[at]gmail.YouKnowTheRest <br><br>
This shinyApp is under development, for question about it please contact Jorge Cornejo, cornejotux[at]gmail.YouKnowTheRest.

                        ')
                        ), id = "tabselected"
                    )
        )
    )
