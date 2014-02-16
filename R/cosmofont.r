#' Create a stylesheet with font URIs from a directory containing font files
#' 
#' 
#' @param ... A series of \code{font_options}s. See \link{\code{font_options}}
#'    and \link{\code{google_font_options}}.
#' @param path Path to export the stylesheet. The default value is \code{NULL} which will cause 
#'    the stylesheet to be created in the working directory.
#' @param filename Name of exported stylesheet. The default value is \code{"stylesheet.css"}.
#' @param uri If set to \code{TRUE} the stylesheet will contain data URIs for the fonts.
#'    If set to \code{FALSE} font files will be coppied into the directory specified by \code{path}.
#'    The default value is \code{FALSE}. 
#' @export
#' @importFrom base64enc dataURI
#' @importFrom whisker whisker.render 
#' @examples
#' \dontrun{
#' 
#' roboto <- google_font_options("Roboto", italic=T)
#' newscycle <- font_options("~/Desktop/newscycle.ttf")
#' cosmofont(roboto, newscycle, path="~/Desktop/fonts", uri=T)
#' 
#' }
cosmofont <- (..., path=NULL, filename="stylesheet.css", uri=F){
  # Capture settings
  settings <- list(...)
}

#'

cosmofont_easy <- function(path=NULL, dest=NULL, weight=400, style="normal", uri=F){
  
}

#'
font_options  <- function(path, font_name=NULL, bold=F, italic=F, weight=400){
  # Determine file extension
  ext <- str_extract(basename(path), "\\..{3,4}$")
  
  # Do we need to generate a name?
  if(is.null(font_name)){
    font_name <- sub(ext, "", basename(path), font_name)
  }
  
  # Prune extension
  font_format <- sub(".", "", ext)
  
  # Determine style
  if(italic){
    font_style <- "italic"
  } else {
    font_style <- "normal"
  }
  if(weight==400 && bold){
    weight <- 700
  }
  
  # Convert file to raw
  font_file <- file(path, "rb")
  font_bin <- readBin(font_file, "raw", n=file.info(path)$size)
  close(font_file)
  
  # Return font option object
  list(name = font_name, weight = weight, style = font_style, format = font_format, 
       file = font_bin)
}

#'
#' @importFrom stringr str_extract perl
#' @importFrom httr GET content
google_font_options <- function(font_name, bold=F, italic=F, weight=400){
  # Make sure weight is in the realm of sanity
  if(weight < 100 || weight > 1000){
    stop("weight must be between 100 and 1000")
  }
  
  # Build query for GET request
  font_query <- paste0("family=", space2plus(font_name), ":")
  if(italic){
    font_query <- paste0(font_query, "i")
  }
  if(weight != 400){
    font_query <- paste0(font_query, weight)
  } else if(bold){
    font_query <- paste0(font_query, "b")
    weight <- 700
  }
  
  # Make GET request for CSS
  response <- GET("http://fonts.googleapis.com/", path = "css", query = font_query)
  
  # Get file url
  url <- sub("url\\(", "", str_extract(content(response, "text"), perl("url([^)]+)")))
  
  # Make GET request for font file
  font_file <- GET(url)
  
  # Store binary font file
  # font_bin <- file(open="w+b")
  # writeBin(content(GET(url), "raw"), font_bin)
  # writeBin(font_file$content, "~/gu.ttf")
  
  # Determine style
  if(italic){
    font_style <- "italic"
  } else {
    font_style <- "normal"
  }
  
  # Determine format
  font_format <- sub(".", "", str_extract(url, "\\..{3,4}$") )
  
  # Return font option object
  list(name = font_name, weight = weight, style = font_style, format = font_format, 
       file = font_file$content)
}

space2plus <- function(word){
  sub(" ", "+", word, fixed=T)
}

file_sieve <- function(file){
  grepl("\\.ttf|\\.eot|\\.woff", file)
}