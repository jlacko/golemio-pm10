# vzít připravenou mapu, připojit data a nakreslit obrázek :)

library(sf)
library(tidyverse)
library(gganimate)
library(lubridate)

mapa <- readRDS('polygony.rds') # praha s voronoi polygony podle meteostanic

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>% # stažený soubor
  transmute(id = identifier, time = source_timestamp, metrika = PM10) %>% # jen zajímavé sloupce
  mutate(time = as.POSIXct(time)) %>% # čas je čas...
  mutate(time = floor_date(time, "minute")) # sekundy nepřidávají hodnotu

# data <- filter(data, time == min(data$time)) # jeden řez, pro debugging a pro pražáky dobrý...

podklad <- mapa %>% # podklad pro obrázek
  inner_join(data, by = c('id', 'id')) # klíč je id stanice

metrika <- 'Pevné částice'
leyenda <- 'PM\u2081\u2080'

load('pomocna_geometrie.RData') # obrysy Prahy + kus Vltavy

obrazek <- ggplot(podklad) + 
  geom_sf(aes(fill = metrika), lwd = 0) +
  scale_fill_gradientn(colours = rev(heat.colors(10)), name = leyenda) +
  geom_sf(data = vltava, color = 'steelblue', lwd = 1.5) +
  geom_sf(data = obrys, fill = NA, color = 'gray50', lwd = 1) +
  ggtitle(paste(metrika, 'v Praze {frame_time}')) +
  theme_bw() +
  transition_time(time) 

animate(obrazek, height = 600, width = 800)

anim_save('obrazek.gif')
