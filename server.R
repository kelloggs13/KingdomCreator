


shinyServer(function(input, output) {
  observeEvent(input$create_kingdom, {
    
    draw.success <- FALSE
    draw.counter <- 1

    while(draw.success == FALSE & draw.counter <= 100) {
      
      cards.kingdom <- cards.db.flags

      cards.kingdom <- cards.kingdom %>% filter(Set %in% input$select_set)

      if(input$is_kingdom_balanced == "Balanced") {
        cards.kingdom <- cards.kingdom[sample(nrow(cards.kingdom)), ]
        card.attack <- cards.kingdom %>% filter(IsAttack == 1) %>% head(1) %>% pull(Name)
        card.draw <- cards.kingdom %>% filter(IsDraw == 1) %>% head(1) %>% pull(Name)
        card.village <- cards.kingdom %>% filter(IsVillage == 1) %>% head(1) %>% pull(Name)
        card.trashing <- cards.kingdom %>% filter(IsTrashing == 1) %>% head(1) %>% pull(Name)

        cards.balanced <- c(card.attack, card.draw, card.village, card.trashing)
        n.cards.balanced <- length(cards.balanced)

        kingdom <- c(
          cards.kingdom %>% filter(Name %in% cards.balanced) %>% pull(Name),
          cards.kingdom %>% filter(!(Name %in% cards.balanced)) %>% head(10 - n.cards.balanced) %>% pull(Name)
        ) %>% paste0(collapse = ",")
      }

      if(input$is_kingdom_balanced == "Unbalanced") {
        if(input$remove_draw == TRUE) cards.kingdom <- cards.kingdom %>% filter(IsDraw == 0)
        if(input$remove_village == TRUE) cards.kingdom <- cards.kingdom %>% filter(IsVillage == 0)
        if(input$remove_trashing == TRUE) cards.kingdom <- cards.kingdom %>% filter(IsTrashing == 0)
        if(input$remove_attacks == TRUE) cards.kingdom <- cards.kingdom %>% filter(IsAttack == 0)

        cards.kingdom <- cards.kingdom[sample(nrow(cards.kingdom)), ]
        kingdom <- cards.kingdom %>% head(10) %>% pull(Name) %>% paste0(collapse = ",")
      }

      
      draw.counter <- draw.counter + 1
      
      if(str_count(kingdom, ",") == 9) { draw.success <- TRUE }
      
    }

    output$kingdom.src <- renderText({kingdom})
    output$kingdom.text <- renderText({"Paste this on www.dominion.games to play with the generated kingdom"})
    output$kingdom.title <- renderText({"Generated Kingdom"})

    pic.size <- "300px"

    for(ii in 1:10){
      
      local({
        
        i <- ii
        picname <- paste0("pic", ii)
        output[[picname]] <- renderImage({list(src = paste0("./www/card_images/"
                                                            , str_split(kingdom, ",")[[1]][i], ".jpg")
                                               , height = pic.size)}
                                         , deleteFile = FALSE
                                         )
        })
    }
    
  }) # end observeEvent
})
