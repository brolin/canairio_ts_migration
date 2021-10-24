#!/usr/bin/env bash

git submodule init
git submodule update
cd dev_infrastructure
patch -s < ../canairio_setup_restore_backup.patch
cd ..
