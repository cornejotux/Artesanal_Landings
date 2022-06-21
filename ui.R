bootstrapPage(
  theme  = bs_theme(version = 5, bootswatch = "minty"), 
  div(class="container-fluid",
      div(class="text-center text-lg-start",
          h2(TITULO, class="d-none d-lg-block"),
          h3("Control Cuota", class="d-block d-lg-none")
      ),
      div(class="row",
          div(class="col-lg-3",
              div(class="well",
                  #sidebarPanel(
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
                  div(HTML('
            <table style="width:100%">
                <tr><td style="width: 80%"> <center><img src="logo.png" scale height="150"/></center></td></tr>
            </table><br><br><br><br>'), class="d-none d-lg-block")
              )),
          div(class="col-lg-9", 
                          tabsetPanel(type = "tabs",
                                      
                                      tabPanel("Regional", value = 1,
                                               plotOutput('pie')),
                                      tabPanel("Asignatario", value = 2, 
                                               plotOutput('graficoZonaEspecie')),
                                      tabPanel("Tabla", value = 3, 
                                               dataTableOutput('tabla')),
                                      tabPanel("Datos", value = 4, 
                                        HTML('<br>Datos obenitodos desde pagina del <b>Sernapesca</b> actualizados al '),
                                        HTML(paste(lubridate::ymd(as.numeric(str_replace(aa3, "_", ""))))),
                                    
                                        HTML('disponibles en el link del servicio: <a href=http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas/ target=_new>http://www.sernapesca.cl/informacion-utilidad/consumo-de-cuotas</a>
                                              <br><br><br>
                                              Esta aplicación se encuentra en desarrollo, para consultas 
                                              escribir a Jorge Cornejo, jorge.cornejo[at]ifop.cl<br><br>
                                            ')
                                      ), id = "tabselected"
                                      
              )
          )
      )
      ,
      
      # Footer
      div(
        hr(),
        HTML("Aplicación para la observación de datos SAFA, disponible en servidor de
    <a href='http://caleuche.ifop.cl/' target=_new>IFOP Sede Talcahuano</a><br>"),
        HTML("Creado en <a href='https://shiny.rstudio.com/' target=_new>Shiny</a>
        por <a href='http://www.ifop.cl/safa' target=_new>SAFA</a>
        (safa[at]ifop.cl), financiado por <img src='logoIFOP.png' scale height='25'/>
        <a href='http://www.ifop.cl/' target=_new>IFOP</a> y <img src='logoGore.jpg' scale height='35'/>
        <a href='http://sitio.gorebiobio.cl/' target=_new>GORE Biobío</a>. <br>
     V1.0 2022/06"), 
        class="d-none d-lg-block"),
      HTML("<!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src='https://www.googletagmanager.com/gtag/js?id=G-VRMRJVHGYZ'></script>
        <script>
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
        
          gtag('config', 'G-VRMRJVHGYZ');
        </script>")
      ))

