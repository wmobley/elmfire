#!/bin/bash

pwd
env
ls -ld ${ELMFIRE_BASE_DIR}

echo "Present Variables"
echo "1 $1, 2 $2, w.csv ${_tapisExecSystemInputDir}/wx.csv,  3 $3"
find -L $(echo $PATH | tr ":" " ") -name 'elmfire' -type f -perm -001 -print 
cp -r ${ELMFIRE_BASE_DIR} ${_tapisExecSystemExecDir}
# ls -ld ${_tapisExecSystemExecDir}
cd ${_tapisExecSystemExecDir}/elmfire/tutorials/03-real-fuels/
# cd ${ELMFIRE_BASE_DIR}/tutorials/03-real-fuels/
./01-run.sh $1 $2 "${_tapisExecSystemInputDir}/wx.csv" $3 

ls
cp outputs/flame_length*.tif ${_tapisExecSystemOutputDir}/flame_length.tif
cp outputs/time_of_arrival*.tif ${_tapisExecSystemOutputDir}/time_of_arrival.tif
cp outputs/flin*.tif ${_tapisExecSystemOutputDir}/fire_line_intensity.tif