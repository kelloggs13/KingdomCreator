
# http://wiki.dominionstrategy.com/index.php/Dominion_(Base_Set)#Kingdom_cards.2C_second_edition
# http://wiki.dominionstrategy.com/index.php/Intrigue

# backlog:
# http://wiki.dominionstrategy.com/index.php/Dominion_(Base_Set)#Recommended_sets_of_10

# https://shiny.rstudio.com/articles/dynamic-ui.html
# https://stackoverflow.com/questions/33392784/make-bold-text-in-html-output-r-shiny

# todo:
# - check  "bridge" => set-zuordnung
# - add filter for defends: cards.web %>% filter(str_detect(Types, "Reaction") ) %>% select(Set, Name, Types) %>% arrange(Set, Name)
# - erweiterung um die most popular expansions
# - ideen / features von https://play.google.com/store/apps/details?id=com.minusik.apps.jackofalldominion&hl=en&gl=US

require(tidyverse)
require(readxl)
require(rvest)
require(shinyWidgets)
require(shiny)
require(stringr)
require(shinythemes)
require(shinyhelper)
require(shinydashboard)
require(shinyBS)

version.kg <- "0.2"


# Fetch card data from wiki.dominionstrategy.com ----

url <-  "http://wiki.dominionstrategy.com/index.php/List_of_cards"

webdata <- url %>% 
  read_html() %>% 
  html_nodes("table") %>% 
  html_table(fill = TRUE) 

cards.web <- webdata[1]
names(cards.web) <- "cards"
cards.web <- data.frame(cards.web$cards)

# sets and cards to include in dashboard ----

card.sets <- c("Base", "Base, 2E", "Intrigue", "Seaside")
card.types.excl <- c("Treasure", "Victory", "Curse")

cards.db <- cards.web %>% 
  filter(Set %in% card.sets &
           !(Types %in% card.types.excl)
         ) %>% 
  select(Name, Set, Types) %>% 
  mutate(Set = case_when(Set %in% c("Base", "Base, 2E") ~ "BaseSet 2nd Ed.",
                   TRUE ~ Set)
         )

# add flags for draw-, village-, trashing- and attack-cards ----

cards.draw <- c(# Base Set
                "Moat", "Smithy", "Council Room", "Laboratory", "Library", "Witch",
                # Intrigue
                "Courtyard", "Masquerade", "Shanty Town", "Steward", "Diplomat", "Secret Passage", "Patrol", "Torturer", "Nobles",
                # Seaside
                "Caravan", "Tide Pools", "Sea Witch", "Tactician", "Wharf"
                )

cards.village <- c(# Base Set
                  "Village", "Festival", 
                  # Intrigue
                  "Shanty Town", "Mining Village", "Nobles",
                  # Seaside
                  "Native Village", "Fishing Village", "Bazaar"
                )

cards.thrashing <- c(# Base Set
                    "Chapel", "Moneylender", "Remodel", "Mine", "Sentry", 
                    # Intrigue 
                    "Masquerade", "Steward", "Replace", "Trading Post", "Upgrade",
                    # Seaside
                    "Sailor", "Salvager"
                    )

cards.attack <- cards.db %>% filter(str_detect(Types, "Attack")) %>% pull(Name)

cards.db.flags <- cards.db %>% mutate(IsDraw = ifelse(Name %in% cards.draw, 1, 0)
                                        , IsVillage = ifelse(Name %in% cards.village, 1, 0)
                                        , IsTrashing = ifelse(Name %in% cards.thrashing, 1, 0)
                                        , IsAttack = ifelse(Name %in% cards.attack, 1, 0)
                                        )





