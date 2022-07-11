margen <- margin(-1,-1,-1,-1, "cm")
shinyServer(function(input, output, session) {
  

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
      output$Zona <- renderUI({
        selectInput('Zona', 'Zona', sort(unique(todo$Región)), selected = "VIII Región del Biobio")
      })
    }
    
    if (input$tabselected == 2)
    {
      output$Zona2 <- renderUI({
        selectInput('Zona2', 'Zona', sort(unique(todo$Región)), selected = "VIII Región del Biobio")
      })
      output$Asignatario2 <- renderUI({
        req(input$Zona2)
        asig <- filter(todo, Región == input$Zona2) 
        selectInput('Asignatario2', 'Asignatario', sort(asig$Asignatario))
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

  
  output$pieConjunto <- renderPlot({
    req(input$Zona)
    temp <- todo %>% 
      filter(Región == input$Zona) %>% 
      group_by(Región)  %>%
      summarise(quotaTotal = sum(`Cuota efectiva`),
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

  
### Este grafico hace el plot por asignatario desde de la zona
  output$graficoZonaEspecie <- renderPlot({
    req(input$Zona2)
    req(input$Asignatario2)
    temp <- filter(todo, Región == input$Zona2, Asignatario == input$Asignatario2)
    
    temp2 <- data.frame(
      value = c(temp$`Captura (T)`, temp$`Saldo (T)`),
      Referencia2 = c("Capturado", "Remanente") 
    )
    Referencia <- paste(temp2$Referencia2, round(temp2$value,1), '(t)')
    
    if(temp2$value[2]>0)
    {
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
    } else{
      temp
      ggplot(data=temp, aes(y = `Saldo (T)`, x=Asignatario)
      ) + 
        geom_bar(stat="identity", width=1, color="white") +
        theme_void() +
        scale_fill_brewer(palette="Set1") +
         theme(#plot.margin = margen,
               #strip.text.x = element_blank(),
               strip.background = element_rect(colour="white", fill="white"),
               legend.title=element_text(size=16, face = "bold"),
               legend.text=element_text(size=14),
               legend.position="bottom"
         ) +

      geom_text(x=1, y=temp$`Saldo (T)`/4, label="Considera Traspasos", size = 8) +
      geom_text(x=1, y=temp$`Saldo (T)`/3, label=paste("Cuota ", round(temp2$value[1],1), "(t)"), size = 8, col="blue") +
      geom_text(x=1, y=temp$`Saldo (T)`/2, label=paste("Captura a la fecha", round(sum(temp2$value[1], -1*temp2$value[2]),1), "(t)"), 
                 size = 8, col="red")  +
        geom_text(x=1, y=temp$`Saldo (T)`/1, label=paste("Captura a la fecha", round(sum(temp2$value[1], -1*temp2$value[2]),1), "(t)"), 
                  size = 8, col="red")  
      
    }
    

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
    print(temp)
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