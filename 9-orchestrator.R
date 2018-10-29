# orchestrátor: stahne data, nakreslí obrázky, nahraje soubor pro blog & that's it - do žádné složitější logiky se nepouští

# ať je v logu na co koukat... :)
print(paste("golemio nastartován", Sys.time()))

# cesta k packagím při spuštění z příkazové řádky (i.e. cron job)
.libPaths("/usr/lib/R/site-library")

setwd('/home/jindra/golemio-pm10/')

capture.output({

  source('1.1-get-data-stanice.R') # olízne API a uloží do adresáře /data
  source('4-draw-chart.R')    # z dat v /data spočte obrázek s mapou a uloží do /img
  source('5-draw-timeline.R') # z dat v /data spočte časovou osu a uloží do /img
  source('6-draw-heatmap.R')  # z dat v /data spočte heatmapu a uloží do /img

}, file = '/dev/null')


system('./sync.sh') # uloží obsah adresáře /img na internet - soubor je gitignorován coby nerelevantní 

print(paste("golemio doběhl", Sys.time()))
