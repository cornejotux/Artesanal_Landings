
#pageWithSidebar(
fluidPage(
  title="Control diario de Cuotas - Sardina y Anchoveta",
  #theme = shinytheme("flatly"),
  headerPanel(
    HTML('<td style="width: 100%"></td>
              
              <td style="width: 0%"></td>')
  ),
  sidebarPanel(
    HTML('
             '),
    #conditionalPanel(
    #  condition="input.tabselected==1",
    uiOutput("Zona"), 
    uiOutput("Asignatario"),
    #)
    #,
    # conditionalPanel(
    #  condition="input.tabselected==2", uiOutput("Especies2"), uiOutput("sliderYear2")
    #  ),
    #conditionalPanel(
    #  condition="input.tabselected==3", uiOutput("Region3"), uiOutput("sliderYear3")
    )
    
    ,
  mainPanel(
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",
                #tabPanel("Tabla", value = 1, 
                #         dataTableOutput('tableZonaEspecie')),
                tabPanel("Grafico", value = 2, 
                         plotOutput('graficoZonaEspecie')
                         ),
                tabPanel("Info", value = 3, HTML(
                  '<b>Origen de los Datos</b>:<br> 
                          Sernapesca!
                          <br><br>
                          <a href=http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas/ target=_new>http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas</a>
                          
                          <br><br><br>
Esta aplicacion se encuentra en desarrollo, para consultas escribir a Jorge Cornejo, jorge.cornejo[at]ifop.cl<br><br>
This shinyApp is under development, for question about it please contact Jorge Cornejo, jorge.cornejo[at]ifop.cl<br><br>

                        ')
                ), id = "tabselected"
    )
  )
)
