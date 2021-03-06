# připojit se k pražskému API, stahnout data a uložit je jako csvčko do /data directory

suppressPackageStartupMessages(library(httr))
suppressPackageStartupMessages(library(tidyverse))

source('0-get-token.R') # výsledek = objekt response s access tokenem v sobě 

odkaz <- paste0('https://ckc-emea.cisco.com/t/prague-city.com/cdp/v1/opendata/1.0/prague/',
                '?domain=airqualityreports', # meteo stanice
                '&fromDate=', Sys.Date() - 1, # od včerejška ...
                '&toDate=', Sys.Date(), # ... do dneška
                '&count=1000', # 17 čidel × 24 hodin × 2 pozorování do hodiny = 816
                '&format=json')

golemio <- GET(odkaz, 
            add_headers(Authorization = paste("Bearer", content(response)$access_token)))

stop_for_status(golemio)

stanice_header <- c('identifier', 'name', 'source_timestamp', 'latitude', 'longitude', 'aqi', 'CO', 'SO2', 'PM10')

data <- content(golemio)$data %>%
  map_df(magrittr::extract, stanice_header) 

data[data == 0] <- NA # nula neznamená nulu, ale chybu

write.csv2(data, './data/stanice.csv', row.names = F)

