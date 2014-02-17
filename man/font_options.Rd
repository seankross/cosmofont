\name{font_options}
\alias{font_options}
\title{Specify font options for a local font file}
\usage{
font_options(path, font_name = NULL, bold = F, italic = F, weight = 400)
}
\arguments{
  \item{path}{The path to the font file.}

  \item{font_name}{The name of the font as it will appear
  in the stylesheet. If \code{NULL} the name of the file
  will be used. The default value is \code{NULL}.}

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
Only font files of type \code{.ttf}, \code{.eot}, and
\code{.woff} are compatible with this package.
}
\examples{
\dontrun{

verdana <- font_options("~/Desktop/verdana.ttf", weight=800)
monaco <- font_options("~/Desktop/monaco-black.woff", font_name="Monaco")
}
}

