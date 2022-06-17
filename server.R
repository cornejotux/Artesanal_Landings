tab <- 0


library(shiny)
shinyServer(function(input, output, session) {
  
  recurso <- reactive({
    if(input$recurso == "sard") data <- ccSardina2
    if(input$recurso == "anch") data <- ccAnchoveta2
    data <- data %>% 
      select(-'...1', -Periodo) %>% 
      mutate(`% Consumido` = round((`% Consumido`*100), 1))
    return(data)
  })
    
  output$Zona <- renderUI({
    req(input$recurso)
    selectInput('Zona', 'Zona', sort(unique(recurso()$Región)), selected = "VIII Región del Biobio")
  })
  
  searchResults2 <- reactive({
    sort(unique(filter(recurso(), Región == input$Zona))$Asignatario)
  })
  
  output$Asignatario <- renderUI({
    req(input$Zona)
    selectInput('Asignatario', 'Aignatario', searchResults2(), selected = "")
  })

  output$Grupo <- renderUI({
    req(input$Zona)
    selectInput('Zona', 'Zona', sort(unique(recurso()$Región)), selected = "VIII Región del Biobio")
  })
  
  
   
    output$tabla <- renderDataTable({
        req(input$Zona)
         temp <- filter(recurso(), Región == input$Zona) %>% 
           select(-c(Región, `Cargos Por excesos`))
         DT::datatable(temp,
                   caption = paste('Table detalle del control cuota por asignatario en', input$Zona),
                   class = 'cell-border stripe', 
                   filter = 'top',
                   extensions = 'Buttons',
                   fillContainer = FALSE, 
                   options = list(pageLength = 25, 
                                  autoWidth = TRUE,
                                  dom = 'Bfrtip',
                                  buttons = c('Copia', 
                                              'Imprimir'), 
                                  scrollX = TRUE, 
                                  selection="multiple"
                   ))
     },  height = 600, width = 600 )
    
    
    datatable(temp,
              caption = 'Table detalle del control cuota por asignatario.',
              class = 'cell-border stripe', 
              filter = 'top',
              extensions = 'Buttons',
              fillContainer = FALSE, 
              options = list(pageLength = 10, 
                             autoWidth = TRUE,
                             dom = 'Bfrtip',
                             buttons = c('copy', 
                                         'print'), 
                             scrollX = TRUE, 
                             selection="multiple"
              ))
    
    
    output$graficoZonaEspecie <- renderPlot({
      req(input$Zona)
      temp <- filter(recurso(), Región == input$Zona, Asignatario == input$Asignatario)
      temp2 <- data.frame(
              value = c(temp$`Captura (T)`, temp$`Saldo (T)`),
              Referencia = c("Capturado", "Remanente") 
      )
      ggplot(data=temp2, aes(y = value, x="", fill=Referencia)) + 
              geom_bar(stat="identity", width=1, color="white") +
              coord_polar("y", start=0) +
              theme_void() +
        geom_text(aes(x=factor(1), y=value, label=paste(Referencia, floor(value), '(t)'), ymax=value), 
                  position="identity"
                  ) +
          scale_fill_brewer(palette="Set1") +
        ggtitle(input$Asignatario) +
        theme(plot.title = element_text(size=16))
        },  height = 600, width = 600 )
    
    
    
    ## Grafico de resumen de la cuota en cada region
    
    output$pie <- renderPlot({
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
                            Referencia=c("Capturado", "Remanente"))
        
      ggplot(data=temp2, aes(y = value, x="", fill=Referencia)) + 
        geom_bar(stat="identity", width=1) +
        coord_polar("y") +
        theme_void() +
      geom_text(aes(x=factor(1), y=value, label=paste(Referencia, floor(value), '(t)'), ymax=value), 
                position="identity"
      ) +
        scale_fill_brewer(palette="Set1")+
        ggtitle(input$Zona) +
        theme(plot.title = element_text(size=16))
    },  height = 600, width = 600 ) 
    
    
    
  })
  
#})