`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

is_s7_object <- function(x) {
  inherits(x, "S7_object")
}

ListWidgetsQuery <- S7::new_class(
  "ListWidgetsQuery",
  properties = list(
    limit = S7::new_property(S7::class_character, default = "20"),
    sort = S7::new_property(S7::class_character, default = "asc")
  ),
  validator = function(self) {
    c(
      if (!grepl("^[0-9]+$", self@limit) || as.integer(self@limit) < 1L) {
        "`limit` must be a positive integer query parameter"
      },
      if (!self@sort %in% c("asc", "desc")) {
        "`sort` must be either \"asc\" or \"desc\""
      }
    )
  }
)

WidgetResponse <- S7::new_class(
  "WidgetResponse",
  properties = list(
    id = S7::class_character,
    status = S7::class_character
  ),
  validator = function(self) {
    if (!self@status %in% c("accepted", "queued")) {
      "`status` must be either \"accepted\" or \"queued\""
    }
  }
)

new_problem_details <- function(type,
                                title,
                                status,
                                detail,
                                instance = NULL,
                                extensions = list()) {
  c(
    list(
      type = type,
      title = title,
      status = as.integer(status),
      detail = detail
    ),
    if (!is.null(instance)) list(instance = instance),
    extensions
  )
}

problem_errors <- function(cnd) {
  unname(lapply(cnd$errors, function(detail) list(detail = detail)))
}

new_endpoint_result <- function(status, body, log_condition = NULL) {
  result <- list(
    status = as.integer(status),
    body = body
  )

  attr(result, "log_condition") <- log_condition
  result
}

input_validation_problem <- function(cnd, instance = NULL) {
  new_problem_details(
    type = "https://example.com/problems/request-validation",
    title = "Request validation failed",
    status = 422L,
    detail = "The request parameters failed validation.",
    instance = instance,
    extensions = list(
      s7_class = cnd$object_class,
      errors = problem_errors(cnd)
    )
  )
}

output_validation_problem <- function(instance = NULL) {
  new_problem_details(
    type = "https://example.com/problems/internal-response-validation",
    title = "Internal Server Error",
    status = 500L,
    detail = "The server produced an invalid response.",
    instance = instance
  )
}

build_list_widgets_query <- function(query) {
  ListWidgetsQuery(
    limit = as.character(query[["limit"]] %||% "20"),
    sort = as.character(query[["sort"]] %||% "asc")
  )
}

build_widget_response <- function(query, induce_bug = FALSE) {
  status <- if (isTRUE(induce_bug)) "broken" else "queued"

  WidgetResponse(
    id = paste0("widget-limit-", query@limit),
    status = status
  )
}

serialize_widget_response <- function(response) {
  list(
    id = response@id,
    status = response@status
  )
}

list_widgets_endpoint <- function(query = list(),
                                  induce_bug = FALSE,
                                  instance = "/widgets") {
  request <- tryCatch(
    build_list_widgets_query(query),
    S7_error_validation = function(cnd) {
      new_endpoint_result(
        status = 422L,
        body = input_validation_problem(cnd, instance = instance),
        log_condition = cnd
      )
    }
  )

  if (!is_s7_object(request)) {
    return(request)
  }

  response <- tryCatch(
    build_widget_response(request, induce_bug = induce_bug),
    S7_error_validation = function(cnd) {
      new_endpoint_result(
        status = 500L,
        body = output_validation_problem(instance = instance),
        log_condition = cnd
      )
    }
  )

  if (!is_s7_object(response)) {
    return(response)
  }

  new_endpoint_result(
    status = 200L,
    body = serialize_widget_response(response)
  )
}

run_examples <- function() {
  list(
    bad_input = list_widgets_endpoint(list(limit = "-1", sort = "up")),
    bad_output = list_widgets_endpoint(
      list(limit = "2", sort = "asc"),
      induce_bug = TRUE
    )
  )
}
