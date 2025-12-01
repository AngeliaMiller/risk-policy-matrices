# Package setup ---------------------------------------------------------------

# Install required packages:
# install.packages("pak")
# pak::pak("surveydown-dev/surveydown") # Development version from GitHub

# Load packages
library(surveydown)
library(shiny)

# Database setup --------------------------------------------------------------
#
# Details at: https://surveydown.org/docs/storing-data
#
# surveydown stores data on any PostgreSQL database. We recommend
# https://supabase.com/ for a free and easy to use service.
#
# Once you have your database ready, run the following function to store your
# database configuration parameters in a local .env file:
#
# sd_db_config()
#
# Once your parameters are stored, you are ready to connect to your database.
# For this demo, we set ignore = TRUE in the following code, which will ignore
# the connection settings and won't attempt to connect to the database. This is
# helpful if you don't want to record testing data in the database table while
# doing local testing. Once you're ready to collect survey responses, set
# ignore = FALSE or just delete this argument.

db <- sd_db_connect()

# UI setup --------------------------------------------------------------------

ui <- sd_ui()

# Server setup ----------------------------------------------------------------

server <- function(input, output, session) {
  # Define any conditional skip logic here (skip to page if a condition is true)
  sd_skip_if(
    input$recruit_incl != "yes" ~ "climate_ecosystem")#, 
    # input$recruit_incl == "yes" ~ "add_recruit_info",
    # input$recruit_incl == "unknown" ~ "climate_ecosystem")

  # Define any conditional display logic here (show a question if a condition is true)
  sd_show_if(
    # Only show if there is a rebuilding plan
    input$rebuilding_plan == "rebuilding_plan" ~ "rebuilding_target",
    
    # Only show these questions if recruitment is included in the model
    input$recruit_incl == "yes" ~ "recruitment_model", 
    input$recruit_incl == "yes" ~ "beg_recruit_yr", 
    
    # Only show these questions if assessment type is analytical
    input$assessment_type == "analytical" ~ "retro_pattern",
    input$assessment_type == "analytical" ~ "retro_val",  

    # Only show this questions if other_fish_quota is yes
    input$other_fish_quota == "yes" ~ "other_quota_type",

    # Only show this questions if there is significant catch outside the fishery
    input$signif_catch_present == "yes" ~ "signif_catch_info"
  )

  # Run surveydown server and define database
  sd_server(db = db, 
            capture_metadata = FALSE)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
