library(shiny)
library(shinythemes)
library(Lab5)

url<-"http://api.kolada.se/v2/ou?title=skola"
df <- Lab5::my_API(url)

#create Shiny app
ui <- fluidPage(
  titlePanel("The number of Scools in each region"),
  ui <- fluidPage(theme = shinytheme("yeti"),
                  navbarPage("Kolada Dataset"), navbarPage("The Region code"),
                  
                  sidebarLayout(sidebarPanel(
                    demo_select <- 
                      selectInput("muni_select", 
                                  label = "municipality_name", 
                                  choices = df$municipality_name,
                                  selected = NULL,
                                  width = "100%"),
                    
                    textOutput("demo_text", container = tags$h3)
                    
                  ),
                  mainPanel(
                    p("The open and free database for municipalities and regions.
Kolada gives you the best opportunities for comparisons and analysis in the municipal sector. The database contains 6,000 key figures, i.e. measures that are suitable for comparison. The different tools help you analyze and visualize results."),
                    
                    
                    
                    DT::dataTableOutput("demo_datatable",
                                        width = "50%",
                                        height = "auto"),
                  )
                  ))
)

# Define server logic ----
server <- function(input, output) {
  output$demo_text <- renderText({
    Len=dim(df)[1]
    for (i in 1:Len){
      if (df$municipality_name[i]==input$muni_select){K<-df$number_schools[i]}
    }
    paste("the number of Schools=",K)
  })
  
  output$demo_datatable <- DT::renderDataTable({df
    
  }, options = list(pageLength = 10))
  
}

# Run the application ----
shinyApp(ui = ui, server = server)

