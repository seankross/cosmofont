# cosmofont

### Programmaticaly generate @font-faces for CSS stylesheets in R

cosmofont creates CSS stylesheets so you can use custom fonts in your projects. Use your own font files or use cosmofont to get some of the most popular typography on the web from [Google Fonts](http://google.com/fonts). cosmofont supports `.eot`, `.tff`, and `.woff` file types. Use [Data URIs](https://en.wikipedia.org/wiki/Data_URI_scheme) to embed fonts inline so you can use your webfonts offline!

---

### To install:

```
library(devtools)
install_github("cosmofont", "seankross")
```

### Getting started:
```
# Get some fonts!
roboto <- google_font_options("Roboto")
open_sans <- google_font_options("Open Sans")
cosmofont(roboto, open_sans)
# stylesheet.css should appear in your working directory.
```
