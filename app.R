#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# This application is a simple example of both server logic and UI configurations residing in the same file.

library(shiny)
library(colorfindr)
library(tidyverse)
library(magick)
library(shinyWidgets)

data <- c(
    "http://www.coverbrowser.com/image/lucky-luke/5-1.jpg",
    "https://www.movieart.ch/bilder_xl/tintin-et-milou-poster-11438_0_xl.jpg",
    "http://www.gallery29.ie/images/posters/1171469398_DSC03889.jpg",
    "https://www.artifiche.com/cms/upload/posters_extralarge/2850.jpg"
)

# Pick an example from the image dataset
default <- sample(data,1)

# Define UI for application 

ui <- fluidPage(
    setBackgroundColor("#F8F8FF"),
    titlePanel("Create your own color palette"),
    br(),
    tags$h4(a(href="https://github.com/zumbov2/colorfindr", "Based on the colorfindr package")),
    br(),
    a(href="https://github.com/akonkia", "By"),
    br(),

    sidebarLayout(
        sidebarPanel(
            # a text input box
            textInput(inputId = "path", label = "Paste image URL below:", value = default),
            #a slider to choose number of colors in the palette                                                        
            sliderInput("slider", label = "How many colors would you like?",min = 1, max = 10, value = 5)
        ),
        mainPanel(
            
            imageOutput("source"),    
            plotOutput("palette"),
            verbatimTextOutput("code")
        )
)
)

# Define server logic 
server <- function(input, output, session) {
    
    # Ensure reproducibility
    set.seed(123)    
    
    output$palette <- renderPlot({

        get_colors(input$path) %>%
            make_palette(input$slider)

    })
    output$code <- renderPrint({
        
        out <- get_colors(input$path) %>%
            make_palette(input$slider)
        print(out)
        
    })
    output$source<- renderPlot ({
        
        img <- magick::image_read(input$path)
        plot(img)

    })
}
# Run the application 
shinyApp(ui = ui, server = server)

