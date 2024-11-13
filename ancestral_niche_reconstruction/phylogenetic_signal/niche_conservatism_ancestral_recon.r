library(ape)
library(phytools)
library(geiger)
library(dplyr)
library(ggplot2)
###########
#set working directory 
setwd("~/Desktop/Graduate_school/Projects/morphological_evolution_and_habitat_shifts/environmental_data/environment_data")

# Combined data file

bio1 <- read.csv("BIOCLIM_1.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio1) <- c("species", "bio1")
bio1 <- distinct(bio1, species, .keep_all= TRUE)

bio2 <- read.table("BIOCLIM_2.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio2) <- c("species", "bio2")
bio2 <- distinct(bio2, species, .keep_all= TRUE)

bio3 <- read.table("BIOCLIM_3.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio3) <- c("species", "bio3")
bio3 <- distinct(bio3, species, .keep_all= TRUE)

bio4 <- read.table("BIOCLIM_4.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio4) <- c("species", "bio4")
bio4 <- distinct(bio4, species, .keep_all= TRUE)

bio7 <- read.table("BIOCLIM_7.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio7) <- c("species", "bio7")
bio7 <- distinct(bio7, species, .keep_all= TRUE)

bio12 <- read.table("BIOCLIM_12.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio12) <- c("species", "bio12")
bio12 <- distinct(bio12, species, .keep_all= TRUE)

bio15 <- read.table("BIOCLIM_15.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio15) <- c("species", "bio15")
bio15 <- distinct(bio15, species, .keep_all= TRUE)

bio17 <- read.table("BIOCLIM_17.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(bio17) <- c("species", "bio17")
bio17 <- distinct(bio17, species, .keep_all= TRUE)

elevation <- read.table("GTOPO30_ELEVATION.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(elevation) <- c("species", "elevation")
elevation <- distinct(elevation, species, .keep_all= TRUE)

nitrogen <- read.table("ISRICSOILGRIDS_new_average_nitrogen_reduced.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(nitrogen) <- c("species", "nitrogen")
nitrogen <- distinct(nitrogen, species, .keep_all= TRUE)

carbon <- read.table("ISRICSOILGRIDS_new_average_soilorganiccarboncontent_reduced.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(carbon) <- c("species", "carbon")
carbon <- distinct(carbon, species, .keep_all= TRUE)

ph <- read.table("ISRICSOILGRIDS_new_average_phx10percent_reduced.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(ph) <- c("species", "ph")
ph <- distinct(ph, species, .keep_all= TRUE)

coarsefragment <- read.table("ISRICSOILGRIDS_new_average_coarsefragmentpercent_reduced.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(coarsefragment) <- c("species", "coarsefragment")
coarsefragment <- distinct(coarsefragment, species, .keep_all= TRUE)

sand <- read.table("ISRICSOILGRIDS_new_average_sandpercent_reduced.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(sand) <- c("species", "sand")
sand <- distinct(sand, species, .keep_all= TRUE)

needleleaf <- read.table("LandCover_1_Needleleaf.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(needleleaf) <- c("species", "needleleaf")
needleleaf <- distinct(needleleaf, species, .keep_all= TRUE)

deciduousbroadleaf <- read.table("LandCover_3_Deciduousbroadleaf.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(deciduousbroadleaf) <- c("species", "deciduousbroadleaf")
deciduousbroadleaf <- distinct(deciduousbroadleaf, species, .keep_all= TRUE)

herbaceous <- read.table("LandCover_6_Herbaceous.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(herbaceous) <- c("species", "herbaceous")
herbaceous <- distinct(herbaceous, species, .keep_all= TRUE)

aridity <- read.table("aridity_index_UNEP.average.csv", header = FALSE, stringsAsFactors = FALSE, row.names = NULL, sep = "\t")
colnames(aridity) <- c("species", "aridity")
aridity <- distinct(aridity, species, .keep_all= TRUE)

soil <- read.table("./../environment_data_soiltype_mode/soiltype_mostprobable.mode.csv", header = FALSE)
colnames(soil) <- c("species", "soil")
soil <- distinct(soil, species, .keep_all= TRUE)

combined = merge(bio1, bio2, by = "species")
combined = merge(combined, bio3, by = "species")
combined = merge(combined, bio4, by = "species")
combined = merge(combined, bio7, by = "species")
combined = merge(combined, bio12, by = "species")
combined = merge(combined, bio15, by = "species")
combined = merge(combined, bio17, by = "species")
combined = merge(combined, elevation, by = "species")
combined = merge(combined, nitrogen, by = "species")
combined = merge(combined, carbon, by = "species")
combined = merge(combined, ph, by = "species")
combined = merge(combined, sand, by = "species")
combined = merge(combined, coarsefragment, by = "species")
combined = merge(combined, needleleaf, by = "species")
combined = merge(combined, deciduousbroadleaf, by = "species")
combined = merge(combined, herbaceous, by = "species")
combined = merge(combined, aridity, by = "species")
combined = merge(combined, soil, by = "species")

#Save combined file as .csv

#######################
# Ancestral reconstruction
#######################
#load environmental data
combined.reduced <- distinct(combined, species, .keep_all= TRUE)
summary(combined.reduced)

#load tree data
tree = read.nexus("./../datedFigTree.tre")
is.ultrametric(tree)
tree = force.ultrametric(tree, method = "extend")
tree <- ladderize(tree)

#bio1
trait.vector = combined.reduced$bio1
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

# BM favored for annual temp, precipitation, aridity, etc.

# Plot mean annual temperature
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "OU")
dev.new(width=6, height=6)
plot(setMap(figure, invert = TRUE), legend=4*max(nodeHeights(tree)), fsize=0.6, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

# Plot annual precipitation, elevation, pH, nitrogen, aridity for color inversion (for bio15 temp seasonality use above)
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "OU")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.6, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

# Custom colors
# figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "OU")
# figure$cols[1:length(figure$cols)] <- colorRampPalette(c("blue", "red"), space="Lab")(length(figure$cols))
# dev.new(width=6, height=6)
# plot(figure, type = "fan", legend=0.7*max(nodeHeights(tree)), fsize=0.07, ftype="i", lwd=c(0.7,1), lwd=c(0.7,1), outline = FALSE, setMap(figure,invert=TRUE))

test1_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test1_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test1_lambda
test1_K

# Bio2; change the first line to get the rest of the variables
trait.vector = combined.reduced$bio2
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test2_lambda= phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test2_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test2_lambda
test2_K

#Bio3
trait.vector = combined.reduced$bio3
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test3_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test3_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test3_lambda
test3_K

#Bio4
trait.vector = combined.reduced$bio4
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test4_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test4_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test4_lambda
test4_K

#Bio7
trait.vector = combined.reduced$bio7
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test7_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test7_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test7_lambda
test7_K

#Bio12
trait.vector = combined.reduced$bio12
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test12_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test12_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test12_lambda
test12_K

#Bio15
trait.vector = combined.reduced$bio15
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(setMap(figure, invert = TRUE), legend=4*max(nodeHeights(tree)), fsize=0.6, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test15_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test15_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test15_lambda
test15_K

#Bio17
trait.vector = combined.reduced$bio17
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test17_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test17_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test17_lambda
test17_K

#elevation
trait.vector = combined.reduced$elevation
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_elevation_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_elevation_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_elevation_lambda
test_elevation_K

#nitrogen
trait.vector = combined.reduced$nitrogen
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_nitrogen_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_nitrogen_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_nitrogen_lambda
test_nitrogen_K

#ph
trait.vector = combined.reduced$ph
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_ph_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_ph_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_ph_lambda
test_ph_K

#aridity
trait.vector = combined.reduced$aridity
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_aridity_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_aridity_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_aridity_lambda
test_aridity_K

#carbon
trait.vector = combined.reduced$carbon
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_carbon_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_carbon_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_carbon_lambda
test_carbon_K

#coarsefragment
trait.vector = combined.reduced$coarsefragment
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_coarsefragment_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_coarsefragment_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_coarsefragment_lambda
test_coarsefragment_K

#deciduousbroadleaf
trait.vector = combined.reduced$deciduousbroadleaf
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_deciduousbroadleaf_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_deciduousbroadleaf_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_deciduousbroadleaf_lambda
test_deciduousbroadleaf_K

#herbaceous
trait.vector = combined.reduced$herbaceous
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_herbaceous_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_herbaceous_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_herbaceous_lambda
test_herbaceous_K

#needleleaf
trait.vector = combined.reduced$needleleaf
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_needleleaf_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_needleleaf_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_needleleaf_lambda
test_needleleaf_K

#sand
trait.vector = combined.reduced$sand
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_sand_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_sand_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_sand_lambda
test_sand_K

#soil
trait.vector = combined.reduced$soil
names(trait.vector) <- combined.reduced$species
trait.reduced <- treedata(tree, trait.vector)$data
trait.reduced.vector <- trait.reduced[,1]
tree.reduced <- treedata(tree, trait.vector)$phy

# MODEL COMPARISON
fitBM = fitContinuous(tree.reduced, trait.reduced)
fitOU = fitContinuous(tree.reduced, trait.reduced, model = "OU") # Make sure it is truly ultrametric even considering small rounding errors -- even a small discrepancy will cause complaints and longer runtime due to VCF optimization.
fitEB = fitContinuous(tree.reduced, trait.reduced, model = "EB")

fitBM$opt$aicc
fitOU$opt$aicc
fitEB$opt$aicc

#plot
figure = contMap(tree.reduced, trait.reduced.vector, plot = FALSE, model = "BM")
dev.new(width=6, height=6)
plot(figure, legend=4*max(nodeHeights(tree)), fsize=0.4, ftype="i", lwd=c(3,1), lwd=c(3,1), outline = FALSE)

test_soil_lambda = phylosig(tree.reduced, trait.reduced.vector, method = "lambda", test = T)
test_soil_K = phylosig(tree.reduced, trait.reduced.vector, method = "K", test = T)
test_soil_lambda
test_soil_K

# Biogeographic correlation -- ask whether clade and biogeography are independent in explaining environment

combined.normalized <- rapply(combined, scale, c("numeric","integer"), how="replace")
combined.normalized$biogeo <- as.factor(combined.normalized$biogeo)
combined.normalized$species <- as.factor(combined.normalized$species)
res.man <- manova(cbind(bio1, bio2, bio3, bio4, bio7, bio12, bio15, bio17, elevation, nitrogen, carbon, ph, sand, coarsefragment, needleleaf, deciduousbroadleaf, herbaceous, aridity) ~ biogeo, data = combined.normalized)
summary(res.man, tol = 0, test="Pillai")
summary.aov(res.man)

#res.lm <- lm(bio1 + bio2 + bio3 + bio4 + bio7 + bio12 + bio15 + bio17 + elevation + nitrogen + carbon + ph + sand + coarsefragment + needleleaf + deciduousbroadleaf + herbaceous + aridity ~ group*biogeo, data = combined.normalized)
# summary(res.lm)


# Estimate MANOVA effect size
library(effectsize)
# Omit bio2 due to rank deficiency
eta_squared(manova(cbind(bio1,bio2, bio3, bio4, bio7, bio12, bio15, bio17, elevation, nitrogen, carbon, ph, sand, coarsefragment, needleleaf, deciduousbroadleaf, herbaceous, aridity) ~ biogeo, data = combined.normalized))




