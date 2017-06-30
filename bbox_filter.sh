#!/bin/bash

# Author: J. Reith (2017), intern at mundialis GmbH & Co. KG, Bonn

# License
# This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#=================================================================================================
#script to filter raster-files based on a bounding box.
#raster files need a valid projection and the same amount of bands
#both scripts need to be in the same location
#http://www.gdal.org/gdalbuildvrt.html
#=================================================================================================

#set user variables
#dir="/home/jreith/eichstaett/DOP"                    # /path/to/file
#ftype=""                                             #set raster file type e.g. tif/jp2
#bbox="4300000.00 5300000.00 4500000.00 5500000.00"   #xmin ymin xmax ymax

#### nothing to change below
if [ $# -ne 3 ] ; then
   echo "Usage: $1 /path/to/raster/"
   echo "Usage: $2 raster_file_type"
   echo "Usage: $3 xmin ymin xmax ymax"
   exit 1
else
   dir="$1"    # /path/to/file
   ftype="$2"  #set raster file type e.g. tif/jp2
   bbox="$3"   #xmin ymin xmax ymax
fi

cd "$(dirname "$0")"
#pwd

#check all raster files
find ${dir} -type f -name "*.${ftype}" > ${dir}/all_raster.txt

#builds a vrt with all the Raster-files in the  bounding box"
gdalbuildvrt -te ${bbox} ${dir}/gdal_bbox.vrt -input_file_list ${dir}/all_raster.txt

#python script to create a text-list of all the files in the vrt (bounding box)
# gives the "path/to/file" as variable
python bbox_filter.py ${dir}

if [ -s ${dir}/vrt_list.txt ] ; then
   echo "list of raster files within bounding box created"
   cat ${dir}/vrt_list.txt
else
   rm -f ${dir}/vrt_list.txt
   echo "No rasterfiles within the bounding box"
   exit 1
fi
###########################
#while read line
#   do
#	DO SOME MAGIC HERE
#   done < ${dir}/vrt_list.txt
