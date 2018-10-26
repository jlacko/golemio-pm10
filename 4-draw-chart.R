# vzít připravenou mapu, připojit data a nakreslit obrázek :)

library(sf)
library(tidyverse)
library(gganimate)
library(lubridate)

mapa <- readRDS('polygony.rds') # praha s voronoi polygony podle meteostanic

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>% # stažený soubor
  transmute(id = identifier, time = source_timestamp, metrika = PM10) %>% # jen zajímavé sloupce
  mutate(time = as.POSIXct(time)) %>% # čas je čas...
  mutate(time = round_date(time, "15 minutes")) # sekundy nepřidávají hodnotu

# data <- filter(data, time == min(data$time)) # jeden řez, pro debugging a pro pražáky dobrý...

podklad <- mapa %>% # podklad pro obrázek
  inner_join(data, by = c('id', 'id')) # klíč je id stanice

metrika <- 'Polétavý prach'
leyenda <- 'PM₁₀ μ·m³'

load('pomocna_geometrie.RData') # obrysy Prahy + kus Vltavy

obrazek <- ggplot(podklad) + 
  geom_sf(aes(fill = metrika), lwd = 0) +
  scale_fill_gradientn(colors = rev(heat.colors(25, alpha = 0.8)), name = leyenda) +
  geom_sf(data = vltava, color = 'slategray3', lwd = 1.25) +
  geom_sf(data = obrys, fill = NA, color = 'gray75', lwd = 1, alpha = 0.6) +
  ggtitle(paste(metrika, 'v Praze, stav k {closest_state}')) +
  theme_bw() +
  transition_states(time, 
                    transition_length = 2,
                    state_length = 1) 

animate(obrazek,nframes = 200, height = 600, width = 800)

anim_save('obrazek.gif')
