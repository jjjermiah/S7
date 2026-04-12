###############################
## Request Class
###############################

ListWidgetsQuery <- S7::new_class(
  "ListWidgetsQuery",
  properties = list(
    limit = S7::new_property(S7::class_character, default = "20",
      validator = function(value) {
        if (length(value) != 1) {
          return("'limit' must be a single non-empty string")
        }

        if (!grepl("^[0-9]+$", value)) {
          return("'limit' must be a string representing a positive integer")
        }
      }
    ),
    sort = S7::new_property(
      S7::class_character,
      default = "asc", 
      validator = function(value) {
        if (length(value) != 1) {
          return("'sort' must be a single non-empty string")
        }

        if (!value %in% c("asc", "desc")) {
          return("'sort' must be either 'asc' or 'desc'")
        }
      }
  )
  )
)

################################
## Response Class
################################

WidgetResponse <- S7::new_class(
  "WidgetResponse",
  properties = list(
    id = S7::class_character,
    status = S7::class_character
  ),
  validator = function(self) {
    if (!self@status %in% c("accepted", "queued")) {
      sprintf("'status' must be either 'accepted' or 'queued' but got '%s'", self@status)
    }
  }
)


###############################
## API route
###############################

#* Show S7 validation as RFC 9457-style problem details
#*
#* @get /widgets
#* @query limit Page size to request.
#* @query sort Sort direction. Must be either "asc" or "desc".
#* @query induce_bug:boolean Force the output validation path.
#* @serializer unboxedJSON
function(query, response) {
  # super messy implementation here for full demonstration, 
  # key point is to show how to catch validation errors and return them as 
  # problem details with appropriate status codes, content type, and language header.
  # In a real implementation, you'd likely want to factor out the error handling into a reusable function or middleware.
  request <- tryCatch(
    ListWidgetsQuery(
      limit = as.character(query$limit),
      sort = as.character(query$sort)
    ),
    S7_error_validation_failed = function(cnd) {
      response$status <- 422L
      response$type <- "application/problem+json"
      response$set_header("Content-Language", "en")
      response$body <- list(
        status = 422L,
        title = "Unprocessable request",
        detail = "The request parameters failed validation",
        errors = I(cnd$errors)
      )
    },
    error = function(err) {
      response$status <- 500L
      response$type <- "application/problem+json"
      response$set_header("Content-Language", "en")
      response$body <- list(
        title = "Internal Server Error",
        status = 500L,
        detail = "An unexpected error occurred while processing the request. Please report this to the API maintainers.",
        error = list(message = err$message, class = class(err))
      )
    }
  )

  if (!S7::S7_inherits(request, ListWidgetsQuery)) {
    # log here
    return(request)
  }

  response_value <- tryCatch(
    WidgetResponse(
      id = paste0("widget-limit-", request@limit),
      status = if (isTRUE(query$induce_bug)) "broken" else "queued"
    ),
    S7_error_validation_failed = function(cnd) {
      response$status <- 500L
      response$type <- "application/problem+json"
      response$set_header("Content-Language", "en")
      response$body <- list(
        title = "Internal Server Error",
        status = 500L,
        detail = "An unexpected error occurred while processing the request. Please report this to the API maintainers.",
        errors = I(cnd$errors)
      )
    }
  )

  if (!S7::S7_inherits(response_value, WidgetResponse)) {
    return(response_value)
  }

  response$type <- "application/json"
  list(id = response_value@id, status = response_value@status)
}
