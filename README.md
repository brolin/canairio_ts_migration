# Canairio timeseries data enviroment

This repository seek reproduce a test enviroment to work with the data of the https://canair.io/ - Citizen network for monitoring air pollulants.

You need **docker-compose** working in your machine and at least 8Gb available to restore the database

After clone the repository ..

## Up services
Run command ``cd canairio_ts_migration``
and then ``chmod +x setup.sh``

Run ``./setup.sh`` this command download the influxdb + grafana docker-compose files and patch they to the versions actually used by the canair.io project.

Go to the folder ``cd dev_infrastructure`` and run the command ``docker-compose up``

## Grafana default admin user
In the browser go to **http://localhost:3000**

user: admin
password: admin

## Restore canairio backup

You need at least 8Gb available to restore the canairio sensors backup

```
sudo chown -R $USER:$USER backup
cd dev_infrastructure/backup
wget -c  http://influxdb.canair.io:8080/data/canairio-snap-fixed-stations-20210721.tar.bz2 ## 2,0G file
tar jxvf canairio-snap-fixed-stations-20210721.tar.bz2
rm canairio-snap-fixed-stations-20210721.tar.bz2 ## Free disc space
cd ..
docker exec -it influxdb influxd restore --portable -db canairio /backup/canairio-snap-localhost-20210721/
rm -rf /backup/canairio-snap-localhost-20210721/ ## Free disc space

```

## Influxdb as datasource for Grafana

Go to **Configuration -> Data sources -> Add data source -> Influxdb**

In the settigs: 

**HTTP - URL** write http://localhost:8086
**HTTP - Access** select Browser

**Influxdb details - Database** write canairio

Click button **Save & test**

## References
- https://github.com/anaireorg
- https://github.com/anaireorg/anaire-cloud/tree/main/populate_grafana
- https://grafana.com/docs/grafana/latest/http_api/
- https://grafana.com/docs/grafana/latest/datasources/influxdb/

