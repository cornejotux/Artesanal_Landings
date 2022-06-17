tab <- 0


library(shiny)
shinyServer(function(input, output, session) {
  
  #observeEvent(input$tabselected, {
    #if (input$tabselected == 1)
      #output$recurso <- renderUI({
      #  selectInput('Recurso', 'Recurso', sort(unique(ccAnchoveta2$Recurso)), selected = "Anchoveta")
      #})
    #searchResult2 <- reactive({
    #  sort(unique(filter(ccAnchoveta2, zona == input$Zona)$provincia ))
    #    })
    
    
   # print(output$recurso)
   
  output$Zona <- renderUI({
    selectInput('Zona', 'Zona', sort(unique(ccAnchoveta2$Región)), selected = "VIII Región del Biobio")
  })
  
  
  searchResults2 <- reactive({
    sort(unique(filter(ccAnchoveta2, Región == input$Zona))$Asignatario)
  })
  
  output$Asignatario <- renderUI({
    req(input$Zona)
    selectInput('Asignatario', 'Aignatario', searchResults2(), selected = "")
  })

  
  
  output$Grupo <- renderUI({
    req(input$Zona)
    selectInput('Zona', 'Zona', sort(unique(ccAnchoveta2$Región)), selected = "VIII Región del Biobio")
  })
  
  
   
    # output$tableZonaEspecie <- renderDataTable({
    #   #datatable(ccAnchoveta2)
    #     temp <- filter(ccAnchoveta2, Recurso == input$Recurso, Zona == input$Zona)
    #     DT::datatable(select(temp, -Periodo_inicio, -periodo_final, -Comentario, 
    #                          -Preliminar, -año)
    #     )
    # },  height = 700, width = 600 )
    
    output$graficoZonaEspecie <- renderPlot({
      req(input$Zona)
      #datatable(ccAnchoveta2)
      temp <- filter(ccAnchoveta2, Región == input$Zona, Asignatario == input$Asignatario)
      ggplot(data=temp, aes(y = `Cuota efectiva`, x = Asignatario)) + 
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