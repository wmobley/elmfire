#!/bin/bash

pwd
env
ls -ld ${ELMFIRE_BASE_DIR}

cp $ELMFIRE_BASE_DIR ${_tapisExecSystemExecDir}
ls -ld ${_tapisExecSystemExecDir}
cd ${_tapisExecSystemExecDir}
./01-run.sh

ls
cp -r outputs ${_tapisExecSystemOutputDir}
