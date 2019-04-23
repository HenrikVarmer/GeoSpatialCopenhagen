
install.packages("rayshader")
devtools::install_github("tylermorganwall/rayshader")

library(rayshader)

# defining a function to read elevation file as matrix
read_elevation_file <- function(file) {
  elev_img <- raster::raster(file)
  elev_matrix <- matrix(
    raster::extract(elev_img, raster::extent(elev_img), buffer = 1000), 
    nrow = ncol(elev_img), ncol = nrow(elev_img)
  )
  elev_matrix
}


# read elevation file
read_elevation_file("uv2_bfm_2011.tif")


# load elevation data
elev_img <- raster::raster(elev_file)
elev_matrix <- matrix(
  raster::extract(elev_img, raster::extent(elev_img), buffer = 1000), 
  nrow = ncol(elev_img), ncol = nrow(elev_img)
)

# calculate rayshader layers
ambmat <- ambient_shade(elev_matrix, zscale = 30)
raymat <- ray_shade(elev_matrix, zscale = 30, lambert = TRUE)
watermap <- detect_water(elev_matrix)

# plot 2D
elev_matrix %>%
  sphere_shade(texture = "imhof4") %>%
  add_water(watermap, color = "imhof4") %>%
  add_shadow(raymat, max_darken = 0.5) %>%
  add_shadow(ambmat, max_darken = 0.5) %>%
  plot_map()




