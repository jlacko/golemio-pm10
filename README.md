# Vizualizace dat o ovzduší z Golemio API

Cílem tohoto projektu je prokázat proveditelnost denního stahování dat o kvalitě vzduchu, konkrétně polétavém prachu (částicích PM₁₀) z otevřeného API města Prahy, jejich zpracování v prostředí jazyka R a prezentaci výsledků formou animované vizualizace.

### Animace znečištění v prostoru

<p align="center">
  <img src="http://www.jla-data.net/CZE/2018-10-26-prazska-data_files/obrazek.gif" alt="animovaná mapa"/>
</p>

### Animace výsledků jednotlivých měřicích stanic v čase

<p align="center">
  <img src="http://www.jla-data.net/CZE/2018-10-26-prazska-data_files/casova-osa.gif" alt="časová osa"/>
</p>

### Heatmapa výsledků měření po stanicích a v čase

<p align="center">
  <img src="http://www.jla-data.net/CZE/2018-10-26-prazska-data_files/heatmapa.png" alt="heatmapa"/>
</p>

<hr>

Kód je napsán v jazyce R, skládá se z několika logických částí, které jsou pro přehlednost v samostatných souborech:

- připojení ke [Golemio API](https://golemio.cz/cs/oblasti) (soubor s heslem je gitignorován, je třeba zadat vlastní :)
- stažení dat z API, přeložení jsonu na data.frame a následně csv
- nápočet voronoi polygonů kolem měřících stanic
- nápočet pomocných grafických objektů: hranic Prahy a kusu Vltavy pro hezčí mapu
- nápočet & uložení animace mapy
- nápočet & uložení animace časové osy měření po stanicich
- nápočet & uložení heatmapy 

Třetí a čtvrtý bod (vytvoření polygonů a pomocných objektů) stačí pustit jednou, zbytek je třeba udělat pokaždé. Snadno to zařídí soubor `9-orchestrator.R`. Za mě ho pravidelně spouští CRON job.
