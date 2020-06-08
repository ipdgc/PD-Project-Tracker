shinyServer(function(input, output, session) {
  # import project list sample
  project <- fread('test_proj_list.tsv', sep = ";")
  output$mainTable <- renderTable({project})
  
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$id) | grepl(input$searchbar, project$keywords) | grepl(input$searchbar, project$authors)]
    output$mainTable <- renderTable({df})
  })
})