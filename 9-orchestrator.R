# orchestrátor: stahne data, nakreslí obrázky, nahraje soubor pro blog & that's it - do žádné složitější logiky se nepouští

source('1.1-get-data-stanice.R') # olízne API a uloží do adresáře /data
source('4-draw-chart.R') # z dat v /data spočte obrázek s mapou
source('5-draw-timeline.R') # z dat v /data spočte časovou osu

system('./sync.sh') # uloží obsah adresáře /img na internet - soubor je gitignorován coby nerelevantní 
