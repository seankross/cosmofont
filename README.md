# cosmofont

### Programmaticaly generate @font-faces for CSS stylesheets in R

cosmofont creates CSS stylesheets so you can use custom fonts in your projects. Use your own font files or use cosmofont to get some of the most popular typography on the web from [Google Fonts](http://google.com/fonts). cosmofont supports `.eot`, `.tff`, and `.woff` file types. Use [Data URIs](https://en.wikipedia.org/wiki/Data_URI_scheme) to embed fonts inline so you can use your webfonts offline!

## To install:

```ruby
library(devtools)
install_github("cosmofont", "seankross")
```

## Getting started:
```ruby
# Get some fonts!
roboto <- google_font_options("Roboto")
open_sans <- google_font_options("Open Sans")
cosmofont(roboto, open_sans)
# stylesheet.css should appear in your working directory.
```

## Using cosmofont with [shiny](https://github.com/rstudio/shiny)

The structure of your shiny app should look like the following:
```
.
├── ui.R
├── server.R
└── stylesheet.css
```
A sample `ui.R`:
```ruby
library(shiny)

# Define UI for application that plots random distributions 
shinyUI(bootstrapPage(

  # Use custom CSS
  includeCSS("stylesheet.css"),

  # Application title
  headerPanel("Hello Shiny!"),

  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("obs", 
                "Number of observations:", 
                min = 1,
                max = 1000, 
                value = 500)
  ),

  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))
```
A sample `server.R`:
```ruby
library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$distPlot <- renderPlot({

    # generate an rnorm distribution and plot it
    dist <- rnorm(input$obs)
    hist(dist)
  })
})
```
Now run the following:
```ruby
library(shiny)
library(cosmofont)

# Make a stylesheet if you haven't already
cat("h1 { font-family: 'Great Vibes'; }\n", "stylesheet.css")

# Get your favorite font!
great_vibes <- google_font_options("Great Vibes")
cosmofont(great_vibes, uri = TRUE)

# Start your shiny app!
runApp()
```
To quickly preview the whole effect, run the following:
```ruby
library(shiny)

runGitHub("cosmofont", "seankross", "shiny")
```