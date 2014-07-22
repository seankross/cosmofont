#' Create a stylesheet with custom settings using local and web fonts
#' 
#' 
#' @param ... A series of \code{font_options}. See \code{font_options}
#'    and \code{google_font_options}.
#' @param path Path to export the stylesheet. The default value is \code{NULL} which will cause 
#'    the stylesheet to be created in the working directory.
#' @param filename Name of exported stylesheet. The default value is \code{"stylesheet.css"}.
#' @param uri If set to \code{TRUE} the stylesheet will contain data URIs for the fonts.
#'    If set to \code{FALSE} font files will be coppied into the directory specified by \code{path}.
#'    The default value is \code{FALSE}. 
#' @export
#' @importFrom whisker whisker.render 
#' @examples
#' \dontrun{
#' 
#' roboto <- google_font_options("Roboto", italic=T)
#' newscycle <- font_options("~/Desktop/newscycle.ttf")
#' cosmofont(roboto, newscycle, path="~/Desktop/fonts", uri=T)
#' 
#' }
cosmofont <- function(..., path=NULL, filename="stylesheet.css", uri=F){
  # Capture settings
  fonts <- list(...)
  
  # Set path if necessary
  if(is.null(path)){
    path <- getwd()
  }
  
  if(uri){
    # Make URIs
    fonts <- lapply(fonts, make_dataURI)
    
    # Make CSS file. Thank you Ramnath Vaidyanathan!
    css <- paste(capture.output(cat(whisker.render(whisker_template(), list(fonts = fonts)))), collapse = "\n")
    cat(css, file = file.path(path, filename))
  } else {
    # Write font files
    lapply(fonts, write_font_file, path=path)
    
    # Apply local URI
    fonts <- lapply(fonts, local_URI)
    
    # Write CSS file
    css <- paste(capture.output(cat(whisker.render(local_template(), list(fonts = fonts)))), collapse = "\n")
    cat(css, file = file.path(path, filename))
  }
  invisible()
}

#'

#cosmofont_easy <- function(path=NULL, dest=NULL, weight=400, style="normal", uri=F){
#  Filter
#}

#' Specify font options for a local font file
#' 
#' Only font files of type \code{.ttf}, \code{.eot}, and \code{.woff} are compatible with this package.
#' 
#' @param path The path to the font file.
#' @param font_name The name of the font as it will appear in the stylesheet. If \code{NULL} the name
#'    of the file will be used. The default value is \code{NULL}.
#' @param bold If \code{TRUE} the \code{font-weight} will be set to \code{700}. The default value is \code{FALSE}.
#' @param italic If \code{TRUE} the \code{font-style} will be set to \code{italic}. The default value is \code{FALSE}.
#' @param weight The numeric weight of the font. The default value is \code{400}. Setting this value will
#'    override the value of \code{bold}.
#' @export
#' @importFrom stringr str_extract
#' @examples
#' \dontrun{
#' 
#' verdana <- font_options("~/Desktop/verdana.ttf", weight=800)
#' monaco <- font_options("~/Desktop/monaco-black.woff", font_name="Monaco")
#' }
font_options  <- function(path, font_name=NULL, 
                          bold=F, italic=F, weight=400){
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

#' Specify font options for a Google font
#' 
#' You can browse Google fonts at \url{https://www.google.com/fonts}.
#' 
#' @param font_name The name of the font exactly as it appears on Google fonts. Case sensitive.
#' @param bold If \code{TRUE} the \code{font-weight} will be set to \code{700}. The default value is \code{FALSE}.
#' @param italic If \code{TRUE} the \code{font-style} will be set to \code{italic}. The default value is \code{FALSE}.
#' @param weight The numeric weight of the font. The default value is \code{400}. Setting this value will
#'    override the value of \code{bold}.
#' @export
#' @importFrom stringr str_extract perl
#' @importFrom httr GET content
#' @examples
#' \dontrun{
#' 
#' open_sans <- google_font_options("Open Sans", weight=600)
#' roboto <- google_font_options("Roboto", italic=T)
#' }
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
  gsub(" ", "+", word, fixed=T)
}

file_sieve <- function(file){
  grepl("\\.ttf|\\.eot|\\.woff", file)
}

#' @importFrom base64enc dataURI
make_dataURI <- function(font){
  if(font$format == "ttf"){
    font_mime <- "application/x-font-ttf"
    font$format <- "truetype"
  } else if(font$format == "eot"){
    font_mime <- "font/opentype"
    font$format <- "embedded-opentype"
  } else if(font$format == "woff"){
    font_mime <- "application/x-font-woff"
  } else {
    stop("This font format is not supported.")
  }
  
  font$dataURI <- dataURI(font$file, mime = font_mime)
  return(font)
}

local_URI <- function(font){
  if(font$format == "ttf"){
    font$format <- "truetype"
    font$dataURI  <- paste0(font$name, ".ttf")
  } else if(font$format == "eot"){
    font$format <- "embedded-opentype"
    font$dataURI  <- paste0(font$name, ".eot")
  } else if(font$format == "woff"){
    font$dataURI  <- paste0(font$name, ".woff")
  } else {
    stop("This font format is not supported.")
  }
  return(font)
}

whisker_template <- function(){
"{{# fonts }}
@font-face {
  font-family: '{{{ name }}}';
  font-style: {{{ style }}};
  font-weight: {{{ weight }}};
  src: url({{{ dataURI }}}) format('{{{ format }}}');
}
{{/ fonts }}"
}

local_template <- function(){
"{{# fonts }}
@font-face {
  font-family: '{{{ name }}}';
  font-style: {{{ style }}};
  font-weight: {{{ weight }}};
  src: url('{{{ dataURI }}}') format('{{{ format }}}');
}
{{/ fonts }}"
}

write_font_file <- function(font, path){
  full_file_pathname <- file.path(path, paste0(font$name, ".", font$format))
  if(!file.exists(full_file_pathname)){
    writeBin(font$file, full_file_pathname)
  }
}
