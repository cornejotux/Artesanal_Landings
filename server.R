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
    selectInput("Zona", "Zona", searchResult2(), selected = NULL)
  })
  
  
   
    output$tableZonaEspecie <- renderDataTable({
      
      #datatable(controlCuota)
      
        
        temp <- filter(controlCuota, Recurso == input$Recurso, Zona == input$Zona)
        
        DT::datatable(select(temp, -Periodo_inicio, -periodo_final, -Comentario, 
                             -Preliminar, -año)
        
        )
      
    },  height = 700, width = 600 )
    
    
  })
  
 # observeEvent(input$tabselected, {
#    if (input$tabselected == 2)
#    {
#      
#    }
#  })
#})