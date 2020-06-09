library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

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
    menuItem("Search Project", tabName = "Search_project", icon = icon("eye")),
    menuItem("Add new project", tabName = "New_project", icon = icon("plus")),
    menuItem("Edit project", tabName = "Edit_project", icon = icon("edit")),
    menuItem("Code", tabName = "Code", icon = icon("github-square")),
    menuItem("IPDGC Consortium Webpage", icon = icon("odnoklassniki"), href = "https://pdgenetics.org/")))

## Body content
body <- dashboardBody(
  tabItems(
    #First tab content
    tabItem(tabName = "dashboard", h1("Table of IPDGC PD Projects", align = "center"),
            # infoBoxes with fill=FALSE
            fluidRow(
              # A static valueBox
              valueBox(width = 4, "X", "Projects", icon = icon("book")),
              # Dynamic valueBoxes
              valueBoxOutput("progressBox"),
              valueBoxOutput("approvalBox"),
              column(width = 4,
                     valueBox(width = NULL, "X", "Archived Projects", icon = icon("book")),
                     valueBoxOutput("progressBox"),
                     valueBoxOutput("approvalBox")),
              column(width = 4,
                     valueBox(width = NULL, "X", "Projects Published", icon = icon("book")),
                     valueBoxOutput("progressBox"),
                     valueBoxOutput("approvalBox"))),
            fluidRow(box(width = 12, height = '300px', solidHeader = TRUE, status = "primary",
                title = "IPDGC Project Table"))),
    
    
    # Second tab content
    tabItem(tabName = "Search_project",
            textInput("searchbar",h4("Search here using keywords:"), "Ex: Search...GWAS"),  
            selectInput("search_status",h4("Filter for project status: "),choices = list("ongoing", "done")),
            sliderInput("year_submitted", h4("Filter for submission year"), min = 2006, max = 2020,  c(2006, 2020)),
            selectizeInput("search_categories", h4("Filter for predefined categories (all that applied): "), width = "100%", choices = list("GWAS study", "WGS", "exome sequencing", "etc"), multiple = TRUE)),
    # Third tab content
    tabItem(tabName = "New_project",
            textInput("name",h3("Project Name: "),width = "100%"),
            selectizeInput("keywords2", label = h3("Insert your keywords: "),choices = NULL, multiple = TRUE, options = list(create = TRUE), width = "100%"),
            selectizeInput("add_categories", h3("Select any of these predefined categories that applied to your project: "), width = "100%", choices = list("GWAS study", "WGS", "exome sequencing", "etc"), multiple = TRUE),
            textInput("summary",h3("Briefly summarize the project: "),width = "100%"),
            textInput("proposedby",h3("Proposed by: "),width = "100%"),
            textInput("authors",h3("Contributors: "),width = "100%"),
            dateInput("date",h3("Date Proposed: "),width = "100%"),
            textInput("deliverables",h3("Deliverables: "),width = "100%"),
            textInput("timeline",h3("Timeline: "),width = "100%"),
            selectInput("status",h3("Current status: "),width = "100%",choices = list("In Progress","Submitted","In Review","Published")),
            textInput("publication",h3("Publication link: "),width = "100%"),
            textInput("github",h3("Github page link: "),width = "100%"),
            actionButton("submit",h3(paste("Submit Project","\n")),width = "100%")),
    # Fouth tab content
    tabItem(tabName = "Edit_project",
            selectInput("dropdown","Select the project to edit :",
                        c("Project_1", "Project_2", "Project_3", "Project_..."))),
    
    #Five tab content
    tabItem(tabName = "Code",
            box(width = NULL,
                title = "Find code here!",
                status = NULL,
                socialButton(
                  url = "https://github.com/ipdgc/PD-Project-Tracker",
                  type = "github")))
  )
)

ui <- dashboardPage(
  header,
  sidebar,
  body
)
server <- function(input, output) { }
shinyApp(ui, server)

