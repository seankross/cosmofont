#' Create a stylesheet with font URIs from a directory containing font files
#' 
#' 
#' @param ... A series of \code{font_setting}s. See \link{\code{font_setting}}.
#' @param font_dir Path to a directory containing one or more font files.
#'     The default path is the working directory.
#' @param weight font-weight for all fonts. Default value is 400.
#' @param style font-style for all fonts. Default value is \code{"normal"}.
#' @param export_path Path to export the stylesheet. The default path is the working directory.
#' @export
#' @examples
#' \dontrun{
#' 
#' cosmofont()
#' cosmofont("~/Desktop/My_Fonts")
#' cosmofont("~/Desktop/My_Fonts", weight=500, style="italic")
#' cosmofont()
#' }
cosmofont <- (..., uri=F){
  # Capture settings
  settings <- list(...)
}

#'

cosmofont_easy <- function(font_dir=getwd(), weight=400, style="normal", export_path=getwd(), uri=F){
  
}

#'
font_options  <- function(font_name=NULL, bold=F, italic=F, weight=400, path){
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
  
  
  # Return font option object
  list(name = font_name, weight = weight, style = font_style, format = font_format, 
       file = path)
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