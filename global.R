library(shiny)
library(data.table)
library(DT)
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(shinydashboardPlus)
library(googlesheets4)
library(googledrive)

#global out-of-band auth ("oob"). I dont think this is necessary if we have a service token
options(gargle_oob_default  = TRUE)

#To ensure that users can access the webpage and data without any Rstudio invovlement
# we will have to employ a "service token" 
#Then we can explicitly tell the R packages googledrive and googlesheets4 to use this token
#googledrive authentication: drive_auth(path = "/path/to/your/service-account-token.json")
#googlesheets4 authentication: gs4_auth(path = "/path/to/your/service-account-token.json")
#See these links for deatils: https://cran.r-project.org/web/packages/gargle/vignettes/non-interactive-auth.html
# https://cloud.google.com/iam/docs/service-accounts?_ga=2.215917847.-1040593195.1558621244
