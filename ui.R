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
              valueBox(width = 4,
                       uiOutput("projectCount"), # <- EXAMPLE OF uiOutput
                       "Projects", icon = icon("book")),
              # Dynamic valueBoxes
              valueBoxOutput("progressBox"),
              valueBoxOutput("approvalBox"),
              column(width = 4,
                     valueBox(width = NULL,
                              uiOutput("projectSubmitted"), 
                              "Projects Submitted", icon = icon("book"))),
              column(width = 4,
                     valueBox(width = NULL,
                              uiOutput("projectPublished"),
                              "Projects Published", icon = icon("book")))),
            fluidRow(box(width = 12, solidHeader = TRUE, status = "primary", DTOutput("mainTable"),
                         title = "IPDGC Project Table"))),
    
    # Second tab content (Search project)
    tabItem(tabName = "Search_project",
            textInput("searchbar",h4("Search here using keywords:"), placeholder = "Ex: Search...GWAS"),  
            selectInput("search_status",h4("Filter for project status: "),choices = list("Any", "In Progress","Submitted","In Review","Published")),
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
                        c("Project Name","Brief Summary","Primary contributors","Deliverables","Timeline","Status","Publication Link","Github")),
            uiOutput("editInputForm"),
            actionButton("editButton", "Submit change")
            ),

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
