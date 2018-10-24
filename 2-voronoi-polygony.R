# připravit a uložit mapu voronoi polygonů vnitřku Prahy podle nejbližších laviček

library(sf)
library(RCzechia)
library(tidyverse)

data <- read_csv2('./data/lavicky.csv') %>%
  distinct(identifier, longitude, latitude) # unikátní hodnoty

lavicky <- st_as_sf(data, coords = c("longitude", "latitude"), 
                    crs = 4326, agr = "constant") %>% # z obyčejného data frejmu na sf
  st_transform(5514) # křovák kvůli metrům

# obálka pro oříznutí výsledku
praha <- kraje("high") %>% # malá, kulatější verze
  filter(KOD_CZNUTS3 == 'CZ010') %>% # ... to je to město!
  st_transform(5514) %>% # do Křováka, ať jsme v metrech
  select(geometry) # protože jenom tu potřebuju...

poly <- lavicky %>%  # vlastní práce
  st_geometry() %>% # zahodit datová pole / čistý sfg
  st_union() %>% # spojit dohromady
  st_voronoi() %>% # voronoi!
  st_collection_extract(type = "POLYGON") %>% # vybrat polygony
  st_sf(crs = 5514) %>% # jeden Křovák vládne všem
  st_intersection(praha) %>% # oříznout na město Prahu
  st_join(lavicky) %>% # připojit zpátky id lavicky
  st_set_agr("aggregate") %>% # ... aby nebyla zbytečná chybová hláška
  st_transform(4326) # WGS84 je dobrý default

plot(poly) # pro kontrolu...   

saveRDS(poly, 'polygony.rds')
