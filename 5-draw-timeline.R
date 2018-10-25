# nakreslit časovou osu pevných částic podle stanic

library(tidyverse)
library(scales)

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>%
  transmute(nazev = name, time = source_timestamp, metrika = PM10) %>%
  mutate(time = as.POSIXct(time)) # čas je čas...

metrika <- 'Pevné částice'
leyenda <- 'PM\u2081\u2080'

ggplot(data = data, aes(x = time, y = metrika, color = nazev, group = nazev)) +
  geom_line() +
  scale_x_datetime() +
  ggtitle(paste(metrika, 'v Praze')) +
  ylab(leyenda) +
  theme(axis.title.x = element_blank()) +
  guides(color=guide_legend(title="Měřicí stanice")) +
  theme_bw()

ggsave("casova-osa.png", width = 8, height = 6, units = "in", dpi = 100) # čiliže 800 na 600