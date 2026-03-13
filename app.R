#
#    http://shiny.rstudio.com/
#


# add css styling to force names dropdown menu to actually drop downward
css_ddown <- "
          .vscomp-dropbox-container {
            bottom: 100%;
          }"

# TODO can this be deleted?
# if uncommented, this calculates cumulative scores and plots it interactively
# on the first tab.  But it makes the app open more slowly so I think not worth 
# it, especially if we get more poolers this time around!

# cumscores = 
#   ballers %>% 
#   filter(!Name %in% c("Choose your name", "guest")) %>% 
#   select(all_of(1:ROUND)) %>% 
#   pivot_longer(-Name, names_to = "round", values_to = "score") %>% 
#   group_by(Name) %>% 
#   mutate(cumu_score = cumsum(score),
#          numrd = 1:n()) %>% 
#   as.data.frame() %>% 
#   ggplot(aes(x  = numrd, y = cumu_score, color = Name)) + 
#   geom_line() + 
#   geom_point() + xlab("Round") + ylab("Cumulative score")

# after the 2025 tourney, I just saved the cumulative scores plot as an object 
# in the app, so it didn't need to be recalculated every time the app was loaded:
# cumscores = readRDS("./data/cumscores.rds")

# This is the brackets to pick from
bracket_id <- "19uxdcVHtyWFAKidNxK4Ydx29lIS8DFp_PxvXSAHRRVo"
ROUND <- read_sheet(bracket_id, sheet="round")$round[1]
bracket_final <- read_sheet(bracket_id, sheet = "Final")
bracket_r4 <- read_sheet(bracket_id, sheet = "R4")
bracket_r8 <- read_sheet(bracket_id, sheet = "R8")
bracket_r16 <- read_sheet(bracket_id, sheet = "R16")
bracket_r32 <- read_sheet(bracket_id, sheet = "R32")
bracket_r64 <- read_sheet(bracket_id, sheet = "R64")

