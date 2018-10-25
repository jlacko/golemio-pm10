# připojit se k pražskému API, stahnout data a uložit je jako csvčko do /data directory

library(httr)
library(tidyverse)

source('0-get-token.R') # výsledek = objekt response s access tokenem v sobě 

odkaz <- paste0('https://ckc-emea.cisco.com/t/prague-city.com/cdp/v1/opendata/1.0/prague/',
                '?domain=environmentreports', # chytré lavičky :)
                '&fromDate=', '2018-10-01',
                '&toDate=', '2018-10-24',
                '&count=1000', # 17 čidel × 24 hodin × 2 pozorování do hodiny = 816
                '&format=json')

golemio <- GET(odkaz, 
            add_headers(Authorization = paste("Bearer", content(response)$access_token)))

stop_for_status(golemio)

lavicky_header <- c('identifier', 'name', 'source_timestamp', 'latitude', 'longitude', 'temperature',  'humidity')

data <- content(golemio)$data %>%
  map_df(magrittr::extract, lavicky_header)

write.csv2(data, './data/lavicky.csv', row.names = F)

