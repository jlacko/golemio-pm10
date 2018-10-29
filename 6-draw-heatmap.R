# nakreslit heatmapu pozorování (statický obrázek)

library(tidyverse)
library(lubridate)
library(scales)

data <- read.csv2('./data/stanice.csv', stringsAsFactors = F) %>%
  transmute(nazev = name, time = source_timestamp, metrika = PM10) %>%
  mutate(time = as.POSIXct(time)) # čas je čas...

metrika <- 'Polétavý prach'
leyenda <- 'PM₁₀ μ·m³'

obrazek <- ggplot(data = data, aes(x = time, y = nazev, fill = metrika)) +
  geom_tile(height = 0.8) +
  scale_fill_gradient2(midpoint = 35,
                       low = 'green2',
                       mid = 'yellow',
                       high = 'red3',
                       na.value = 'gray95',
                       name = leyenda) +
  ggtitle(paste(metrika, 'v Praze dne', format(min(data$time), format = "%d.%m.%Y"))) +
  theme_bw() +
  theme(axis.title = element_blank()) +
  scale_x_datetime(labels = date_format("%Y-%m-%d %H:%M"))

ggsave('./img/heatmapa.png', width = 8, height = 6, units = "in", dpi = 100) # čiliže 800 × 800 px