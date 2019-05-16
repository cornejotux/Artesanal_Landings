tab <- 0
S <<- 'ALMEJA'
R <<- "8"
Provincia <<- "Arauco"

library(shiny)
shinyServer(function(input, output, session) {
   
    observeEvent(input$tabselected, {
        Region <- Species <- Slider <- NULL
      if (input$tabselected == 1)
      {
         
          if(tab == 0)
          {
              minmax <- reactive({
                  selectYears(filter(caletas, SASAP.Region == R, Species == S))
              })
              minmax <- minmax()
              slider <- minmax
              
              Region <- R
              Especies <- S
          } else if (tab == 1)
          {
              slider <- input$sliderYear
              Especies <- input$Especies
              Region <- input$Region
          } else if (tab == 2)
          {
              slider <- input$sliderYear2
              Especies <- input$Especies2
              Region <- R
          } else if (tab == 3)
          {
              slider <- input$sliderYear3
              Especies <- S
              Region <- input$Region3
          }
          
        output$Region <- renderUI({
          selectInput('Region', 'Region', sort(unique(caletas$region)), selected = Region)
            })
        searchResult2 <- reactive({
          sort(unique(filter(caletas, region == input$Region)$provincia ))
            })
        
        output$Provincia <- renderUI({
          req(input$Region)
          selectInput('Provincia', 'Provincia', searchResult2(), selected = Provincia)
        })
        searchResult3 <- reactive({
          sort(unique(filter(caletas, region == input$Region, provincia == input$Provincia)$especie ))
        })
        
        output$Especies <- renderUI({
          req(input$Provincia)
          selectInput("Especies", "Especies", searchResult3(), selected = Especies)
            })
        minmax <- reactive({
          selectYears(filter(caletas, region == Region, provincia == Provincia, especie == Especies))
            })
        print(slider)
        print(Region)
        print(Provincia)
        print(Especies)
        output$sliderYear <- renderUI({
          req(Especies)
          minmax <- minmax()
          sliderInput("sliderYear", "Rango de Años:",
                      min = minmax[1], max = minmax[2],
                      value = c(slider[1], slider[2]),
                      step=5, sep = '', timeFormat='%F')
            })
        tab <<- 1
      }
    })

  observeEvent(input$tabselected, {
    if (input$tabselected == 2)
        {
        if (tab == 1)
        {
            slider <- input$sliderYear
            Especies <- input$Especies
            R <<- input$Region
        }  else if (tab == 3)
        {
            slider <- input$sliderYear3
            Especies <- S
            Region <- input$Region3
        }
        
        output$Especies2 <- renderUI({ 
            selectInput(inputId = "Especies2", label = "Especies", sort(unique(caletas$especie)), selected = Especies)
            })
        minmax <- reactive({
            selectYears(filter(caletas, especie == input$Especies2))
            })

        output$sliderYear2 <- renderUI({
            req(input$Especies2)
            minmax <- minmax()
            sliderInput(inputId = "sliderYear2", "Year range:",
                    min = minmax[1], max = minmax[2],
                    value = c(slider[1], slider[2]),
                    step=1, sep = '')
            })
        tab <<- 2
        
        }
    })
    
  observeEvent(input$tabselected, {
    if (input$tabselected == 3)
        {
        if (tab == 1)
        {
            slider <- input$sliderYear
            Especies <- input$Especies
            Region <- input$Region
        } else if (tab == 2)
        {
            slider <- input$sliderYear2
            S <<- input$Especies2
            Region <- R
        } 
        output$Region3 <- renderUI({
            selectInput('Region3', 'Region', sort(unique(caletas$region)), selected = Region)
            })
        minmax <- reactive({
            selectYears(filter(caletas, region == input$Region))
            })
        output$sliderYear3 <- renderUI({
            req(input$Region3)
            minmax <- minmax()
            sliderInput("sliderYear3", "Year range:",
                        min = minmax[1], max = minmax[2],
                        value = c(slider[1], slider[2]),
                        step=1, sep = '')
            })
        tab <<- 3
        }
  })
   
    output$plotRegionSp <- renderPlot({
        req(input$Region)
        req(input$Especies)
        req(input$sliderYear)
        temp <- filter(caletas, region == input$Region, provincia == input$Provincia, especie == input$Especies, 
                       ano >= input$sliderYear[1], ano <= input$sliderYear[2])

        ggplot(temp, 
          aes(x=ano, y=captura)) + 
          geom_point() + geom_smooth(method = "loess") + 
          facet_wrap(~caleta) + xlab("Año") + ylab("Desembarques (ton?)")
          
        
    },  height = 700, width = 600 )

    output$plotAllRegions <- renderPlot({
        req(input$sliderYear2)
        temp <- filter(caletas, especie == input$Especies2, ano >= input$sliderYear2[1], ano <= input$sliderYear2[2])
        ggplot(temp, aes(x=ano, y=captura)) + 
      geom_point() + geom_smooth(method = "loess") + 
      facet_wrap(~region) + xlab("Año") + ylab("Desembarques (ton?)")
    
    
    },  height = 700, width = 600 )
    
    output$plotAllSpecies <- renderPlot({
        req(input$sliderYear3)
        temp <- filter(caletas, region == input$Region3, ano >= input$sliderYear3[1], ano <= input$sliderYear3[2])
        ggplot(temp, 
               aes(x=ano, y=captura)) + 
            geom_point(size=0.5)
    },  height = 700, width = 600 )
    
})
