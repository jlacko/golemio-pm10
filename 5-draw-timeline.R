# nakreslit časovou osu pevných částic podle stanic

library(gganimate)
library(tidyverse)
library(lubridate)
library(scales)

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>%
  transmute(nazev = name, time = source_timestamp, metrika = PM10) %>%
  mutate(time = as.POSIXct(time)) # čas je čas...

metrika <- 'Polétavý prach'
leyenda <- 'PM₁₀ μ·m³'
anotace <- c('horní mez - 330/2012 Sb.', 'imisní limit - 201/2012 Sb.')

osa <- ggplot(data = data, aes(x = time, y = metrika)) +
  geom_line(color = 'firebrick', lwd = 2) +
  ggtitle(paste(metrika, 'v Praze')) +
  geom_hline(yintercept=35, linetype="dashed", color = "gray75", lwd = 0.7, alpha = 0.6) +
  geom_hline(yintercept=50, linetype="dashed", color = "red", lwd = 0.7, alpha = .6) +
  annotate('text', x =  max(data$time) - dhours(1.5), y = 38, label = anotace[1], color = 'gray40', vjust = 1) +
  annotate('text', x =  max(data$time) - dhours(1.5), y = 53, label = anotace[2], color = 'gray40', vjust = 1) +  
  ylab(leyenda) +
  ggtitle(paste(metrika, 'v Praze, měřicí stanice {closest_state}')) +
  theme_bw() +
  theme(axis.title.x = element_blank()) +
  scale_x_datetime(labels = date_format("%Y-%m-%d %H:%M")) +
  transition_states(nazev,
                    transition_length = 2, 
                    state_length = 5) +
  ease_aes('sine-in-out')

animate(osa, nframes = 350, fps = 6, height = 600, width = 800) # dlouhý, poctivý nápočet

#animate(osa, height = 600, width = 800) # kratší, šizený nápočet

anim_save('./img/casova-osa.gif')