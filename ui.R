
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
    # conditionalPanel(
    #   condition="input.tabselected==1",
    #   radioButtons("recurso", "Recurso:",
    #                c("Anchoveta" = "anch",
    #                  "Sardina" = "sard")),
    #   uiOutput("Zona"), 
    #   uiOutput("Asignatario")
    #   ),
    #conditionalPanel(
    #  condition="input.tabselected==2",
      radioButtons("recurso", "Recurso:",
                   c("Anchoveta" = "anch",
                     "Sardina" = "sard")),
      uiOutput("Zona"), 
      uiOutput("Asignatario")
    #)
    )
    
    ,
  mainPanel(
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",

                tabPanel("Cuota Remanente Regional", value = 1, 
                        plotOutput('pie')),
                tabPanel("Cuota Remanente Asignatario", value = 2, 
                        plotOutput('graficoZonaEspecie')
                         ),
                tabPanel("Tabla detalle Control Cuota", value = 3, 
                         dataTableOutput('tabla')),
                tabPanel("Datos", value = 4, HTML(
                  '<b>Origen de los Datos</b>:<br> 
                          Sernapesca
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
