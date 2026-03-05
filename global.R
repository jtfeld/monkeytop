

library(shiny)
library(dplyr)
library(tidyr)
library(googlesheets4)
library(bslib)
library(shinyWidgets)
library(shinyjs)
library(ggplot2)
library(scales)
library(shinyvalidate)
library(plotly)


gs4_auth(cache = ".secrets", email = "jfeldblum@gmail.com")

name_sheet = "10xNQxGHo-sqMcnBN1eWg79pKT5gjaPV0lorzkvbyDEs"

ballers = read_sheet(name_sheet) %>% 
  as.data.frame()


# sheet_id <- "1BhRMSek1hv7UCQQY76uXYIwbwS6zH48Ir0m_SG2pzDE"
# 
# pickssofar = read_sheet(sheet_id, sheet = ROUND) %>% # USES UPDATED ROUND NUMBER MANUALLY INPUTTED ABOVE (DON'T FORGET!)
#   as.data.frame() %>%
#   pull(name) %>%
#   sort()