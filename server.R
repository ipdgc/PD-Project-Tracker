
shinyServer(function(input, output, session) {
  
  
  
  #====import project list sample====
  # create dribble object from google sheets file id (currently my example sheet)
  #in this format, we can use the utility functions in the googledrive package
  IPDGC_exsheet <- as_dribble(as_id("1YBUOskdNmd1ZLiNJP5F-OS58lN5vBhYtrzSF_9HWoz0"))
  
  #read the dribble object using the googlesheets4 package
  project <- read_sheet(IPDGC_exsheet)
  
  output$mainTable <- renderDT({
    datatable(
      project,
      options = list(
        scrollX=T
      )
    )
  })
  #====basic search====
  observeEvent(input$searchButton, {
    df <- project[grepl(input$searchbar, project$`Project Name`, ignore.case = T) | grepl(input$searchbar, project$`Brief summary`, ignore.case = T) | grepl(input$searchbar, project$`Primary contributors`, ignore.case = T) | grepl(input$searchbar, project$`Comments from group`, ignore.case = T), ]
    if (input$search_status != "Any") {
      df <- df[grepl(input$search_status, df$Status), ]
    }
    # Date proposed here needs a bit of work...
    #df <- df[grepl(input$year_submitted, df$`Date proposed`)]
    
    # If the category field is left blank, then input is set to NULL and everything breaks down
    # must detect when it is not NULL and search
    if (!is.null(input$search_categories)) {
      if (length(input$search_categories) == 1) {
        df <- df[grepl(input$search_categories, df$Category), ]
      } else if (length(input$search_categories) == 2) {
        df <- df[grepl(input$search_categories[1], df$Category) | grepl(input$search_categories[2], df$Category), ]
      } else {
        df <- df[grepl(input$search_categories[1], df$Category) | grepl(input$search_categories[2], df$Category) | grepl(input$search_categories[3], df$Category), ]
      }
    }
    output$mainTable <- renderDT({
      datatable(
        df,
        options = list(
          scrollX=T
        )
      )
    })
  })
  
  #====editing entry====
  # FIRST update the select entry with the unique IDs
  updateSelectInput(
    session,
    "dropdown_EditProject",
    choices = project$unique_id
  )
  output$editInputForm <- renderUI({
    if (input$EditCategory == "Status") {
      tagList(
        selectInput(
          "editEntry",
          label = "Updated status:",
          choices = list("Any", "In Progress","Submitted","In Review","Published")
        )
      )
    } else {
      tagList(
        textInput("editEntry","Enter new entry:")
      )
    }
  })
  
  observeEvent(input$editButton, {
    df <- project
    insert <- project[grepl(input$dropdown_EditProject, project$unique_id),]
    insert[, eval(input$EditCategory)] <- input$editEntry
    # insert <- data.table(
    #   # replace all blanks with inputs
    #   Status="",
    #   `Project Name`="",
    #   `Brief summary`="",
    #   `Proposed by (PI)`="",
    #   `Primary contributors`="",
    #   `Date proposed`= "",
    #   `Deliverables`="",
    #   `Timeline`="",
    #   `Comments from group`="",
    #   unique_id = input$dropdown_EditProject
    # )
    df[grep(input$dropdown_EditProject, df$unique_id),] <- insert
    showNotification("Project changed!")
    output$mainTable <- renderDT({
      datatable(
        df,
        options = list(
          scrollX=T
        )
      )
    })
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
    # print(colnames(insert))
    #insert <- insert %>% select(unique_id, everything())
    project <- rbind(project, insert)
    showNotification("Project submitted!")
    output$mainTable <- renderDT({
      datatable(
        project,
        options = list(
          scrollX=T
        )
      )
    })
  })
  
  # Fancy card stuff
  output$projectCount <- renderUI({
    tagList(
      nrow(project)
    )
  })
  
})