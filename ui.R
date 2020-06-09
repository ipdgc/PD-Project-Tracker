header <- dashboardHeader(title = "IPDGC PD Project Tracker"
)
## Sidebar content
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("th")),
    menuItem("Search Project", tabName = "Search_project", icon = icon("th")),
    menuItem("Add new project", tabName = "New_project", icon = icon("th")),
    menuItem("Edit project", tabName = "Edit_project", icon = icon("th"))))
## Body content
body <- dashboardBody(
  tabItems(
    #First tab content
    tabItem(tabName = "dashboard",
            h1("Table of IPDGC PD Projects", align = "center"),
            DTOutput("mainTable")
            ),
    # Second tab content
    tabItem(tabName = "Search_project",
            textInput("searchbar",h4("Search here using keywords:"), placeholder = "Ex: Search...GWAS"),  
            selectInput("search_status",h4("Filter for project status: "),choices = list("ongoing", "done")),
            sliderInput("year_submitted", h4("Filter for submission year"), min = 2006, max = 2020,  c(2006, 2020)),
            selectizeInput("search_categories", h4("Filter for predefined categories (all that applied): "), width = "100%", choices = list("GWAS study", "WGS", "exome sequencing", "etc"), multiple = TRUE),
            actionButton("searchButton", "Search!")),
    # Third tab content
    tabItem(tabName = "New_project",
            textInput("nameAdd",h3("Project Name: "),width = "100%"),
            selectizeInput("keywordsAdd", label = h3("Insert your keywords: "),choices = NULL, multiple = TRUE, options = list(create = TRUE), width = "100%"),
            selectizeInput("categoriesAdd", h3("Select any of these predefined categories that applied to your project: "), width = "100%", choices = list("GWAS study", "WGS", "exome sequencing", "etc"), multiple = TRUE),
            textInput("summaryAdd",h3("Briefly summarize the project: "),width = "100%"),
            textInput("proposedbyAdd",h3("Proposed by: "),width = "100%"),
            textInput("authorsAdd",h3("Contributors: "),width = "100%"),
            dateInput("proposedateAdd",h3("Date Proposed: "),width = "100%"),
            textInput("deliverablesAdd",h3("Deliverables: "),width = "100%"),
            textInput("timelineAdd",h3("Timeline: "),width = "100%"),
            selectInput("statusAdd",h3("Current status: "),width = "100%",choices = list("In Progress","Submitted","In Review","Published")),
            textInput("publicationAdd",h3("Publication link: "),width = "100%"),
            textInput("githubAdd",h3("Github page link: "),width = "100%"),
            actionButton("AddButton",h3(paste("Submit Project","\n")),width = "100%")),
    # Third tab content
    tabItem(tabName = "Edit_project",
            selectInput("dropdown_EditProject","Select the project to edit :",
                        c("Project_1", "Project_2", "Project_3", "Project_..."))
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)