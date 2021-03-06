library(testthat)
library(googleAuthR)
options(googleAuthR.httr_oauth_cache = "httr-oauth.rds")
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/webmasters",
                                        "https://www.googleapis.com/auth/urlshortener"))
options(googleAuthR.client_id = Sys.getenv("CLIENT_ID"))
options(googleAuthR.client_secret = Sys.getenv("CLIENT_SECRET"))
options(googleAuthR.webapp.client_id = Sys.getenv("WEB_CLIENT_ID"))
options(googleAuthR.webapp.client_secret = Sys.getenv("WEB_CLIENT_SECRET"))

context("Auth")

## from search console API
list_websites <- function() {
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/webmasters/v3/sites",
                                      "GET",
                                      data_parse_function = function(x) x$siteEntry)
  l()
}

## from search console API
list_websites2 <- function(dummy_arg = 3) {
  print(dummy_arg)
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/webmasters/v3/sites",
                                      "GET",
                                      data_parse_function = function(x) x$siteEntry)
  l()
}


test_that("The auth JSON file can be found",{
  skip_on_cran()
  filep <- Sys.getenv("GAR_AUTH_FILE")
  if(filep == "") filep <- Sys.getenv("TRAVIS_GAR_AUTH_FILE")
  
  cat("\n==auth JSON file location==\n")
  cat("=dir: ", getwd(),"\n")
  cat("=file: ",filep, "\n")
  cat("=list files:", list.files(),"\n")
  cat("\n")
  
  if(filep != "") expect_true(file.exists(filep))
  
})

test_that("The auth httr file can be found",{
  skip_on_cran()
  filep <- getOption("googleAuthR.httr_oauth_cache")
  
  if(class(filep) == "character") {
    expect_true(file.exists(filep))
  } else {
    skip("No httr file found")
  }
  
})

test_that("Can authenticate .httr passed as a file", {
  skip_on_cran()
  expect_s3_class(gar_auth("httr-oauth.rds"), "Token2.0")
  
})


test_that("Can authenticate .httr looking for existing file", {
  skip_on_cran()
  options(googleAuthR.httr_oauth_cache = "httr-oauth.rds")
  expect_s3_class(gar_auth(), "Token2.0")
  
})

test_that("Can authenticate .httr passing a token", {
  skip_on_cran()
  tt <- gar_auth()
  
  expect_s3_class(gar_auth(tt), "Token2.0")
  
})


test_that("Can authenticate JSON settings", {
  skip_on_cran()
  filep <- Sys.getenv("GAR_AUTH_FILE")
  if(filep == "") filep <- Sys.getenv("TRAVIS_GAR_AUTH_FILE")
  
  if(filep != ""){
    
    expect_s3_class(gar_auth_service(filep), "Token2.0")
    
  } else {
    skip("No auth file found")
  }
  
})

test_that("Test scopes are set", {
  skip_on_cran()
  scopes <- getOption("googleAuthR.scopes.selected")
  expected_scopes <- c("https://www.googleapis.com/auth/webmasters",
                       "https://www.googleapis.com/auth/analytics",
                       "https://www.googleapis.com/auth/analytics.readonly",
                       "https://www.googleapis.com/auth/analytics.manage.users.readonly",
                       "https://www.googleapis.com/auth/tagmanager.readonly",
                       "https://www.googleapis.com/auth/urlshortener")
  
  expect_true(all(scopes %in% expected_scopes))
  
})


test_that("Can authenticate default auto settings", {
  skip_on_cran()
  default_scopes <- getOption("googleAuthR.scopes.selected")
  
  token <- gar_auto_auth(default_scopes, 
                         environment_var = "GAR_AUTH_FILE", 
                         travis_environment_var = "TRAVIS_GAR_AUTH_FILE")
  
  expect_s3_class(token, "Token2.0")
  
})

test_that("Right message when wrong token file location given", {
  skip_on_cran()
  options(googleAuthR.httr_oauth_cache = "httr-oauth.rds")
  
  expect_s3_class(gar_auth(), "Token2.0")
  
})

context("API generator")

test_that("A generated API function works", {
  skip_on_cran()
  lw <- list_websites()
  expect_s3_class(lw, "data.frame")
  
})

test_that("Mock an API function", {
  options(googleAuthR.mock_test = TRUE)
  lw <- list_websites()
  expect_s3_class(lw, "data.frame")
  lw2 <- list_websites()
  expect_equal(lw, lw2)
})

test_that("Mock with different arguments", {
  options(googleAuthR.mock_test = TRUE)
  lw <- list_websites2()
  expect_s3_class(lw, "data.frame")
  lw2 <- list_websites2(4)
  expect_s3_class(lw2, "data.frame")
  
  
})


