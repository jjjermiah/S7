# Build the API with plumber2.
pa <- plumber2::api("inst/examples/s7problemdemo/R/api.R")


pa |> plumber2::api_run(
  host = NULL,
  port = 8182,
  showcase = TRUE
)
