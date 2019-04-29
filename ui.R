
#pageWithSidebar(
fluidPage(
    title="Explorador de Desembarcos Artesanales",
    #theme = shinytheme("flatly"),
    headerPanel(
        HTML('<td style="width: 100%"></td>
              
              <td style="width: 0%"></td>')
    ),
    sidebarPanel(
        HTML('
             '),
        conditionalPanel(
          condition="input.tabselected==1",uiOutput("Region"), uiOutput("Especies"), uiOutput("sliderYear")
         ),
         conditionalPanel(
          condition="input.tabselected==2", uiOutput("Especies2"), uiOutput("sliderYear2")
          ),
        conditionalPanel(
          condition="input.tabselected==3", uiOutput("Region3"), uiOutput("sliderYear3")
        )
        

        ),
    mainPanel(
        # Output: Tabset w/ plot, summary, and table ----
        tabsetPanel(type = "tabs",
                    tabPanel("Mean Length", value = 1, 
                             plotOutput('plotRegionSp')),
                    tabPanel("By Regions", value = 2, 
                             plotOutput('plotAllRegions')),
                    tabPanel("By Species", value = 3, 
                             plotOutput('plotAllSpecies')),
                    tabPanel("Info", value = 4, HTML(
                        '<b>Data Origin</b>:<br> 
                        The data used in this application is Escapement_location_linked.csv 
                            from <a href="https://knb.ecoinformatics.org/#view/knb.92170.1">KNB</a>.
                        This dataset can be cited as:<br>
                        - <i>Jeanette Clark</i>, <i>Rich Brenner</i>, and <i>Bert Lewis</i> (2018) Compiled age, sex, 
                        and length data for Alaskan salmon. <i>Knowledge Network for Biocomplexity</i>. knb.92170.1.<br>
                        NOTE: This file is not open to the public, but it will be.<br><br>
                        
                        <b>Data Processing</b>:<br> 
                        The data used in this applicarion is a standard length measured as <i>Mid-eye to the fork of 
                        the tail</i>, the units are millimeters (mm). 
                        Only project locations with 10 years or more were included. 
                        The average length was calculated for SASAP.Region (including several <i>project locations</i>) and 
                        sampling day.<br><br>
                        
                        <b>Plot description</b>:<br>
                        The plot shows years in the  <i>x</i> axis and mean length in the <i>y</i> axis.<br><br>
                        
                        <b> Links to other shiny apps</b>:<br>
                        <ul>
                            <li><a href="http://cosima.nceas.ucsb.edu/cornejo-shiny/escapement_explorer/">Escapement Explorer</a></li>
                        </ul>  
                        ')
                        ), id = "tabselected"
                    )
        )
    )
