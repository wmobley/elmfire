#!/bin/bash

set -xe
echo "Run ElmFire"

env
ls -l /
ls -l /elmfire
ls -l /elmfire/elmfire

cd $ELMFIRE_BASE_DIR/tutorials/01-constant-wind
./01-run.sh

ls 
cp -r outputs $SCRATCH