# This is the spreadsheet housing picks per round per player
# leaving this here (instead of global.R) so each user gets latest list of picks when they open the app
submission_sheet_id <- "1BhRMSek1hv7UCQQY76uXYIwbwS6zH48Ir0m_SG2pzDE"
pickssofar = read_sheet(submission_sheet_id, sheet = ROUND) %>% # USES UPDATED ROUND NUMBER MANUALLY INPUTTED ABOVE (DON'T FORGET!)
  as.data.frame() %>%
  pull(name) %>%
  sort()


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  shinyjs::useShinyjs(),
  
  # little bit of code to add an "are you sure you want to submit" check before submission:
  tags$head(
    tags$script(src = 'custom.js')
  ),
  
  # adding favicon for fun
  tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),
  
  
  theme = bs_theme(version = 5, bootswatch = "flatly"),
    # Application title
    # titlePanel(title = div(img(src="an.jpg")),paste("Monkeybottom:", lubridate::year(lubridate::today()))),
    titlePanel(title = paste0("Monkeytop ", lubridate::year(lubridate::today()))),

    # Sidebar to choose pooler name, access other important info:  
    sidebarLayout(
        sidebarPanel(
          
          # selectInput("Name", "Choose your name", choices = ballers$Name),
          
          tags$head(
            tags$style(HTML(css_ddown))
          ),
          
          # using shinyWidgets::virtualSelectInput instead of selectInput to allow for autocomplete name search
          virtualSelectInput(inputId = "Name", label = "Choose your name", choices = ballers$Name, search = T, 
                             markSearchResults = TRUE, width = "100%"), 
          
          tags$a(href="https://docs.google.com/spreadsheets/d/10xNQxGHo-sqMcnBN1eWg79pKT5gjaPV0lorzkvbyDEs/edit?usp=sharing", "Link to scores", target="_blank"), 
          tags$br(),
          tags$a(href = "https://docs.google.com/document/d/1QrBNciLBz6WSCRsTHn-Hr0GXm3EvdjflMyfppg81Spc/edit?usp=sharing", "Link to rules", target="_blank"),
          tags$br(),
          tags$br(),
          actionButton("picks_in", "Whose picks are in?")
          
        ),
        
        # main panel to enter picks; idea is 
        mainPanel("Pick center",

                  # Last year's winner, commenting out for now:
                  # value_box(
                  #   title = "NOTE",
                  #   value = "Congrats to Monkeytop 2025 champion Paul 'Doc' Feldblum!",
                  #   showcase = bsicons::bs_icon("shield-exclamation"),
                  #   theme = "teal"
                  # ),
                  
                  tabsetPanel(
                    id = "my_tabs",
                    # ---------------- R64 ----------------------------------
                    # ggplot update means we get an error here, probably don't need to plot cumulative scores anyway (slows down app opening)
                    # tabPanel("Cumulative scores", 
                    #          
                    #          plotlyOutput("cumscores")
                    #          
                    #          ),
                    tabPanel("Round of 64" ,
                             value = "64",
                             # plotOutput("r1_scores")
                             
                             # games
                             
                             selectInput(bracket_r64$id[1],
                                         label = bracket_r64$label[1],
                                         choices = c(bracket_r64$`choice 1`[1], bracket_r64$`choice 2`[1])),
                             selectInput(bracket_r64$id[2],
                                         label = bracket_r64$label[2],
                                         choices = c(bracket_r64$`choice 1`[2], bracket_r64$`choice 2`[2])),
                             selectInput(bracket_r64$id[3],
                                         label = bracket_r64$label[3],
                                         choices = c(bracket_r64$`choice 1`[3], bracket_r64$`choice 2`[3])),
                             selectInput(bracket_r64$id[4],
                                         label = bracket_r64$label[4],
                                         choices = c(bracket_r64$`choice 1`[4], bracket_r64$`choice 2`[4])),
                             selectInput(bracket_r64$id[5],
                                         label = bracket_r64$label[5],
                                         choices = c(bracket_r64$`choice 1`[5], bracket_r64$`choice 2`[5])),
                             selectInput(bracket_r64$id[6],
                                         label = bracket_r64$label[6],
                                         choices = c(bracket_r64$`choice 1`[6], bracket_r64$`choice 2`[6])),
                             selectInput(bracket_r64$id[7],
                                         label = bracket_r64$label[7],
                                         choices = c(bracket_r64$`choice 1`[7], bracket_r64$`choice 2`[7])),
                             selectInput(bracket_r64$id[8],
                                         label = bracket_r64$label[8],
                                         choices = c(bracket_r64$`choice 1`[8], bracket_r64$`choice 2`[8])),

                             tags$hr(style="border-color: black;"),

                             selectInput(bracket_r64$id[9],
                                         label = bracket_r64$label[9],
                                         choices = c(bracket_r64$`choice 1`[9], bracket_r64$`choice 2`[9])),
                             selectInput(bracket_r64$id[10],
                                         label = bracket_r64$label[10],
                                         choices = c(bracket_r64$`choice 1`[10], bracket_r64$`choice 2`[10])),
                             selectInput(bracket_r64$id[11],
                                         label = bracket_r64$label[11],
                                         choices = c(bracket_r64$`choice 1`[11], bracket_r64$`choice 2`[11])),
                             selectInput(bracket_r64$id[12],
                                         label = bracket_r64$label[12],
                                         choices = c(bracket_r64$`choice 1`[12], bracket_r64$`choice 2`[12])),
                             selectInput(bracket_r64$id[13],
                                         label = bracket_r64$label[13],
                                         choices = c(bracket_r64$`choice 1`[13], bracket_r64$`choice 2`[13])),
                             selectInput(bracket_r64$id[14],
                                         label = bracket_r64$label[14],
                                         choices = c(bracket_r64$`choice 1`[14], bracket_r64$`choice 2`[14])),
                             selectInput(bracket_r64$id[15],
                                         label = bracket_r64$label[15],
                                         choices = c(bracket_r64$`choice 1`[15], bracket_r64$`choice 2`[15])),
                             selectInput(bracket_r64$id[16],
                                         label = bracket_r64$label[16],
                                         choices = c(bracket_r64$`choice 1`[16], bracket_r64$`choice 2`[15])),

                             tags$hr(style="border-color: black;"),

                             selectInput(bracket_r64$id[16],
                                         label = bracket_r64$label[16],
                                         choices = c(bracket_r64$`choice 1`[16], bracket_r64$`choice 2`[16])),
                             selectInput(bracket_r64$id[17],
                                         label = bracket_r64$label[17],
                                         choices = c(bracket_r64$`choice 1`[17], bracket_r64$`choice 2`[17])),
                             selectInput(bracket_r64$id[18],
                                         label = bracket_r64$label[18],
                                         choices = c(bracket_r64$`choice 1`[18], bracket_r64$`choice 2`[18])),
                             selectInput(bracket_r64$id[19],
                                         label = bracket_r64$label[19],
                                         choices = c(bracket_r64$`choice 1`[19], bracket_r64$`choice 2`[19])),
                             selectInput(bracket_r64$id[20],
                                         label = bracket_r64$label[20],
                                         choices = c(bracket_r64$`choice 1`[20], bracket_r64$`choice 2`[20])),
                             selectInput(bracket_r64$id[21],
                                         label = bracket_r64$label[21],
                                         choices = c(bracket_r64$`choice 1`[21], bracket_r64$`choice 2`[21])),
                             selectInput(bracket_r64$id[22],
                                         label = bracket_r64$label[22],
                                         choices = c(bracket_r64$`choice 1`[22], bracket_r64$`choice 2`[22])),
                             selectInput(bracket_r64$id[23],
                                         label = bracket_r64$label[23],
                                         choices = c(bracket_r64$`choice 1`[23], bracket_r64$`choice 2`[23])),
                             
                             tags$hr(style="border-color: black;"),
                             
                             selectInput(bracket_r64$id[24],
                                         label = bracket_r64$label[24],
                                         choices = c(bracket_r64$`choice 1`[24], bracket_r64$`choice 2`[24])),
                             selectInput(bracket_r64$id[25],
                                         label = bracket_r64$label[25],
                                         choices = c(bracket_r64$`choice 1`[25], bracket_r64$`choice 2`[25])),
                             selectInput(bracket_r64$id[26],
                                         label = bracket_r64$label[26],
                                         choices = c(bracket_r64$`choice 1`[26], bracket_r64$`choice 2`[26])),
                             selectInput(bracket_r64$id[27],
                                         label = bracket_r64$label[27],
                                         choices = c(bracket_r64$`choice 1`[27], bracket_r64$`choice 2`[27])),
                             selectInput(bracket_r64$id[28],
                                         label = bracket_r64$label[28],
                                         choices = c(bracket_r64$`choice 1`[28], bracket_r64$`choice 2`[28])),
                             selectInput(bracket_r64$id[29],
                                         label = bracket_r64$label[29],
                                         choices = c(bracket_r64$`choice 1`[29], bracket_r64$`choice 2`[29])),
                             selectInput(bracket_r64$id[30],
                                         label = bracket_r64$label[30],
                                         choices = c(bracket_r64$`choice 1`[30], bracket_r64$`choice 2`[30])),
                             selectInput(bracket_r64$id[31],
                                         label = bracket_r64$label[31],
                                         choices = c(bracket_r64$`choice 1`[31], bracket_r64$`choice 2`[31])),

                             tags$hr(style="border-color: black;"),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ),
                    
                    # ------------------- R32 --------------------------------------
                    
                    tabPanel("Round of 32",
                             value = "32",
                             plotOutput("r2_scores"),
                             
                             selectInput(bracket_r32$id[1],
                                         label = bracket_r32$label[1],
                                         choices = c(bracket_r32$`choice 1`[1], bracket_r32$`choice 2`[1])),
                             selectInput(bracket_r32$id[2],
                                         label = bracket_r32$label[2],
                                         choices = c(bracket_r32$`choice 1`[2], bracket_r32$`choice 2`[2])),
                             selectInput(bracket_r32$id[3],
                                         label = bracket_r32$label[3],
                                         choices = c(bracket_r32$`choice 1`[3], bracket_r32$`choice 2`[3])),
                             selectInput(bracket_r32$id[4],
                                         label = bracket_r32$label[4],
                                         choices = c(bracket_r32$`choice 1`[4], bracket_r32$`choice 2`[4])),

                             tags$hr(style="border-color: black;"),

                             selectInput(bracket_r32$id[5],
                                         label = bracket_r32$label[5],
                                         choices = c(bracket_r32$`choice 1`[5], bracket_r32$`choice 2`[5])),
                             selectInput(bracket_r32$id[6],
                                         label = bracket_r32$label[6],
                                         choices = c(bracket_r32$`choice 1`[6], bracket_r32$`choice 2`[6])),
                             selectInput(bracket_r32$id[7],
                                         label = bracket_r32$label[7],
                                         choices = c(bracket_r32$`choice 1`[7], bracket_r32$`choice 2`[7])),
                             selectInput(bracket_r32$id[8],
                                         label = bracket_r32$label[8],
                                         choices = c(bracket_r32$`choice 1`[8], bracket_r32$`choice 2`[8])),
                             
                             tags$hr(style="border-color: black;"),

                             selectInput(bracket_r32$id[9],
                                         label = bracket_r32$label[9],
                                         choices = c(bracket_r32$`choice 1`[9], bracket_r32$`choice 2`[9])),
                             selectInput(bracket_r32$id[10],
                                         label = bracket_r32$label[10],
                                         choices = c(bracket_r32$`choice 1`[10], bracket_r32$`choice 2`[10])),
                             selectInput(bracket_r32$id[11],
                                         label = bracket_r32$label[11],
                                         choices = c(bracket_r32$`choice 1`[11], bracket_r32$`choice 2`[11])),
                             selectInput(bracket_r32$id[12],
                                         label = bracket_r32$label[12],
                                         choices = c(bracket_r32$`choice 1`[12], bracket_r32$`choice 2`[12])),

                             tags$hr(style="border-color: black;"),

                             selectInput(bracket_r32$id[13],
                                         label = bracket_r32$label[13],
                                         choices = c(bracket_r32$`choice 1`[13], bracket_r32$`choice 2`[13])),
                             selectInput(bracket_r32$id[14],
                                         label = bracket_r32$label[14],
                                         choices = c(bracket_r32$`choice 1`[14], bracket_r32$`choice 2`[14])),
                             selectInput(bracket_r32$id[15],
                                         label = bracket_r32$label[15],
                                         choices = c(bracket_r32$`choice 1`[15], bracket_r32$`choice 2`[15])),
                             selectInput(bracket_r32$id[16],
                                         label = bracket_r32$label[16],
                                         choices = c(bracket_r32$`choice 1`[16], bracket_r32$`choice 2`[15])),

                             tags$hr(style="border-color: black;"),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             ),
                    # ------------------- R16 ----------------------------------
                    
                    tabPanel("Sweet 16" ,
                             value = "sweet_16",
                             plotOutput("r3_scores"),
                             card(card_header(bracket_r16$header[1]),
                                  selectInput(bracket_r16$id[1],
                                              label = bracket_r16$label[1],
                                              choices = c(bracket_r16$`choice 1`[1], bracket_r16$`choice 2`[1])),
                                  numericInput("s1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                                  ),
                             card(card_header(bracket_r16$header[2]),
                                  selectInput(bracket_r16$id[2],
                                              label = bracket_r16$label[2],
                                              choices = c(bracket_r16$`choice 1`[2], bracket_r16$`choice 2`[2])),
                                  numericInput("s2score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r16$header[3]),
                                  selectInput(bracket_r16$id[3],
                                              label = bracket_r16$label[3],
                                              choices = c(bracket_r16$`choice 1`[3], bracket_r16$`choice 2`[3])),
                                  numericInput("w1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),
                             card(card_header(bracket_r16$header[4]),
                                  selectInput(bracket_r16$id[4],
                                              label = bracket_r16$label[4],
                                              choices = c(bracket_r16$`choice 1`[4], bracket_r16$`choice 2`[4])),
                                  numericInput("w2score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r16$header[5]),
                                  selectInput(bracket_r16$id[5],
                                              label = bracket_r16$label[5],
                                              choices = c(bracket_r16$`choice 1`[5], bracket_r16$`choice 2`[5])),
                                  numericInput("e1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),
                             card(card_header(bracket_r16$header[6]),
                                  selectInput(bracket_r16$id[6],
                                              label = bracket_r16$label[6],
                                              choices = c(bracket_r16$`choice 1`[6], bracket_r16$`choice 2`[6])),
                                  numericInput("e2score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r16$header[7]),
                                  selectInput(bracket_r16$id[7],
                                              label = bracket_r16$label[7],
                                              choices = c(bracket_r16$`choice 1`[7], bracket_r16$`choice 2`[7])),
                                  numericInput("mw1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),
                             card(card_header(bracket_r16$header[8]),
                                  selectInput(bracket_r16$id[8],
                                              label = bracket_r16$label[8],
                                              choices = c(bracket_r16$`choice 1`[8], bracket_r16$`choice 2`[8])),
                                  numericInput("mw2score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ), # once we get here (and start recording spreads, use card())
                    
# ----------- Elite 8 -------------------------------------------------
                    tabPanel("Elite 8" ,
                             value = "elite_8",
                             plotOutput("r4_scores"),
                             card(card_header(bracket_r8$header[1]),
                                  selectInput(bracket_r8$id[1],
                                              label = bracket_r8$label[1],
                                              choices = c(bracket_r8$`choice 1`[1], bracket_r8$`choice 2`[1])),
                                  numericInput("s1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r8$header[2]),
                                  selectInput(bracket_r8$id[2],
                                              label = bracket_r8$label[2],
                                              choices = c(bracket_r8$`choice 1`[2], bracket_r8$`choice 2`[2])),
                                  numericInput("w1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r8$header[3]),
                                  selectInput(bracket_r8$id[3],
                                              label = bracket_r8$label[3],
                                              choices = c(bracket_r8$`choice 1`[3], bracket_r8$`choice 2`[3])),
                                  numericInput("e1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             card(card_header(bracket_r8$header[4]),
                                  selectInput(bracket_r8$id[4],
                                              label = bracket_r8$label[4],
                                              choices = c(bracket_r8$`choice 1`[4], bracket_r8$`choice 2`[4])),
                                  numericInput("mw1score", label = "spread",
                                            value = "")#, placeholder = "point spread")
                             ),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ),

                  # ----------------- Final 4 ------------------
                    tabPanel("Final 4", 
                             value = "final_4",
                             
                             plotOutput("r5_scores"),
                             
                             # TODO dry this up, maybe lapply?
                             card(card_header(bracket_r4$header[1]),
                                  selectInput(bracket_r4$header[1],
                                              label = bracket_r4$label[1],
                                              choices = c(bracket_r4$`choice 1`[1], bracket_r4$`choice 2`[1])),
                                  numericInput("w1score", label = "spread", value = "")
                             ),
                             card(card_header(bracket_r4$header[2]),
                                  selectInput(bracket_r4$header[2],
                                             label = bracket_r4$label[2],
                                             choices = c(bracket_r4$`choice 1`[2], bracket_r4$`choice 2`[2])),
                                  numericInput("e1score", label = "spread", value = "")
                             ),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ),

                  # ---------------- title game -------------

                    tabPanel("Title Game",
                             value = "title",
                             
                             plotOutput("r6_scores"),
                             card(card_header("Championship game"),
                                  selectInput("w1",
                                              label = bracket_final$label,
                                              choices = c(bracket_final$`choice 1`, bracket_final$`choice 2`)),
                                  numericInput("w1score", label = "spread",
                                               value = "")#, placeholder = "point spread")
                             ),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             )))
    )
)

# ---------------- server logic ----------------

server <- function(input, output) {

  # input validation: adjust as scores are introduced: 
  iv <- InputValidator$new()
  # iv$add_rule("s1", sv_required())
  # iv$add_rule("w1", sv_required())
  # iv$add_rule("e1", sv_required())
  # iv$add_rule("mw1", sv_required())
  # iv$add_rule("s1score", sv_required())
  # iv$add_rule("s1score", sv_integer())
  # iv$add_rule("w1score", sv_required())
  # iv$add_rule("w1score", sv_integer())
  # iv$add_rule("e1score", sv_required())
  # iv$add_rule("e1score", sv_integer())
  # iv$add_rule("mw1score", sv_required())
  # iv$add_rule("mw1score", sv_integer())
  # iv$enable()
  
  # interactive cumulative scores plot, commenting out for now:
  # output$cumscores = renderPlotly({
  #   
  #   ggplotly(cumscores)
  #   
  # })
  
  # round-by-round scores distributions just to have something to look at 
  # on each tab, open to better ideas!  For now commenting out, can uncomment 
  # as each round progresses: 
  
  # output$r1_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = R64_score)) +
  #     geom_bar() + xlab("Round 1 scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Round of 64") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #   
  #   # return(hist(ballers$R64_score))
  # })
  
  # output$r2_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = R32_score)) +
  #     geom_bar() + xlab("Round 2 scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Round of 32") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #   
  #   # return(hist(ballers$R64_score))
  # })
  
  # output$r3_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = R16_score)) +
  #     geom_bar() + xlab("Sweet 16 scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Sweet 16") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #     
    # return(hist(ballers$R64_score))
  # })
  
  # output$r4_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = R8_score)) +
  #     geom_bar() + xlab("Elite 8 scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Elite 8") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #   
  #   # return(hist(ballers$R64_score))
  # })
  
  # output$r5_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = FF_score)) +
  #     geom_bar() + xlab("Final Four scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Final Four") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #   
  #   # return(hist(ballers$R64_score))
  # })
  
  # output$r6_scores <- renderPlot({
  #   ballers %>% 
  #     ggplot(aes(x = Champ_score)) +
  #     geom_bar() + xlab("Champ. game scores") +
  #     ylab("Frequency") + ggtitle("Distribution of scores, Championship game") + 
  #     scale_x_continuous(breaks = breaks_pretty()) %>% 
  #     return()
  #   
  #   # return(hist(ballers$R64_score))
  # })
  
  user_selections <- reactive({
    
    # build data frame to add to picks sheet (comment out later round games as pool shrinks)
    # TODO make sure none of these variable ids have been messed up when changing the card definitions
    data.frame(
      name = input$Name,
      submit_time = lubridate::now(),
      s1 = input$s1,
      s2 = input$s2,
      s3 = input$s3,
      s4 = input$s4,
      s5 = input$s5,
      s6 = input$s6,
      s7 = input$s7,
      s8 = input$s8,
      w1 = input$w1,
      w2 = input$w2,
      w3 = input$w3,
      w4 = input$w4,
      w5 = input$w5,
      w6 = input$w6,
      w7 = input$w7,
      w8 = input$w8,
      e1 = input$e1,
      e2 = input$e2,
      e3 = input$e3,
      e4 = input$e4,
      e5 = input$e5,
      e6 = input$e6,
      e7 = input$e7,
      e8 = input$e8,
      mw1 = input$mw1,
      mw2 = input$mw2,
      mw3 = input$mw3,
      mw4 = input$mw4,
      mw5 = input$mw5,
      mw6 = input$mw6,
      mw7 = input$mw7,
      mw8 = input$mw8,
      notes = input$usernote
    )
    
    # data frame for later rounds: 
    
    # data.frame(name = input$Name,
    #            submit_time = lubridate::now(),
    #            games = c(#"s1", #"s2", 
    #                      "w1" #, #"w2", 
    #                      # "e1", #"e2", 
    #                      # "mw1"#, "mw2"
    #                      ),
    #            picks = c(#input$s1, #input$s2, 
    #                      input$w1 #, #input$w2,
    #                      # input$e1, #input$e2, 
    #                      # input$mw1#, input$mw2
    #                      ),
    #            spreads = c(#input$s1score, #input$s2score, 
    #                        input$w1score#, #input$w2score,
    #                        # input$e1score, #input$e2score, 
    #                        # input$mw1score#, input$mw2score
    #                        ),
    #            notes = input$usernote)
  })
  
  observeEvent(input$picks_in, {
    
    pickssofar = # "See you March 2026"
      read_sheet(submission_sheet_id, sheet = ROUND) %>% # UPDATED ROUND (MANUALLY INPUT ABOVE)
      as.data.frame() %>%
      pull(name) %>%
      unique() %>%
      sort()
    
    nopicks = #"Congrats to Doc F!"
      ballers %>%
      filter(!Name %in% c("guest", "Choose your name")) %>%
      pull(Name) %>%
      setdiff(., pickssofar)
    
    showModal(modalDialog(
      title = "Picks so far this round:",
      paste0("ROUND ", ROUND, " PICKS: ",paste(pickssofar, collapse = ", ")),
      tags$br(),
      tags$br(),
      paste0("MISSING PICKS: ", paste(nopicks, collapse = ", ")),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  observeEvent(input$Name,{
    
    # can't submit picks without choosing your name from the list
    shinyjs::toggleState(id = "submit", condition = input$Name != "Choose your name")
    
  })
  
  # append picks data to picks google sheet, disable submission button afterwards!
  observeEvent(input$submit, {
    sheet_append(ss = submission_sheet_id, data = user_selections(), sheet = ROUND) # updated above manually before each new round!
    
    shinyjs::disable("submit")
  })
  
  observe({
    if (ROUND == 1) {
      showTab(inputId = "my_tabs", target = "64")
      hideTab(inputId = "my_tabs", target = "32")
      hideTab(inputId = "my_tabs", target = "sweet_16")
      hideTab(inputId = "my_tabs", target = "elite_8")
      hideTab(inputId = "my_tabs", target = "final_4")
      hideTab(inputId = "my_tabs", target = "title")
    } 
    if (ROUND == 2) {
      showTab(inputId = "my_tabs", target = "64")
      showTab(inputId = "my_tabs", target = "32")
      hideTab(inputId = "my_tabs", target = "sweet_16")
      hideTab(inputId = "my_tabs", target = "elite_8")
      hideTab(inputId = "my_tabs", target = "final_4")
      hideTab(inputId = "my_tabs", target = "title")
    } 
    if (ROUND == 3) {
      showTab(inputId = "my_tabs", target = "64")
      showTab(inputId = "my_tabs", target = "32")
      showTab(inputId = "my_tabs", target = "sweet_16")
      hideTab(inputId = "my_tabs", target = "elite_8")
      hideTab(inputId = "my_tabs", target = "final_4")
      hideTab(inputId = "my_tabs", target = "title")
    } 
    if (ROUND == 4) {
      showTab(inputId = "my_tabs", target = "64")
      showTab(inputId = "my_tabs", target = "32")
      showTab(inputId = "my_tabs", target = "sweet_16")
      showTab(inputId = "my_tabs", target = "elite_8")
      hideTab(inputId = "my_tabs", target = "final_4")
      hideTab(inputId = "my_tabs", target = "title")
    } 
    if (ROUND == 5) {
      showTab(inputId = "my_tabs", target = "64")
      showTab(inputId = "my_tabs", target = "32")
      showTab(inputId = "my_tabs", target = "sweet_16")
      showTab(inputId = "my_tabs", target = "elite_8")
      showTab(inputId = "my_tabs", target = "final_4")
      hideTab(inputId = "my_tabs", target = "title")
    }
    if (ROUND == 6) {
      showTab(inputId = "my_tabs", target = "64")
      showTab(inputId = "my_tabs", target = "32")
      showTab(inputId = "my_tabs", target = "sweet_16")
      showTab(inputId = "my_tabs", target = "elite_8")
      showTab(inputId = "my_tabs", target = "final_4")
      showTab(inputId = "my_tabs", target = "title")
    }
    
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
