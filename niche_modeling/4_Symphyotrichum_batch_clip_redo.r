#!/usr/bin/env Rscript
library(raster)
library(maptools)
source("./BatchMask_ryan.r")
dir.create(file.path(getwd(), "temp"))
rasterOptions(tmpdir=paste(getwd(), "/temp/", sep ="")) # This is important; this script will make a lot of temporary files so keep it on a large hard drive.
print(rasterOptions()$tmpdir)
# Should take about 15 minutes to load into 20 gigs of RAM or about 20% of the workstation capacity
# Once completely loaded RAM use is less so stagger parallel scripts
rasterlist <- c('/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/BIOCLIM_1.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/BIOCLIM_7.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/BIOCLIM_12.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/BIOCLIM_17.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/GTOPO30_ELEVATION.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/GTOPO30_SLOPE_reduced.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/ISRICSOILGRIDS_new_average_coarsefragmentpercent_reduced.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/ISRICSOILGRIDS_new_average_phx10percent_reduced.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/ISRICSOILGRIDS_new_average_sandpercent_reduced.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/ISRICSOILGRIDS_new_average_soilorganiccarboncontent_reduced.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/LandCover_1_Needleleaf.asc', '/mnt/Heuheu/nitfix/Saxifragales_all_layers_30s/LandCover_6_Herbaceous.asc')
for (i in rasterlist) {
BatchMask(ASCfilelist = c(i), SHPfilelist = c('/mnt/Heuheu/sushil/sushil_niche_model/powo_cleaned_redos/Symphyotrichum_amethystinum.shp.final_shapefile.shp', '/mnt/Heuheu/sushil/sushil_niche_model/powo_cleaned_redos/Symphyotrichum_columbianum.shp.final_shapefile.shp', '/mnt/Heuheu/sushil/sushil_niche_model/powo_cleaned_redos/Symphyotrichum_tradescantii.shp.final_shapefile.shp', '/mnt/Heuheu/sushil/sushil_niche_model/powo_cleaned_redos/Symphyotrichum_versicolor.shp.final_shapefile.shp'), OPDirName = 'clippings_redos')
}
