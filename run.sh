#!/bin/bash

echo "Run ElmFire"

cd $ELMFIRE_BASE_DIR/tutorials/01-constant-wind
./01-run.sh

ls 
cp -r outputs $SCRATCH