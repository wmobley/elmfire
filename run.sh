#!/bin/bash

pwd
env
ls -ld ${ELMFIRE_BASE_DIR}

cp -r ${ELMFIRE_BASE_DIR} ${_tapisExecSystemExecDir}
ls -ld ${_tapisExecSystemExecDir}
cd ${_tapisExecSystemExecDir}/elmfire
./01-run.sh

ls
cp -r outputs ${_tapisExecSystemOutputDir}
