# připravit si obrys Prahy a relevantní kus řeky Vltavy

library(sf)
library(tidyverse)
library(RCzechia)

obrys <- kraje("high") %>% # kraj Praha ...
  filter(KOD_CZNUTS3 == 'CZ010') %>% # ... to je to město!
  st_transform(5514) # do Křováka, ať jsme v metrech

obalka <- obrys %>%
  st_buffer(1000) # kilometr kolem Prahy

vltava <- reky() %>% # kraj Praha ...
  filter(NAZEV == 'Vltava') %>%
  st_transform(5514) %>% # do Křováka, ať jsme v metrech
  st_intersection(obalka) %>% # jen pražský kus
  st_transform(4326) # zpátky do WGS84

obrys <- st_transform(obrys, 4326) # zpátky do WGS84

save(obrys, vltava, file = 'pomocna_geometrie.RData')