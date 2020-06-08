shinyServer(function(input, output, session) {
  # import project list sample
  project <- fread('test_proj_list.tsv')
  output$mainTable <- renderDT({project})
  
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$`Project Name`) | grepl(input$searchbar, project$`Brief summary`) | grepl(input$searchbar, project$`Primary contributors`) | grepl(input$searchbar, project$`Comments from group`)]
    output$mainTable <- renderTable({df})
  })
})
