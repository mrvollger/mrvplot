# mrvplot

A collection of custom plotting functions built on ggplot2 and related packages.

## Installation

You can install the development version of mrvplot from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("mrvollger/mrvplot")
```

## Functions

### Plotting Functions

- `mrv_ggsave()` - Enhanced ggsave with data export and temp file creation
- `mrv_grid()` - Clean minimal grid theme
- `mrv_hgrid()` - Horizontal grid theme only
- `mrv_vgrid()` - Vertical grid theme only
- `mrv_theme_no_x()` - Remove x-axis elements

### Transformations

- `reverselog_trans()` - Reverse logarithmic transformation for scales
- `scientific_10()` - Scientific notation formatter with proper base-10 expressions

### Utilities

- `mrv_read_bed()` - Read BED files with standardized column names and sorting

## Usage

```r
library(mrvplot)

# Create a plot with clean styling
ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  mrv_grid()

# Save with data export
mrv_ggsave("my_plot.pdf", width = 3, height = 3)
```

## Learn more

To learn more see the [vignette](https://mrvollger.github.io/mrvplot/articles/my-favorite-plot.html) on my favorite plot.
