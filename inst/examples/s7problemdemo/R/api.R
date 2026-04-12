###############################
## Request Class
###############################

ListWidgetsQuery <- S7::new_class(
  "ListWidgetsQuery",
  properties = list(
    limit = S7::new_property(S7::class_character, default = "20"),
    sort = S7::new_property(S7::class_character, default = "asc")
  ),
  validator = function(self) {
    c(
      if (!grepl("^[0-9]+$", self@limit) || as.integer(self@limit) < 1L) {
        "'limit' must be a positive integer query parameter"
      },
      if (!self@sort %in% c("asc", "desc")) {
        "'sort' must be either 'asc' or 'desc'"
      }
    )
  }
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
      "'status' must be either 'accepted' or 'queued'"
    }
  }
)

validation_problem <- function(cnd, title, status, detail) {
  list(
    type = class(cnd)[1],
    title = title,
    status = status,
    detail = detail,
    errors = cnd$errors
  )
}

###############################
## API route
###############################

#* Show S7 validation as RFC 9457-style problem details
#*
#* @get /widgets
#* @query limit:string Page size to request.
#* @query sort:string Sort direction.
#* @query induce_bug:boolean Force the output validation path.
#* @serializer unboxedJSON
function(query, response) {
  request <- tryCatch(
    ListWidgetsQuery(
      limit = if (is.null(query$limit)) "20" else as.character(query$limit),
      sort = if (is.null(query$sort)) "asc" else as.character(query$sort)
    ),
    S7_error_validation_failed = function(cnd) {
      response$status <- 422L
      response$type <- "application/problem+json"
      response$set_header("Content-Language", "en")
      validation_problem(
        cnd,
        title = "Request validation failed",
        status = 422L,
        detail = "The request parameters failed validation."
      )
    }
  )

  if (!inherits(request, "S7_object")) {
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
      validation_problem(
        cnd,
        title = "Internal Server Error",
        status = 500L,
        detail = "The server produced an invalid response.",
        pointers = validation_pointers(cnd$errors, status = TRUE)
      )
    }
  )

  if (!inherits(response_value, "S7_object")) {
    return(response_value)
  }

  response$type <- "application/json"
  list(id = response_value@id, status = response_value@status)
}
