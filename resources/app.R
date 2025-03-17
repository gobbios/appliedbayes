library(shiny)
ui <- navbarPage(title = " ",
                 header = tags$head(tags$style(HTML('.form-group {
                          background-color: #EACB2B;
                          }'
                 ))),
                 tabPanel(title = "posterior",
                          sidebarLayout(
                            sidebarPanel(
                              actionButton("refresh", "refresh"),
                              h4("raw data"),
                              numericInput("xdata_n", "n", min = 1, max = 100, value = 2, step = 1),
                              numericInput("xdata_mean", "mean", min = 1, max = 9, value = 8.5, step = 0.5),
                              numericInput("xdata_sd", "sd", min = 0.1, max = 5, value = 1, step = 0.1),
                              hr(),
                              h4("prior"),
                              numericInput("prior_mean", "mean", min = 1, max = 9, value = 2, step = 0.5),
                              numericInput("prior_sd", "sd", min = 0.1, max = 25, value = 1, step = 0.1)
                            ),
                            
                            mainPanel(
                              h4("observed data values:"),
                              verbatimTextOutput("xdata_values"),
                              # h4(" mean of observed data:"),
                              # verbatimTextOutput("xdata_values_mean"),
                              # h4("xdata SD (rounded):"),
                              # verbatimTextOutput("xdata_values_sd"),
                              plotOutput("outplot")
                            )
                          )
                 )
)

server <- function(input, output) {
  trigger <- reactiveValues(trigger = runif(1))
  observeEvent(input$refresh, {
    trigger$trigger <- runif(1)
  })
  observeEvent(input$xdata_n, {
    trigger$trigger <- runif(1)
  })
  observeEvent(input$xdata_mean, {
    trigger$trigger <- runif(1)
  })
  observeEvent(input$xdata_sd, {
    trigger$trigger <- runif(1)
  })
  observeEvent(input$prior_mean, {
    trigger$trigger <- runif(1)
  })
  observeEvent(input$prior_sd, {
    trigger$trigger <- runif(1)
  })
  
  observeEvent(trigger$trigger, {
    xdata <- rnorm(n = input$xdata_n, mean = input$xdata_mean, sd = input$xdata_sd)
    # xdata <- as.numeric(scale(rnorm(n = input$xdata_n, 0, 1))) * input$xdata_sd + input$xdata_mean
    
    output$xdata_values <- renderPrint(round(xdata, 1))
    output$xdata_values_mean <- renderPrint(round(mean(xdata), 1))
    output$xdata_values_sd <- renderPrint(round(sd(xdata), 1))
    
    candidate_means <- seq(from = 0, to = ceiling(max(xdata, 15)), length.out = 501)
    
    prior <- dnorm(candidate_means, mean = input$prior_mean, sd = input$prior_sd)
    
    # normalize prior
    prior <- prior / sum(prior) 
    
    # likelihood
    lik <- apply(sapply(xdata, dnorm, mean = candidate_means, sd = 1), 1, prod)
    lik <- lik / sum(lik)
    
    # denominator
    # marginal probability of the data
    pdata <- sum(lik * prior)             
    # posterior -> Bayes theorem
    post <- lik*prior / pdata  
    
    # plot
    output$outplot <- renderPlot({
      max_y <- max(prior, lik, post)
      plot(0, 0, xlim = range(candidate_means), ylim = c(0, max_y * 1.1), yaxs = "i", type = "n", axes = FALSE, ann = FALSE)
      
      cols <- hcl.colors(3, palette = "zissou")
      
      polygon(c(rev(candidate_means), candidate_means), 
              c(rep(0, length(prior)), prior), 
              col = adjustcolor(cols[1], 0.5), border = cols[1])
      polygon(c(rev(candidate_means), candidate_means), 
              c(rep(0, length(lik)), lik), 
              col = adjustcolor(cols[2], 0.5), border = cols[2])
      polygon(c(rev(candidate_means), candidate_means), 
              c(rep(0, length(post)), post), 
              col = adjustcolor(cols[3], 0.5), border = cols[3])
      
      axis(1)
      legend("topleft", pch = 15, legend = c("prior", "likelihood", "posterior"), 
             horiz = FALSE, col = cols, bty = "n")
    })
  })
}

# run
shinyApp(ui = ui, server = server)
