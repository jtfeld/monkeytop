#
#    http://shiny.rstudio.com/
#


ROUND = 3 # <-- UPDATE MANUALLY FOR EACH ROUND

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

# This is the brackts to pick from
bracket_id <- "19uxdcVHtyWFAKidNxK4Ydx29lIS8DFp_PxvXSAHRRVo"
# TODO use this variable instead of ROUND so we can be dynamic
round <- read_sheet(bracket_id, sheet="round")$round[1]
# TODO get the bracket for each round, current pattern will return NA in pick feild if can't find index, this seems fine
bracket_final <- read_sheet(bracket_id, sheet = "Final")
bracket_r4 <- read_sheet(bracket_id, sheet = "R4")

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
                             
                             # games (just have to auto-add teams here): 
                             
                             selectInput("s1",
                                         label = "South, 1-16",
                                         choices = c("1. Auburn", "16. Alabama St.")),
                             selectInput("s2",
                                         label = "South, 8-9",
                                         choices = c("8. Louisville", "9. Creighton")),
                             selectInput("s3",
                                         label = "South, 5-12",
                                         choices = c("5. Michigan", "12. UC San Diego")),
                             selectInput("s4",
                                         label = "South, 4-13",
                                         choices = c("4. Texas A&M", "13. Yale")),
                             selectInput("s5",
                                         label = "South, 6-11",
                                         choices = c("6. Ole Miss", "11. UNC")),
                             selectInput("s6",
                                         label = "South, 3-14",
                                         choices = c("3. Iowa St", "14. Lipscomb")),
                             selectInput("s7",
                                         label = "South, 7-10",
                                         choices = c("7. Marquette", "10. New Mexico")),
                             selectInput("s8",
                                         label = "South, 2-15",
                                         choices = c("2. Michigan St.", "15. Bryant")),

                             tags$hr(style="border-color: black;"),

                             selectInput("w1",
                                         label = "West, 1-16",
                                         choices = c("1. Florida", "16. Norfolk St.")),
                             selectInput("w2",
                                         label = "West, 8-9",
                                         choices = c("8. UConn", "9. Oklahoma")),
                             selectInput("w3",
                                         label = "West, 5-12",
                                         choices = c("5. Memphis", "12. Colorado St.")),
                             selectInput("w4",
                                         label = "West, 4-13",
                                         choices = c("4. Maryland", "13. Grand Canyon")),
                             selectInput("w5",
                                         label = "West, 6-11",
                                         choices = c("6. Mizzou", "11. Drake")),
                             selectInput("w6",
                                         label = "West, 3-14",
                                         choices = c("3. Texas Tech", "14. UNC Wilmington")),
                             selectInput("w7",
                                         label = "West, 7-10",
                                         choices = c("7. Kansas", "10. Arkansas")),
                             selectInput("w8",
                                         label = "West, 2-15",
                                         choices = c("2. St. John's", "15. Omaha")),

                             tags$hr(style="border-color: black;"),

                             selectInput("e1",
                                         label = "East, 1-16",
                                         choices = c("1. Duke", "16. American/Mt. St. Mary's")),
                             selectInput("e2",
                                         label = "East, 8-9",
                                         choices = c("8. Miss. St.", "9. Baylor")),
                             selectInput("e3",
                                         label = "East, 5-12",
                                         choices = c("5. Oregon", "12. Liberty")),
                             selectInput("e4",
                                         label = "East, 4-13",
                                         choices = c("4. Arizona", "13. Akron")),
                             selectInput("e5",
                                         label = "East, 6-11",
                                         choices = c("6. BYU", "11. VCU")),
                             selectInput("e6",
                                         label = "East, 3-14",
                                         choices = c("3. Wisconsin", "14. Montana")),
                             selectInput("e7",
                                         label = "East, 7-10",
                                         choices = c("7. Saint Mary's", "10. Vanderbilt")),
                             selectInput("e8",
                                         label = "East, 2-15",
                                         choices = c("2. Alabama", "15. Robert Morris")),

                             tags$hr(style="border-color: black;"),

                             selectInput("mw1",
                                         label = "MidWest, 1-16",
                                         choices = c("1. Houston", "16. SIU Edwardsville")),
                             selectInput("mw2",
                                         label = "MidWest, 8-9",
                                         choices = c("8. Gonzaga", "9. Georgia")),
                             selectInput("mw3",
                                         label = "MidWest, 5-12",
                                         choices = c("5. Clemson", "12. McNeese")),
                             selectInput("mw4",
                                         label = "MidWest, 4-13",
                                         choices = c("4. Purdue", "13. High Point")),
                             selectInput("mw5",
                                         label = "MidWest, 6-11",
                                         choices = c("6. Illinois", "11. Texas/Xavier")),
                             selectInput("mw6",
                                         label = "MidWest, 3-14",
                                         choices = c("3. Kentucky", "14. Troy")),
                             selectInput("mw7",
                                         label = "MidWest, 7-10",
                                         choices = c("7. UCLA", "10. Utah St.")),
                             selectInput("mw8",
                                         label = "MidWest, 2-15",
                                         choices = c("2. Tennessee", "15. Wofford")),

                             tags$hr(style="border-color: black;"),

                             textInput("usernote",
                                       label = "Additional notes:",
                                       placeholder = "other comments, notes, etc?"),

                             actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ),
                    
                    # ------------------- R32 --------------------------------------
                    
                    tabPanel("Round of 32",
                             value = "32",
                             plotOutput("r2_scores")
                             
                             # selectInput("s1",
                             #             label = "South g1",
                             #             choices = c("1. Auburn", "9. Creighton")),
                             # selectInput("s2",
                             #             label = "South g2",
                             #             choices = c("5. Michigan", "4. Texas A&M")),
                             # selectInput("s3",
                             #             label = "South g3",
                             #             choices = c("6. Ole Miss", "3. Iowa St.")),
                             # selectInput("s4",
                             #             label = "South g4",
                             #             choices = c("10. New Mexico", "2. Michigan St.")),
                             # 
                             # tags$hr(style="border-color: black;"),
                             # 
                             # selectInput("w1",
                             #             label = "West g1",
                             #             choices = c("1. Florida", "8. UConn")),
                             # selectInput("w2",
                             #             label = "West g2",
                             #             choices = c("12. Colorado St.", "4. Maryland")),
                             # selectInput("w3",
                             #             label = "West g3",
                             #             choices = c("11. Drake", "3. Texas Tech")),
                             # selectInput("w4",
                             #             label = "West g4",
                             #             choices = c("10. Arkansas", "2. St. John's")),
                             # 
                             # tags$hr(style="border-color: black;"),
                             # 
                             # selectInput("e1",
                             #             label = "East g1",
                             #             choices = c("1. Duke", "9. Baylor")),
                             # selectInput("e2",
                             #             label = "East g2",
                             #             choices = c("5. Oregon", "4. Arizona")),
                             # selectInput("e3",
                             #             label = "East g3",
                             #             choices = c("6. BYU", "3. Wisconsin")),
                             # selectInput("e4",
                             #             label = "East g4",
                             #             choices = c("7. St. Mary's", "2. Alabama")),
                             # 
                             # tags$hr(style="border-color: black;"),
                             # 
                             # selectInput("mw1",
                             #             label = "MidWest g1",
                             #             choices = c("1. Houston", "8. Gonzaga")),
                             # selectInput("mw2",
                             #             label = "MidWest g2",
                             #             choices = c("12. McNeese", "4. Purdue")),
                             # selectInput("mw3",
                             #             label = "MidWest g3",
                             #             choices = c("6. Illinois", "3. Kentucky")),
                             # selectInput("mw4",
                             #             label = "MidWest g4",
                             #             choices = c("7. UCLA", "2. Tennessee")),
                             # 
                             # tags$hr(style="border-color: black;"),
                             # 
                             # textInput("usernote", 
                             #           label = "Additional notes:",
                             #           placeholder = "other comments, notes, etc?"),
                             # 
                             # actionButton("submit", "Submit", icon = icon("upload"))
                             ),
                    # ------------------- R16 ----------------------------------
                    
                    tabPanel("Sweet 16" ,
                             value = "sweet_16",
                             plotOutput("r3_scores")
                    #          
                    #          
                    #          card(card_header("South g1"),
                    #               selectInput("s1",
                    #                           label = "Pick",
                    #                           choices = c("1. Auburn", "5. Michigan")),
                    #               numericInput("s1score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #               ),
                    #          card(card_header("South g2"),
                    #               selectInput("s2",
                    #                           label = "Pick",
                    #                           choices = c("6. Ole Miss", "2. Michigan St.")),
                    #               numericInput("s2score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          
                    #          card(card_header("West g1"),
                    #               selectInput("w1",
                    #                           label = "Pick",
                    #                           choices = c("1. Florida", "4. Maryland")),
                    #               numericInput("w1score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          card(card_header("West g2"),
                    #               selectInput("w2",
                    #                           label = "Pick",
                    #                           choices = c("3. Texas Tech", "10. Arkansas")),
                    #               numericInput("w2score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          
                    #          card(card_header("East g1"),
                    #               selectInput("e1",
                    #                           label = "Pick",
                    #                           choices = c("1. Duke", "4. Zona")),
                    #               numericInput("e1score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          card(card_header("East g2"),
                    #               selectInput("e2",
                    #                           label = "Pick",
                    #                           choices = c("6. BYU", "2. Alabama")),
                    #               numericInput("e2score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          
                    #          card(card_header("Midwest g1"),
                    #               selectInput("mw1",
                    #                           label = "Pick",
                    #                           choices = c("1. Houston", "4. Purdue")),
                    #               numericInput("mw1score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ),
                    #          card(card_header("Midwest g2"),
                    #               selectInput("mw2",
                    #                           label = "Pick",
                    #                           choices = c("3. Kentucky", "2. Tennessee")),
                    #               numericInput("mw2score", label = "spread", 
                    #                         value = "")#, placeholder = "point spread")
                    #          ), 
                    #          
                    #          textInput("usernote", 
                    #                    label = "Additional notes:",
                    #                    placeholder = "other comments, notes, etc?"),
                    #          
                    #          actionButton("submit", "Submit", icon = icon("upload"))
                             
                             ), # once we get here (and start recording spreads, use card())
                    
