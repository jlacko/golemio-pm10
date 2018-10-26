# nakreslit časovou osu pevných částic podle stanic

library(gganimate)
library(tidyverse)
library(scales)

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>%
  transmute(nazev = name, time = source_timestamp, metrika = PM10) %>%
  mutate(time = as.POSIXct(time)) # čas je čas...

metrika <- 'Polétavý prach'
leyenda <- 'PM₁₀ μ·m³'

osa <- ggplot(data = data, aes(x = time, y = metrika)) +
  geom_line(color = 'firebrick', lwd = 2) +
  scale_x_datetime() +
  ggtitle(paste(metrika, 'v Praze')) +
  ylab(leyenda) +
  ggtitle(paste(metrika, 'v Praze, měřicí stanice {closest_state}')) +
  theme_bw() +
  theme(axis.title.x = element_blank()) +
  transition_states(nazev,
                    transition_length = 2, 
                    state_length = 5) +
  ease_aes('sine-in-out')

animate(osa, nframes = 350, fps = 7, height = 600, width = 800)

anim_save('casova-osa.gif')