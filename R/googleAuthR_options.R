.onLoad <- function(libname, pkgname) {
  
  op <- options()
  op.googleAuthR <- list(
    googleAuthR.rawResponse = FALSE,
    googleAuthR.httr_oauth_cache = TRUE,
    googleAuthR.verbose = 3,
    googleAuthR.cache_function = function(req) {TRUE},
    # googleAuthR.client_id = Sys.getenv("CLIENT_ID"),
    # googleAuthR.client_secret = Sys.getenv("CLIENT_ID_SECRET"),
    # googleAuthR.webapp.client_id = Sys.getenv("CLIENT_ID"),
    # googleAuthR.webapp.client_secret = Sys.getenv("CLIENT_ID_SECRET"),
    googleAuthR.webapp.port = 1221,
    googleAuthR.jsonlite.simplifyVector = TRUE,
    # googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/webmasters",
    #                                 "https://www.googleapis.com/auth/analytics",
    #                                 "https://www.googleapis.com/auth/analytics.readonly",
    #                                 "https://www.googleapis.com/auth/analytics.manage.users.readonly",
    #                                 "https://www.googleapis.com/auth/tagmanager.readonly",
    #                                 "https://www.googleapis.com/auth/urlshortener"),
    googleAuthR.ok_content_types=c("application/json; charset=UTF-8", ("text/html; charset=UTF-8")),
    googleAuthR.securitycode = 
      paste0(sample(c(1:9, LETTERS, letters), 20, replace = T), collapse=''),
    googleAuthR.tryAttempts = 5
  )
  toset <- !(names(op.googleAuthR) %in% names(op))
  if(any(toset)) options(op.googleAuthR[toset])
  
  invisible()
  
}

.onAttach <- function(libname, pkgname) {
 
  default_scopes <- getOption("googleAuthR.scopes.selected")
  
  googleAuthR::gar_attach_auto_auth(default_scopes)
  
}