# ----------- Elite 8 -------------------------------------------------
                    tabPanel("Elite 8" ,
                             value = "elite_8",
                             plotOutput("r4_scores")
                             
                             
                             # card(card_header("South g1"),
                             #      selectInput("s1",
                             #                  label = "Pick",
                             #                  choices = c("1. Auburn", "2. Michigan St.")),
                             #      numericInput("s1score", label = "spread", 
                             #                value = "")#, placeholder = "point spread")
                             # ),
                             # 
                             # card(card_header("West g1"),
                             #      selectInput("w1",
                             #                  label = "Pick",
                             #                  choices = c("1. Florida", "3. Texas Tech")),
                             #      numericInput("w1score", label = "spread", 
                             #                value = "")#, placeholder = "point spread")
                             # ),
                             # 
                             # card(card_header("East g1"),
                             #      selectInput("e1",
                             #                  label = "Pick",
                             #                  choices = c("1. Duke", "2. Alabama")),
                             #      numericInput("e1score", label = "spread", 
                             #                value = "")#, placeholder = "point spread")
                             # ),
                             # 
                             # card(card_header("Midwest g1"),
                             #      selectInput("mw1",
                             #                  label = "Pick",
                             #                  choices = c("1. Houston", "2. Tennessee")),
                             #      numericInput("mw1score", label = "spread", 
                             #                value = "")#, placeholder = "point spread")
                             # ),
                             # 
                             # textInput("usernote", 
                             #           label = "Additional notes:",
                             #           placeholder = "other comments, notes, etc?"),
                             # 
                             # actionButton("submit", "Submit", icon = icon("upload"))
                             
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
