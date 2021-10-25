#!/usr/bin/env bash

git submodule init
git submodule update
cd dev_infrastructure
patch -s < ../canairio_setup_restore_backup.patch
cd ..

# cd dev_infrastructure/backup
# curl -O http://influxdb.canair.io:8080/data/canairio-snap-fixed-stations-20210721.tar.bz2
# tar jxvf canairio-snap-fixed-stations-20210721.tar.bz2
# rm canairio-snap-fixed-stations-20210721.tar.bz2 ## Free space
# docker exec -it influxdb influxd restore --portable -db canairio /backup/canairio-snap-localhost-20210721/
