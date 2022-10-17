

# CSS styles ----

style.text.about <- "font-family: Verdana; 
                     color: white; 
                     font-size: 12px; 
                     width: 15%; 
                     background: #303030; 
                     padding-top: 20px;
                     padding-bottom: 20px;
                     padding-left: 20px;
                     padding-right: 20px;
                    "

style.text.kingdom <- "color:white; 
                       background: #303030;
                       font-family: Verdana; 
                       border-radius: 25px; 
                       padding-top: 10px;
                       padding-bottom: 10px;
                       padding-left: 20px;
                      "

# UI ----

shinyUI(navbarPage(title = paste0("Kingdom Generator V", version.kg), 
                   theme = shinytheme("darkly"), 
                   setBackgroundImage(src = "./images/background.jpg"),
                   
                  
   # About section ----
   tabPanel('About',
            
            div(
              "This dashboard provides randomly generated card selections ('Kingdoms') for the card game"
              , a(href="https://www.riograndegames.com/games/dominion/", "Dominion")
              , "and these kingdoms can then be easily played on www.dominion.games via copy&paste"
              , style = style.text.about
            ),
            
            div("The user can choose if the kingdom should be balanced or not"
                , br()
                , br()
                , "Balanced means the kingdom will contain at least 1x Village, 1x Draw, 1x Attack and 1x Trasher"
                , br()
                , br()
                , "Unbalanced means the Kingdom is created completely at random"
                , style = style.text.about
            ),

            div(
              "The generator tries 100x to find a suitable kingdom consisting of 10 cards. 
               After 100 unsuccessful attempts it gives up and returns the last kingdom found, even if this kingdom has less than 10 cards."
              , style = style.text.about
            ),
            
            div(
              "Card data and card images are being sourced live from "
              , a(href="http://wiki.dominionstrategy.com/index.php/List_of_cards", "http://wiki.dominionstrategy.com")
              , style = style.text.about
            ),
            
            div(
              "Additional Resources:"
              , br()
              , a(href="https://www.dominion.games", "Play Dominion Online")
              , br()
              , a(href="https://boardgamegeek.com/boardgame/36218/dominion", "Dominion on BoardGameGeek")
              , style = style.text.about
            ),
            
           ), 

    # Generator ----
    tabPanel('Generator',
               
      # User Inputs
      sidebarLayout(
          sidebarPanel(width = 4,
              
              h4("Sets to include"),
              pickerInput('select_set', NULL, choices = unique(cards.db.flags$Set), selected = c("BaseSet 2nd Ed."), multiple = TRUE ),
              
              hr(),
              
              h4("Type of Kingdom"),
              
              radioGroupButtons('is_kingdom_balanced', NULL, selected = "Balanced", choices = c("Balanced", "Unbalanced")),
             
              conditionalPanel(
                condition = "input.is_kingdom_balanced === 'Unbalanced'",
                prettySwitch('remove_draw', 'Remove Draw?', value = FALSE, status = "success") ,
                prettySwitch('remove_village', 'Remove Villages?', value = FALSE, status = "success"),
                prettySwitch('remove_trashing', 'Remove Trashing?', value = FALSE, status = "success"),
                prettySwitch('remove_attacks', 'Remove Attacks?', value = FALSE, status = "success"),
              ),
              
              hr(),
              
              actionButton("create_kingdom", "Create new kingdom", class = "btn-primary"),
          ),

        # Kingdom
        mainPanel(
          h4(span(textOutput("kingdom.text")), style = style.text.kingdom),

          verbatimTextOutput("kingdom.src"),
          
          h4(span(textOutput("kingdom.title")), style = style.text.kingdom),

          flowLayout(imageOutput("pic1"), imageOutput("pic2"), imageOutput("pic3"), imageOutput("pic4"), imageOutput("pic5"),
                     imageOutput("pic6"), imageOutput("pic7"), imageOutput("pic8"), imageOutput("pic9"), imageOutput("pic10"))
          )
      )
    ) 
))
