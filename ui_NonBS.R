
#pageWithSidebar(
fluidPage(
  title="Control diario de Cuotas - sardina común y anchoveta",
  titlePanel("Control diario de Cuotas - sardina común y anchoveta"),
  headerPanel(
    HTML('<td style="width: 100%"></td>
              
              <td style="width: 0%"></td>')
  ),
  sidebarPanel(
    HTML('   '),
    conditionalPanel(
      condition="input.tabselected==1",
        uiOutput("Recurso"),
        uiOutput("Zona")
    ),
    conditionalPanel(
      condition="input.tabselected==2",
      uiOutput("Recurso2"),
      uiOutput("Zona2"),
      uiOutput("Asignatario2")
    ),
    conditionalPanel(
      condition="input.tabselected==3",
      uiOutput("Recurso3"),
      uiOutput("Zona3")
      ),
  conditionalPanel(
    condition="input.tabselected==4"),
  
  HTML('
            <table style="width:100%">
                <tr>
                  <td style="width: 80%"> <center><img src="logo.png" scale height="250"/></center></td>
                </tr>
            </table>'),
  
  width = 2
  ),
  
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
                          Sernapesca.
                          <br><br>
                          <a href=http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas/ target=_new>http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas</a>
                          
                          <br><br><br>
Esta aplicacion se encuentra en desarrollo, para consultas escribir a Jorge Cornejo, jorge.cornejo[at]ifop.cl<br><br>
This shinyApp is under development, for question about it please contact Jorge Cornejo, jorge.cornejo[at]ifop.cl<br><br>

                        ')
                ), id = "tabselected"
    )
  ),
  # Footer
    HTML("<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><hr>
    Aplicación web para la visualizacion rápida de las cuotas y remanente de
      cuota de los recursos sardina común y anchoveta en la region del Biobío. <br>
      Aplicación preparada y distribuida como parte del proyecto 
         <a href='https://www.ifop.cl/safa' target=_new>SAFA</a>financiado por 
         <img src='logoIFOP.png' scale height='25'/> 
         <a href='http://www.ifop.cl/' target=_new>IFOP</a> y 
         <img src='logoGore.jpg' scale height='35'/>
       <a href='http://sitio.gorebiobio.cl/' target=_new>GORE Biobío</a>. 
    V0.2.0 2022/06"),
  HTML("<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src='https://www.googletagmanager.com/gtag/js?id=G-VRMRJVHGYZ'></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-VRMRJVHGYZ');
</script>")
  
)