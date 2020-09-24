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

# Define UI for application 

ui <- fluidPage(
    setBackgroundColor("#F8F8FF"),
    titlePanel("Create your own color palette"),
    br(),
    tags$h4(a(href="https://github.com/zumbov2/colorfindr", "Based on the colorfindr package")),
    br(),
    a(href="https://twitter.com/AKonkolewska", "By"),
    br(),

    sidebarLayout(
        sidebarPanel(
            # a text input box
            textInput(inputId = "path", label = "Paste image URL below:", value = "URL..."),
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
    default <- sample(data,1)
    output$palette <- renderPlot({
        
        # Ensure reproducibility
        set.seed(123)
        tryCatch(
            expr ={
                out <- get_colors(input$path) %>%
                        make_palette(input$slider)
                print(out)
                },
            error = function(e){
                    out <- get_colors(default) %>%
                        make_palette(input$slider)
                    message('An example')
                    print(out)
            },
            warning = function(w){
                message('Caught a warning!')
                print(w)
            },
            finally = {
                message('Plot done, quitting.')
            }
        )

    })
    output$code <- renderPrint({
        tryCatch(
            expr ={
                out <- get_colors(input$path) %>%
                    make_palette(input$slider)
                print(out)
            },
            error = function(e){
                
                out <- get_colors(default) %>%
                    make_palette(input$slider)
                message('An example')
                print(out)
            },
            warning = function(w){
                message('Caught a warning!')
                print(w)
            },
            finally = {

                message('Color codes printed, quitting.')
            }
        )
        
    })
    output$source<- renderPlot ({

        tryCatch(
            expr ={

                img <- magick::image_read(input$path)
                plot(img)
            },
            error = function(e){
                img <- magick::image_read(default)
                plot(img)
                message('An example')
                print(e)
            },
            warning = function(w){

            },
            finally = {
                
                # Return a list
                list(src = img,
                     alt = "Color palette source")
            }
        )
        
    }
    )
}
# Run the application 
shinyApp(ui = ui, server = server)
