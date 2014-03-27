\name{cosmofont}
\alias{cosmofont}
\title{Create a stylesheet with custom settings using local and web fonts}
\usage{
cosmofont(..., path = NULL, filename = "stylesheet.css", uri = FALSE)
}
\arguments{
  \item{...}{A series of \code{font_options}. See
  \code{font_options} and \code{google_font_options}.}

  \item{path}{Path to export the stylesheet. The default
  value is \code{NULL} which will cause the stylesheet to
  be created in the working directory.}

  \item{filename}{Name of exported stylesheet. The default
  value is \code{"stylesheet.css"}.}

  \item{uri}{If set to \code{TRUE} the stylesheet will
  contain data URIs for the fonts.  If set to \code{FALSE}
  font files will be coppied into the directory specified
  by \code{path}.  The default value is \code{FALSE}.}
}
\description{
Create a stylesheet with custom settings using local and
web fonts
}
\examples{
\dontrun{

roboto <- google_font_options("Roboto", italic=TRUE)
newscycle <- font_options("~/Desktop/newscycle.ttf")
cosmofont(roboto, newscycle, path="~/Desktop/fonts", uri=TRUE)

}
}

