shinyServer(function(input, output, session) {
  # import project list sample
  project <- fread('test_proj_list.tsv')
  output$mainTable <- renderDT({project})
  # basic search
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$`Project Name`) | grepl(input$searchbar, project$`Brief summary`) | grepl(input$searchbar, project$`Primary contributors`) | grepl(input$searchbar, project$`Comments from group`)]
    output$mainTable <- renderTable({df})
  })
  #====editing entry====
  observeEvent(input$editButton, {
    # df <- project[grepl(id, project$id)]
    insert <- data.table(
      # replace all blanks with inputs
      Status="",
      `Project Name`="",
      `Brief summary`="",
      `Proposed by (PI)`="",
      `Primary contributors`="",
      `Date proposed`= "",
      `Deliverables`="",
      `Timeline`="",
      `Comments from group`="",
      id = id_edit
      )
    df[grep(id_edit, project$id),] <- insert
  })
  #====Adding entry====
  observeEvent(input$addButton, {
    #****ADD SHINYJS THING TO MAKE INSERTION UI VISIBLE***
    insert <- data.table(
      # replace all blanks with inputs
      Status="",
      `Project Name`="",
      `Brief summary`="",
      `Proposed by (PI)`="",
      `Primary contributors`="",
      `Date proposed`= "",
      `Deliverables`="",
      `Timeline`="",
      `Comments from group`="",
      id = id_edit
    )
    project <- rbind(project, insert)
  })
  
})
