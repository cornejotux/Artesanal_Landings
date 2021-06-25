tab <- 0


library(shiny)
shinyServer(function(input, output, session) {
   
    observeEvent(input$tabselected, {
      if (input$tabselected == 1)
        output$recurso <- renderUI({
          selectInput('Recurso', 'Recurso', sort(unique(controlCuota$Recurso)), selected = VIII)
            })
        #searchResult2 <- reactive({
        #  sort(unique(filter(controlCuota, zona == input$Zona)$provincia ))
        #    })
        
        
        print(recurso)
        
        output$tableZonaEspecie <- renderDataTable({
          
          #datatable(controlCuota)
          DT::datatable(controlCuota) #[, input$show_vars, drop = FALSE])
          
        },  height = 700, width = 600 )
        
        
      })
  
  observeEvent(input$tabselected, {
    if (input$tabselected == 2)
        {
        
        }
    })
}