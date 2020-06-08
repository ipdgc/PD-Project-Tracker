fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("searchbar", label = "search test", placeholder = "demo"),
      actionButton("searchButton", "PUSH ME")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("mainTable")
    )
  )
)