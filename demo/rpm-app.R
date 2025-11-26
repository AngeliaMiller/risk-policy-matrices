library(shiny)
library(bslib)
library(here)
demo_imgs <- here("risk-policy-matrices", "demo")

# data <- data.frame(stock = c('Georges Bank cod', 'Gulf of Maine winter flounder', 'Pollock'), 
#                    year = c("2025"), 
#                    fmp = c("Groundfish"))

# create a card object for the main navigation page 
cards <- list(navset_card_tab( # set cards in tabs for the user-selected stock
  # first tab: Risk Policy Report 
  nav_panel("Report", card( 
          card_header("Risk Policy Report"), 
          card_image(
            file = here(demo_imgs, "rp-matrix.jpg") # a static image to show what could appear on this tab
            )
          ), 
    # include in same tab under the report, a button that could download the report shown on the tab
  card(
    actionButton(inputId = "report", 
                 label = "Build report")
  )
), 
  # second tab: Tables of Factor scores and weights
    nav_panel("Scores", card(
          card_header("Weights and Factor Scores"), 
          card_image(
            file = here(demo_imgs, "weight-table.png") # a static image to show what could appear on this tab
            )
          )), 
    # third tab: The recommended probability plot generated from the factor scores and weights
    nav_panel("Probability Plot", card(
          card_header("Recommended Probability"), 
          card_image(
            file = here(demo_imgs, "z-score-curve.png") # a static image to show what could appear on this tab
            )
          )), 
    id = "tab" 
)
)


# user interface
ui_report <- fluidPage(
  # include a sidebar with selection tools
  layout_sidebar(
    sidebar = sidebar(position = "left", #put the side bar on the left
        # select FMP
        selectInput(inputId = "fmp", # column in dataframe
                    label = "Select the FMP", # label in shiny
                    choices = c("Groundfish") # choices in the list
                      ), 
        # select stock
        selectInput(inputId = "stock", # column in dataframe
                       label = "Select the stock", # label in shiny
                       choices = c('Georges Bank cod', 'Gulf of Maine winter flounder', 'Pollock'), # choices in the list
                       selected = "Gulf of Maine winter flounder"), # default selection
        # select year
        selectInput(inputId = "year", # column in dataframe
                       label = "Select the year", # label in shiny
                       choices = c(2025) # choices in the list
                      ),
                    ), 
        # on the remainder of the page, use the cards object 
        cards
        )
    )


# back end reactivity - currently empty
server_report <- function(input, output, session) {

}

shinyApp(ui_report, server_report)


