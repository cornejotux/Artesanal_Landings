tab <- 0


library(shiny)
shinyServer(function(input, output, session) {
  
  #observeEvent(input$tabselected, {
    #if (input$tabselected == 1)
      #output$recurso <- renderUI({
      #  selectInput('Recurso', 'Recurso', sort(unique(controlCuota$Recurso)), selected = "Anchoveta")
      #})
    #searchResult2 <- reactive({
    #  sort(unique(filter(controlCuota, zona == input$Zona)$provincia ))
    #    })
    
    
   # print(output$recurso)
   
  output$Zona <- renderUI({
    selectInput('Zona', 'Zona', sort(unique(controlCuota$Zona)))
  })
  
  
  
  output$Recurso <- renderUI({
    selectInput('Recurso', 'Recurso', sort(unique(controlCuota$Recurso)))
  })
  
  
  output$Recurso <- renderUI({
    selectInput('Recurso', 'Recurso', sort(unique(controlCuota$Recurso)), 
                selected = NULL)
  })
  searchResult2 <- reactive({
    sort(unique(filter(controlCuota, Recurso == input$Recurso)$Zona ))
  })
  output$Zona <- renderUI({
    req(input$Recurso)
    selectInput("Zona", "Zona", searchResult2(), selected = "VIII")
  })
  
  searchResult3 <- reactive({
    sort(unique(filter(controlCuota, Recurso == input$Recurso, Zona == input$Zona)$Organización_titular_area))
  })
  output$Organizacion <- renderUI({
    req(input$Recurso)
    selectInput("Organizacion", "Organizacion", searchResult3(), selected = NULL)
  })
  
  
   
    output$tableZonaEspecie <- renderDataTable({
      #datatable(controlCuota)
        temp <- filter(controlCuota, Recurso == input$Recurso, Zona == input$Zona)
        DT::datatable(select(temp, -Periodo_inicio, -periodo_final, -Comentario, 
                             -Preliminar, -año)
        )
    },  height = 700, width = 600 )
    
    output$graficoZonaEspecie <- renderPlot({
      #datatable(controlCuota)
      temp <- filter(controlCuota, Recurso == input$Recurso, Zona == input$Zona)
      ggplot(data=temp, aes(y = Porcentaje, x = Organización_titular_area)) + 
        geom_col() + theme(axis.text.x=element_text(angle = 45))
    },  height = 1000, width = 800 )
    
    
  })
  
 # observeEvent(input$tabselected, {
#    if (input$tabselected == 2)
#    {
#      
#    }
#  })
#})