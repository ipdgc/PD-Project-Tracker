library(shiny)
library(shinydashboard)
library(shinydashboardPlus)



#################################
### UI
#################################


header <- dashboardHeader(title = "IPDGC PD Project Tracker",
                          titleWidth = 300,
                          dropdownMenu(type = "messages",
                                       messageItem(
                                         from = "New project",
                                         message = "New project added.",
                                         icon = icon("bomb")
                                       ),
                                       messageItem(
                                         from = "New User",
                                         message = "How do I register?",
                                         icon = icon("question"),
                                         time = "13:45"
                                       ),
                                       messageItem(
                                         from = "Support",
                                         message = "The new server is ready.",
                                         icon = icon("life-ring"),
                                         time = "2014-12-01"
                                       )),
                          dropdownMenu(type = "notifications",
                                       notificationItem(
                                         text = "1 New project added",
                                         icon("users")
                                       ),
                                       notificationItem(
                                         text = "1 Project published",
                                         icon("truck"),
                                         status = "success"
                                       ),
                                       notificationItem(
                                         text = "Project dealine",
                                         icon = icon("exclamation-triangle"),
                                         status = "warning"
                                       )))

## Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("th")),
    menuItem("Search Project", tabName = "Search_project", icon = icon("th")),
    menuItem("Add new project", tabName = "New_project", icon = icon("th")),
    menuItem("Edit project", tabName = "Edit_project", icon = icon("th")),
    menuItem("Code", tabName = "Code", icon = icon("github-square")),
    menuItem("IPDGC Consortium Webpage", icon = icon("odnoklassniki"), href = "https://pdgenetics.org/")))

## Body content
body <- dashboardBody(
  tabItems(
    #First tab content (Main dashboard)
    tabItem(tabName = "dashboard", h1("IPDGC PD Projects", align = "center"),
            # infoBoxes with fill=FALSE
            fluidRow(
              # A static valueBox
              valueBox(width = 4, "X", "Projects", icon = icon("book")),
              # Dynamic valueBoxes
              valueBoxOutput("progressBox"),
              valueBoxOutput("approvalBox"),
              column(width = 4,
                     valueBox(width = NULL, "X", "Archived Projects", icon = icon("book"))),
              column(width = 4,
                     valueBox(width = NULL, "X", "Projects Published", icon = icon("book")))),
            fluidRow(box(width = 12, height = '300px', solidHeader = TRUE, status = "primary", DTOutput("mainTable")
                         title = "IPDGC Project Table"))),
    
    # Second tab content (Search project)
    tabItem(tabName = "Search_project",
            textInput("searchbar",h4("Search here using keywords:"), placeholder = "Ex: Search...GWAS"),  
            selectInput("search_status",h4("Filter for project status: "),choices = list("In Progress","Submitted","In Review","Published")),
            sliderInput("year_submitted", h4("Filter for submission year"), min = 2006, max = 2020,  c(2006, 2020)),
            selectizeInput("search_categories", h4("Filter for predefined categories (all that applied): "), width = "100%", choices = list("Functional Studies", "Bioinformatics Studies", "Multidisciplinary Studies"), multiple = TRUE),
            actionButton("searchButton", "Search!")),
    
    # Third tab content (Add Project)
    tabItem(tabName = "New_project",
            textInput("nameAdd",h3("Project Name: "),width = "100%"),
            selectizeInput("keywordsAdd", label = h3("Insert your keywords: "),choices = NULL, multiple = TRUE, options = list(create = TRUE), width = "100%"),
            selectizeInput("categoriesAdd", h3("Select any of these predefined categories that applied to your project: "), width = "100%", choices = list("Functional Studies", "Bioinformatics Studies", "Multidisciplinary Studies"), multiple = TRUE),
            textInput("summaryAdd",h3("Briefly summarize the project: "),width = "100%"),
            textInput("proposedbyAdd",h3("Proposed by: "),width = "100%"),
            textInput("mainPI",h3("PI: "),width = "100%"),
            textInput("authorsAdd",h3("Contributors: "),width = "100%"),
            dateInput("proposedateAdd",h3("Date Proposed: "),width = "100%"),
            textInput("deliverablesAdd",h3("Deliverables: "),width = "100%"),
            textInput("timelineAdd",h3("Timeline: "),width = "100%"),
            selectInput("statusAdd",h3("Current status: "),width = "100%",choices = list("In Progress","Submitted","In Review","Published")),
            textInput("publicationAdd",h3("Publication link: "),width = "100%"),
            textInput("githubAdd",h3("Github page link: "),width = "100%"),
            actionButton("AddButton",h3(paste("Submit Project","\n")),width = "100%")),
    
    
    #Fourth tab content (Edit Project)
    tabItem(tabName = "Edit_project",
            selectInput("dropdown_EditProject","Select the project to edit :",
                        c("Project_1", "Project_2", "Project_3", "Project_...")),
            selectInput("EditCategory","Select the field to edit: ",
                        c("Project Name","Project Summary","Contributors","Deliverables","Timeline","Current Status","Publication Link","Github Page Link")),
            conditionalPanel(condition = "input.EditCategory == 'Project Name'",textInput("editName","Enter new project name: ")),
            conditionalPanel(condition = "input.EditCategory == 'Project Summary'",textInput("editSummary","Enter new project summary: ")),
            conditionalPanel(condition = "input.EditCategory == 'Contributors'",textInput("editContr","Enter updated contributor names: ")),
            conditionalPanel(condition = "input.EditCategory == 'Deliverables'",textInput("editdeliv","Update deliverable: ")),
            conditionalPanel(condition = "input.EditCategory == 'Timeline'",textInput("editTimeline","Update project timeline: ")),
            conditionalPanel(condition = "input.EditCategory == 'Current Status'",textInput("editStatus","Update project status: ")),
            conditionalPanel(condition = "input.EditCategory == 'Publication Link'",textInput("editLink","Add a publication link: ")),
            conditionalPanel(condition = "input.EditCategory == 'Github Link'",textInput("editGit","Add a github link: "))),
    
    #Fifth tab content (Code info)
    tabItem(tabName = "Code",
            box(width = NULL,
                title = "Find code here!",
                status = NULL,
                socialButton(
                  url = "https://github.com/ipdgc/PD-Project-Tracker",
                  type = "github")))
  )
)

dashboardPage(
  header,
  sidebar,
  body
)

ui <- dashboardPage(
  header,
  sidebar,
  body
)


#################################
### Server
#################################


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



shinyApp(ui, server)




