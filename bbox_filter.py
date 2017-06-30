#!/bin/env python
"""
Created on Wed Jun 21 16:10:42 2017

@author: jreith, J. Reith (2017), intern at mundialis GmbH & Co. KG, Bonn
"""
#=================================================================================================
#python script to extract the files within the bounding box
#raster files are stored in the vrt file
#
#links:
#http://www.gdal.org/gdal_tutorial.html
#http://www.gdal.org/classGDALDataset.html#aefe21eb2d1c87304a14f81ee2e6d9717
#=================================================================================================
#Preparation: import and call variables (identically to the original script)
import sys
from osgeo import gdal
from osgeo.gdalconst import *

#/path/to/file
dir = sys.argv[1]

#opens the vrt file and gets the list of files
dataset = gdal.Open(dir + "/gdal_bbox.vrt", GA_ReadOnly)
if dataset is not None:
    filelist = dataset.GetFileList()
else: 
    print ('gdal_bbox.vrt not found')
    sys.exit(1)
    
#writes it to a new file, skips first line, because its a vrt and not a raster
with open(dir + "/vrt_list.txt", 'w+') as f:
    for line in filelist[1:]:
        f.write(str(line) +"\n")
f.close()  
