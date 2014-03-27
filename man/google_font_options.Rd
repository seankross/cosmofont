\name{google_font_options}
\alias{google_font_options}
\title{Specify font options for a Google font}
\usage{
google_font_options(font_name, bold = FALSE, italic = FALSE, weight = 400)
}
\arguments{
  \item{font_name}{The name of the font exactly as it
  appears on Google fonts. Case sensitive.}

  \item{bold}{If \code{TRUE} the \code{font-weight} will be
  set to \code{700}. The default value is \code{FALSE}.}

  \item{italic}{If \code{TRUE} the \code{font-style} will
  be set to \code{italic}. The default value is
  \code{FALSE}.}

  \item{weight}{The numeric weight of the font. The default
  value is \code{400}. Setting this value will override the
  value of \code{bold}.}
}
\description{
You can browse Google fonts at
\url{https://www.google.com/fonts}.
}
\examples{
\dontrun{

open_sans <- google_font_options("Open Sans", weight=600)
roboto <- google_font_options("Roboto", italic=TRUE)
}
}

