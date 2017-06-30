#!/usr/bin/env python
"""
Created on Wed Jun 21 16:10:42 2017

@author: jreith, J. Reith (2017), intern at mundialis GmbH & Co. KG, Bonn
"""
#=================================================================================================
#python script to extract the colortable and save it as a text file
#https://svn.osgeo.org/gdal/trunk/gdal/swig/python/samples/gdalinfo.py
#=================================================================================================
#import settings
import sys
from osgeo import gdal 

#reads in variables
#whole /path/to/filename
filename    = sys.argv[1]
#directory to save the file to
filedir     = sys.argv[2]
#RasterDriver
rastDriver  = gdal.GetDriverByName('gtiff')
rastDriver.Register()

#opens the TIFF
try:
	fn          = gdal.Open(filename)
except:
	print "File not found"
	sys.exit(1)

# method: FILE.GetRasterBand(1).GetRasterColorTable()
band        = fn.GetRasterBand(1)
colint      = band.GetRasterColorInterpretation()
ct          = band.GetRasterColorTable()

# https://svn.osgeo.org/gdal/trunk/gdal/swig/python/samples/gdalinfo.py
if band.GetRasterColorInterpretation() == gdal.GCI_PaletteIndex \
and ct is not None:
    print( "Color Table (%s with %d entries)" % (\
    gdal.GetPaletteInterpretationName( \
    ct.GetPaletteInterpretation(  )), \
    ct.GetCount() ))
    
#     save colors R,G,B value by value (from 0 to max found in map) to txt.-file
    f = open(filedir + "/rgb_color.txt", 'w+')    
    for i in range(ct.GetCount()):
        sEntry = ct.GetColorEntry(i)
        f.write( "  %3d: %d,%d,%d\n" % ( \
            i, \
            sEntry[0],\
            sEntry[1],\
            sEntry[2]))
elif ct == None:
    print 'file has no colortable; exit python script'
    exit(1)
                    
else:
    print 'Band has a color table with ', band.GetRasterColorTable().GetCount(), ' entries.'
  
f.close()      
