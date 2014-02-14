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
cosmofont <- (..., font_dir=getwd(), weight=400, style="normal", export_path=getwd()){
  # Capture settings
  settings <- list(...)
}