# install.packages("pak")
# pak::local_install("inst/examples/s7problemdemo")

# Input validation errors become a 422-style problem-details payload.
bad_input <- s7problemdemo::list_widgets_endpoint(
  query = list(limit = "-1", sort = "up")
)
str(bad_input$body)
attr(bad_input, "log_condition")$errors

# Output validation errors stay generic for clients, but the original
# S7 condition is still available for logging.
bad_output <- s7problemdemo::list_widgets_endpoint(
  query = list(limit = "2", sort = "asc"),
  induce_bug = TRUE
)
str(bad_output$body)
attr(bad_output, "log_condition")$errors
