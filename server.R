shinyServer(function(input, output, session) {
  # import project list sample
  project <- fread('test_proj_list.tsv')
  project$unique_id <- paste(project$`Date proposed`, " ", project$`Proposed by (PI)`)
  project <- project %>% select(unique_id, everything())
  output$mainTable <- renderDT({project})
  
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$`Project Name`) | grepl(input$searchbar, project$`Brief summary`) | grepl(input$searchbar, project$`Primary contributors`) | grepl(input$searchbar, project$`Comments from group`)]
    output$mainTable <- renderTable({df})
  })
})
