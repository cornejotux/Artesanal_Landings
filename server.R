margen <- margin(-1,-1,-1,-1, "cm")
shinyServer(function(input, output, session) {
  
  recurso <- reactive({
    if(input$Recurso == "sard") {
      data <- ccSardina2
    } else {
      data <- ccAnchoveta2
    }
    data <- data %>% 
      select(-'...1', -Periodo) %>% 
      mutate(`% Consumido` = round((`% Consumido`*100), 1))
    return(data)
  })
  
  recurso2 <- reactive({
    if(input$Recurso2 == "sard") {
      data2 <- ccSardina2
    } else {
      data2 <- ccAnchoveta2
    }
    data2 <- data2 %>% 
      select(-'...1', -Periodo) %>% 
      mutate(`% Consumido` = round((`% Consumido`*100), 1))
    return(data2)
  })
  
  recurso3 <- reactive({
    if(input$Recurso3 == "sard") {
      data <- ccSardina2
    } else {
      data <- ccAnchoveta2
    }
    data <- data %>% 
      select(-'...1', -Periodo) %>% 
      mutate(`% Consumido` = round((`% Consumido`*100), 1))
    return(data)
  })
  
  #################
  observeEvent(input$tabselected, {
    if (input$tabselected == 1)
    {
      output$Recurso <- renderUI({
        radioButtons("Recurso", "Recurso:",
                     c("Anchoveta" = "anch",
                       "Sardina" = "sard"))
      })
      output$Zona <- renderUI({
        req(input$Recurso)
        selectInput('Zona', 'Zona', sort(unique(recurso()$Región)), selected = "VIII Región del Biobio")
      })
    }
    
    if (input$tabselected == 2)
    {
      output$Recurso2 <- renderUI({
        radioButtons("Recurso2", "Recurso:",
                     c("Anchoveta" = "anch",
                       "Sardina" = "sard"))
      })
      output$Zona2 <- renderUI({
        req(input$Recurso2)
        selectInput('Zona2', 'Zona', sort(unique(recurso2()$Región)), selected = "VIII Región del Biobio")
      })
      output$Asignatario2 <- renderUI({
        req(input$Zona2)
        asig <- filter(recurso2(), Región == input$Zona2) 
        selectInput('Asignatario2', 'Asignatario', sort(asig$Asignatario), selected = asig$Asignatario[1])
      })
    }
    
    if (input$tabselected == 3)
    {
      output$Recurso3 <- renderUI({
        radioButtons("Recurso3", "Recurso:",
                     c("Anchoveta" = "anch",
                       "Sardina" = "sard"))
      })
      output$Zona3 <- renderUI({
        req(input$Recurso3)
        selectInput('Zona3', 'Zona', sort(unique(recurso3()$Región)), selected = "VIII Región del Biobio")
      })
    }
  })
  ################
  
  ## Grafico de resumen de la cuota en cada region
  
  output$pie <- renderPlot({
    req(input$Recurso)
    req(input$Zona)
    temp <- recurso() %>% 
      filter(Región == input$Zona) %>% 
      group_by(Región)  %>%
      summarise(quotaTotal = sum(recurso()[6]),
                capturaTotal = sum(`Captura (T)`),
                remanente = sum(`Saldo (T)`))
    print(temp)
    temp2 <- data.frame(
      value=c(temp$capturaTotal, temp$remanente),
      Referencia2=c("Capturado", "Remanente"))
    Referencia <- paste(temp2$Referencia2, round(temp2$value,0), '(t)')
    ggplot(data=temp2, aes(y = value, x="", fill=Referencia)) + 
      geom_bar(stat="identity", width=1, color="white") +
      coord_polar("y") +
      theme_void() +
      scale_fill_brewer(palette="Set1") +
      theme(plot.margin = margen,
            strip.text.x = element_blank(),
            strip.background = element_rect(colour="white", fill="white"),
            legend.title=element_text(size=16, face = "bold"),
            legend.text=element_text(size=14),
            legend.position=c(0.3,0.8)
      ) +
      geom_text(x=0.3, y=0.3, label="Considera Traspasos", size = 8)
  }) 
  
  output$graficoZonaEspecie <- renderPlot({
    req(input$Recurso2)
    req(input$Zona2)
    req(input$Asignatario2)
    
    temp <- filter(recurso2(), Región == input$Zona2, Asignatario == input$Asignatario2)
    
    temp2 <- data.frame(
      value = c(temp$`Captura (T)`, temp$`Saldo (T)`),
      Referencia2 = c("Capturado", "Remanente") 
    )
    Referencia <- paste(temp2$Referencia2, round(temp2$value,1), '(t)')
    ggplot(data=temp2, aes(y = value, x="", fill=Referencia)) + 
      geom_bar(stat="identity", width=1, color="white") +
      coord_polar("y", start=0) +
      theme_void() +
      scale_fill_brewer(palette="Set1") +
      theme(plot.margin = margen,
            strip.text.x = element_blank(),
            strip.background = element_rect(colour="white", fill="white"),
            legend.title=element_text(size=16, face = "bold"),
            legend.text=element_text(size=14),
            legend.position=c(0.3,0.8)
      )+
      geom_text(x=0.3, y=0.3, label="Considera Traspasos", size = 8)
  }) #,  height = 600, width = 600 )
  
  ## Presentacion de la tabla del control cuota.    
  output$tabla <- renderDataTable({
    req(input$Recurso3)
    req(input$Zona3)
    temp <- filter(recurso3(), Región == input$Zona3) %>% 
      select(-c(Región)) %>% #, `Cargos Por excesos`)) %>% 
      mutate(`Cuota Asignada` = round(`Cuota Asignada`, 0),
             `Cuota efectiva` = round(`Cuota efectiva`, 0),
             `Captura (T)` = round(`Captura (T)`, 1),
             `Saldo (T)` = round(`Saldo (T)`, 1)
      )
    DT::datatable(temp,
                  caption = paste('Tabla detalle del control cuota por asignatario en', input$Zona),
                  class = 'cell-border stripe', 
                  filter = 'top',
                  extensions = 'Buttons',
                  fillContainer = FALSE, 
                  options = list(
                    language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'),
                    pageLength = 25, 
                    autoWidth = TRUE,
                    dom = 'Bfrtip',
                    buttons = 
                      list('copy', 'print', list(
                        extend = 'collection',
                        buttons = c('csv', 'excel', 'pdf'),
                        text = 'Download')),
                    scrollX = TRUE, 
                    selection="multiple"
                  ))
  })
  
  
})