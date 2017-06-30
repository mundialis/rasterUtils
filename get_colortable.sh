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
# Script to get the colortable of a  raster file and save it as a text file
# change the colortable with gdaldem
# http://www.gdal.org/gdaldem.html#gdaldem_color_relief
# https://gis.stackexchange.com/questions/130199/changing-color-of-raster-images-based-on-their-data-values-gdal
# http://nullege.com/codes/show/src%40g%40d%40GDAL-1.10.0%40samples%40gdalinfo.py/364/gdal.Open.GetRasterBand.GetRasterColorInterpretation/python
#=================================================================================================

# set user variables
# in the command line please also specify /path/to/file/name and the old_rgb_code:new_rgb_code

#### nothing to change below
if [ $# -ne 2 ] ; then
   echo "Usage: $1 /path/to/raster/name"
   echo "Usage: $2 old_rgb_code:new_rgb_code [...]"
   exit 1
else
   file="$1"    # filename "/path/to/file/filename.tif"
   rgb_list="$2"  #[ old_rgb_code:new_rgb_code [...]] e.g. "001,002,003:011,022,033 255,255,255:000,000,000"
fi

cd "$(dirname "$0")"
#pwd
dir=`(dirname ${file})`    #path "dirname ${file}"

#python script to get the colortable and save it as a text file
python get_colortable.py ${file} ${dir}
#change the rgb code, so that it is 9 digits long
# 11: 1,10,100 ----> 11: 001,010,100
echo -n  >${dir}/9_rgb_color.txt
while IFS=':' read -r a b; do
   echo -n "${a}: "  >>${dir}/9_rgb_color.txt
         while IFS=',' read -ra number; do
               for j in "${number[@]}"; do
                   if [[ ${#j} -lt 3 ]] ; then
                         j="000${j}"
                         j="${j: -3}"
                         echo -n ${j},  >> ${dir}/9_rgb_color.txt
                      else
                        echo -n ${j},  >> ${dir}/9_rgb_color.txt
                    fi
               done
               echo -en "\n"  >> ${dir}/9_rgb_color.txt
          done <<< ${b}
done <  ${dir}/rgb_color.txt
sed -i 's/.$//' ${dir}/9_rgb_color.txt
#changes each rgb-color-code to the desired color in the txt-file
for i in  ${rgb_list}; do
   sed -i -e "s:${i}:g" ${dir}/9_rgb_color.txt
done
#change the color in the TIFF-file and save the new file as .vrt
#gdaldem color-relief -of VRT ${file} ${dir}/rgb_color.txt ${dir}/rgb_color.vrt

# alternatives:
gdaldem color-relief -of GTiff ${file} ${dir}/9_rgb_color.txt ${dir}/rgb_color.tif
#gdal_translate -of GTiff ${dir}/rgb_color.vrt ${dir}/rgb_colorvrt.tif
