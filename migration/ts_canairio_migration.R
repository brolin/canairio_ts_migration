if (!require(influxr)) {
  install.packages(c("data.table", "xts", "curl", "httr", "devtools"))
  devtools::install_github("influxr/influxr")
}
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(googlesheets4)) install.packages("googlesheets4")

gs4_deauth()
measurements <- read_sheet("https://docs.google.com/spreadsheets/d/1RrMCvSORv1ymtFwJtYuLvWwFM1geEDKZ4kw1AAetHDY/edit#gid=0", "measurements")

measurements_migrate <- measurements %>%
  filter(`Reconstruir historico en nuevo esquema` == "x") %>%
  select(`name...2`) %>%
  {
    .[[1]]
  }

## Define a client to hold connection parameters to your server running the influxDB database instance. Here you can also provide username and password if authentication is needed.
db_client <- influxr_connection(host = "localhost", ssl = FALSE)

sensor_data <- map(measurements_migrate[1:2], function(m) {
  influxr_select(
    db_client,
    database = "canairio",
    measurement = m,
    fields = c("*"),
    ## from = '2021-01-01',
    ## to = '2021-02-01',
    ## tags = c(station = 'Hainich', level = 2),
    ## group_by = 'time(30m)',
    aggregation = NULL,
    ## fill = 'none',
    verbose = TRUE,
    limit = NULL
  )
}) %>% set_names(measurements_migrate[1:2])

glimpse(sensor_data)

map(sensor_data, function(m) {
  m %>%
    group_by(lat, lng) %>%
    summarise(`#regs` = n())
}) %>%
  enframe() %>%
  unnest() %>%
  write_csv("/tmp/measurements_canairio.csv")

unique(sensor_data$`CanAirIO_España_Meatzaldea`[, "lng"])


db_client_prod <- influxr_connection(host = "influxdb.canair.io", ssl = FALSE)
# Test the connection
ping(db_client_prod)

q <- influxr_query(
  client = db_client,
  query = qs["estaciones"],
  ignore_name = FALSE,
  ignore_tags = FALSE,
  database = "canairio",
  verbose = TRUE,
  return_type = "data.frame"
)

qs <- c(
  "tags" = "SHOW TAG VALUES",
  "estaciones" = 'SELECT * FROM "fixed_stations" GROUP BY "mac","dname"'
)
