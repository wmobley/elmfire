#!/bin/bash

pwd
env
ls -ld ${ELMFIRE_BASE_DIR}

echo "Present Variables"
echo "$1"
echo "$2"
compgen -A builtin elmfire
cp -r ${ELMFIRE_BASE_DIR} ${_tapisExecSystemExecDir}
# ls -ld ${_tapisExecSystemExecDir}
cd ${_tapisExecSystemExecDir}/elmfire/tutorials/03-real-fuels/
# cd ${ELMFIRE_BASE_DIR}/tutorials/03-real-fuels/
./01-run.sh $1 $2

ls
cp -r outputs ${_tapisExecSystemOutputDir}
cp -r inputs ${_tapisExecSystemOutputDir}
