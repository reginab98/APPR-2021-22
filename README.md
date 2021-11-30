# Analiza potovanj iz Slovenije
Regina Blagotinšek

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2021/22

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/reginab98/APPR-2021-22/master?urlpath=shiny/APPR-2021-22/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/reginab98/APPR-2021-22/master?urlpath=rstudio) RStudio

## Tematika in plan dela

V projektni nalogi bom analizirala potovanja iz Slovenije. Osredotočila se bom na potovanja z letali. Najprej me bo zanimalo, kam letijo potniška letala z ljubljanskega letališča. Ker je ljubljansko letališče manjše, to pogosto niso podatki o končni destinaciji. Vseeno bom pogledala, kako se skozi čas spreminja število potnikov na različne destinacije v zadnjih desetih letih. Podatke bom za nekaj let analizirala tudi na mesečni ravni in skušala najti kakšne podobnosti, kot na primer, v katerem mesecu so potovanja v določeno državo najpogostejša. Preučila bom tudi, ali imajo povprečne cene letalskih kart kakšen vpliv na število potnikov. Podatke o cenah kart so sicer za ZDA, vendar bom morda vseeno našla kakšno povezavo. Potovanja z letali iz Slovenije bom prikazala tudi na zemljevidu sveta. Na koncu bom nekoliko analizirala tudi letalski potniški promet v Evropski uniji in sicer tako, da bom preučila, koliko kilometrov naredijo potniška letala preko posameznih držav EU v razmerju s površinami njihovih ozemelj.

## Opis podatkovnih virov in zasnova podatkovnega modela

TABELA 1: Letališki potniški promet glede na odhod letal ter po državah, Ljubljana, Letališče Jožeta Pučnika, letno
* oblika CSV
* vrstice: leta
* stolpci: države
* vir: https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/2221901S.px

TABELA 2: Letališki potniški promet glede na odhod letal ter po državah, Ljubljana, Letališče Jožeta Pučnika, mesečno
* oblika CSV
* vrstice: meseci za nekaj let
* stolpci: države
* vir: https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/2221901S.px

TABELA 3: Povprečne cene letalskih kart
* oblika CSV
* vrstice: leta
* stolpci: povprečne cene, spremembe glede na prejšnje leto, spremembe glede na začetno leto (1995)
* vir: https://www.bts.gov/content/annual-us-domestic-average-itinerary-fare-current-and-constant-dollars

TABELA 4: Letalski potniški promet nad ozemljem in teritorialnim morjem držav - milijoni potniških km
* oblika: CSV
* stolpci: evropske države
* vrstice: leta
* vir: https://ec.europa.eu/eurostat/databrowser/view/avia_tppa/default/table?lang=en

TABELA 5: Površine evropskih držav
* oblika HTML
* vrstice: države
* stolpci: površine držav
* vir: https://en.wikipedia.org/wiki/European_Union

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).




