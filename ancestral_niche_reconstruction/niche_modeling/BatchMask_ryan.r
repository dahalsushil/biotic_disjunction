#' BatchMask - Crops (masks) the raster files with multiple shape file.
#' 
#' Noninteractive version. For interactive version refer \link{iBatchMask}
#' 
#' Function crops (masks) the raster files with multiple shape file and stores them in separate folders.
#' Masked files are stored in seperate folders with shape file name and names of the masked files are kept same. 
#' For example, if the input asc files are bio1.asc, bio2.asc, and you select multiple shape files like shp1.shp, shp2.shp, shp3.shp, then 
#' 3 folders named shp1, shp2 and shp3 will be created in output folder specified by user. Each folder will contain bio1.asc, bio2.asc
#' If by chance your files does not have any extension, then comment the statement below the note 'For file with extension'. 
#' and uncomment the FileName statement below the note 'For files without extension
#' @import raster
#' @import maptools
#' @param ASCfilelist - list of raster files to crop
#' @param SHPfilelist - mask shapefiles used to crop rasters 
#' @param OPDirName - Output folder, where subfolders of shape files will be created 
#' @examples \dontrun{
#' BatchMask()
#' }
#' @export
# By Narayani Barve, with modifications for Unix and memory management by Ryan Folk. Updated again for memory management by Ryan Folk 2022.
BatchMask <- function(ASCfilelist=NA, SHPfilelist=NA, OPDirName= NA) { 
	for (i in 1:length(ASCfilelist)) { # Check if all files in the list exist
		if(is.na(ASCfilelist[i])) {
			stop("Please specify ASCfilelist (ASCII files to crops) or use iBatchMask for interactive version")
			}
		}
	for (i in 1:length(ASCfilelist)) { # Check if all files in the list exist
		if(is.na(SHPfilelist[i])) {
			stop("Please specify SHPfilelist (shape files as crop mask) or use iBatchMask for interactive version")
			}
		}
	if (is.na(OPDirName)) { # Make sure a directory was specified
		stop("Please specify OPDirName (output folder) or use iBatchMask for interactive version")
		}
	
	print("Loading raster layers.")
	RasList = lapply(ASCfilelist, raster) # We load all rasters at once
	print("Placing raster layers in RAM.")	
	RasList = lapply(RasList, readAll) # Force read of rasters into RAM for efficiency
	
	print("Beginning main loop.")
	d1 = length(SHPfilelist)
	for (k in 1:d1) {
		ShapeFile1 = SHPfilelist[k]
		try(CropData(RasList, ASCfilelist,as.character(ShapeFile1),as.character(OPDirName))) # We then move to the cropping function
		# Any shapefiles causing errors will be skipped with errors reported to sterror
		}
	}

CropData<-function(raslist, filelist, ShapeFile, DirName) {
	Shp1 <- shapefile(ShapeFile)
	shapename = gsub(".*/", "", ShapeFile, perl=TRUE)
	shapename = gsub(".shp", "", shapename, perl=TRUE)
	print (paste("Current shape file is : ", shapename, sep = ""))
	if (file.exists(paste("./", DirName, sep = "")) == FALSE) {
		dir.create(paste("./", DirName, sep = ""))
		}
	if (file.exists(paste("./", DirName, "/", shapename, sep = "")) == FALSE) {
		dir.create(paste("./", DirName, "/", shapename, sep = ""))
		}
	for (i in 1:length(filelist)) {
		#r1 = raster(filelist[i])
		r1 = raslist[[i]]
		if (inMemory(r1) == FALSE) { # Should be true
			print("Raster is being reloaded into memory! Something is wrong!") 
			}
		print("Cropping step 1.")
		cr1 = crop(r1,Shp1)
		print("Cropping step 2.")
		cr2 = mask(cr1,Shp1)
		layername = gsub(".*/", "", filelist[i], perl=TRUE)
		print(paste("Writing cropped layer for ASC file ", layername, sep=""))
		writeRaster(cr2, paste("./", DirName, "/", shapename, "/", shapename, ".", layername, sep = ""), "ascii", overwrite=TRUE)
		rm(cr2)
		}
	rm(r1)
	}

