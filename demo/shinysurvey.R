remotes::install_github("jdtrat/shinysurveys")
library(shinysurveys)
library(shiny)

## Set up of survey objects ####
# Questions to include; repeat a question for the number options that will be given below
questions <- c(rep(paste("What stock are you reporting on?"), 3), 
               rep(paste("Is this stock overfished?"), 2), 
               rep(paste("What is the stock's fish condition?"), 5), 
               "List the average revenue over the most recent three years", 
               "What is the SSB_MSY reference point?")

# Options for each question; repeat a question (above) for the number options that will be given
options <- c(c('Georges Bank cod', 'Gulf of Maine winter flounder', 'Pollock'), 
             c('No, it is not overfished','Yes, it is overfished'), 
             c('Good Condition', 'Above Average', "Neutral", "Below Average", "Poor Codition"),
            "Include point estimates for 3 years", 
            "Your Answer")

# Question types; repeat input types for the number options that will be given above
input_types <- c(rep(paste("select"), 3), 
                 rep(paste("mc"), 2),
                 rep(paste("mc"), 5), 
                 "text", 
                "numeric")

# Unique question IDs; repeat IDs for the number options that will be given above
input_ids <-  c(rep(paste('stock'),3),
                rep(paste('overfished-status'), 2),
                rep(paste('fish-condition'), 5), 
               "fishery-revenue", 
               "ssb-ref-pts")

# whether questions are dependent on other questions; must match dimensions of the questions and options
dependences <- c(rep(NA, 12))

# the specific value(s) that the dependence question must take for dependent question to be shown.; must match dimensions of the questions and options
dependence_vals <- c(rep(NA, 12))

# whether questions are required; must match dimensions of the questions and options
required_q <- c(rep(T, 12))

# Combine all objects above into a dataframe for the survey
df <- data.frame(question = questions,
                 option = options,
                 input_type = input_types,
                 input_id = input_ids,
                 dependence = dependences,
                 dependence_value = dependence_vals,
                 required = required_q)

## The App 
# User interface
ui_survey <- fluidPage(
  surveyOutput(df = df, # supply the dataframe of questions and options
               survey_title = "Risk Policy Matrix Survey",
               survey_description = "This is a demo a survey for the risk policy matrices to be completed by tech staff. It has four pages for each group theme with one sample question on each page.")
)

# Render the survey, currently without reactivity 
server_survey <- function(input, output, session) {
  renderSurvey()
  
  # demonstrate a pop-up message when "Submit" is pressed
  observeEvent(input$submit, { 
    showModal(modalDialog(
      title = "Congrats!",
      "You have completed the matrix. Please click below to exit the survey and download the report."
    ))
  })
}

# Run the app
shinyApp(ui_survey, server_survey)
