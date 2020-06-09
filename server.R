
shinyServer(function(input, output, session) {
  
  
  
  #====import project list sample====
  # create dribble object from google sheets file id (currently my example sheet)
  #in this format, we can use the utility functions in the googledrive package
  IPDGC_exsheet <- as_dribble(as_id("1YBUOskdNmd1ZLiNJP5F-OS58lN5vBhYtrzSF_9HWoz0"))
  
  #read the dribble object using the googlesheets4 package
  project <- read_sheet(IPDGC_exsheet)
 
  output$mainTable <- renderDT({project})
  #====basic search====
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$`Project Name`, ignore.case = T) | grepl(input$searchbar, project$`Brief summary`, ignore.case = T) | grepl(input$searchbar, project$`Primary contributors`, ignore.case = T) | grepl(input$searchbar, project$`Comments from group`, ignore.case = T), ]
    df <- df[grepl(input$search_status, df$Status), ]
    # Date proposed here needs a bit of work...
    #df <- df[grepl(input$year_submitted, df$`Date proposed`)]
    
    # If the category field is left blank, then input is set to NULL and everything breaks down
    # must detect when it is not NULL and search
    if (!is.null(input$search_categories)) {
      df <- df[df(input$search_categories, df$Category)]
    }
    output$mainTable <- renderDT({df})
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
      unique_id = input$dropdown_EditProject
      )
    df[grep(input$dropdown_EditProject, project$id),] <- insert
  })
  #====Adding entry====
  observeEvent(input$AddButton, {
    #****ADD SHINYJS THING TO MAKE INSERTION UI VISIBLE***
    insert <- data.table(
      # replace all blanks with inputs
      Status = input$statusAdd,
      `Project Name` = input$nameAdd,
      `Brief summary` = input$summaryAdd,
      `Proposed by (PI)` = input$proposedbyAdd,
      `Primary contributors` = input$authorsAdd,
      `Date proposed`= as.character(input$proposedateAdd),
      `Deliverables` = input$deliverablesAdd,
      `Timeline` = input$timelineAdd,
      `Comments from group` = "",
      Github = input$githubAdd,
      `Publication Link` = input$publicationAdd,
      `Keywords` = input$keywordsAdd,
      `Category` = input$categoriesAdd
      #id = id_edit
    )
    insert$unique_id <- paste(insert$`Date proposed`, insert$`Proposed by (PI)`, sep = "_")
    print(colnames(insert))
    #insert <- insert %>% select(unique_id, everything())
    project <- rbind(project, insert)
    showNotification("Project submitted!")
    output$mainTable <- renderDT({project})
  })
  
})
