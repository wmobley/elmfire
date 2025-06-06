#!/bin/bash

pwd
env
ls -ld ${ELMFIRE_BASE_DIR}

echo "Present Variables"
echo "$1"
echo "$2"
find -L $(echo $PATH | tr ":" " ") -name 'elmfire' -type f -perm -001 -print 
cp -r ${ELMFIRE_BASE_DIR} ${_tapisExecSystemExecDir}
# ls -ld ${_tapisExecSystemExecDir}
cd ${_tapisExecSystemExecDir}/elmfire/tutorials/03-real-fuels/
# cd ${ELMFIRE_BASE_DIR}/tutorials/03-real-fuels/
./01-run.sh $1 $2 $3 $4 $5

ls
cp -r outputs ${_tapisExecSystemOutputDir}
cp -r inputs ${_tapisExecSystemOutputDir}
