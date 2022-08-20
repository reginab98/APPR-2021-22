# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")
source("lib/libraries.r", encoding="UTF-8") #kaj je to?

# TABELA 1: Letališki potniški promet glede na odhod letal ter po državah, Ljubljana, Letališče Jožeta Pučnika, mesečno

odhodi <- read_csv2("podatki/odhodi letal mesecno.csv", na="-", locale=locale(encoding="Windows-1250"))
odhodi <- separate(odhodi, col=1, into= c("mesec", "prihod/odhod", "drzava prihoda/odhoda", "potniki"), sep=";" ) #ločitev na stolpce, ker je bil samo en ločen z ;
odhodi$`prihod/odhod` <- NULL   #nepotreben stolpec, ker so vsi podatki za odhode
odhodi <- odhodi[-c(1),] #izbris prve vrstice na ta način, ker skip=1 na zacetku pokvari vse

# TABELA 2: Povprečne cene letalskih kart
 
cene <- read_xlsx("podatki/cene letalskih kart.xlsx", skip=4)
names(cene) <- c("leto", "povpr_cena_realna", "spr_prejsnje_leto", "spr_1995", "povpr_cena_nominalna", 6:7)
cene=cene[ -c(29:31), ] #odstranitev zadnjih treh vrstic

# TABELA 3: Letalski potniški promet nad ozemljem in teritorialnim morjem držav - milijoni potniških km

ozemlja <- read_tsv("podatki/potniski km nad ozemlji.tsv", na="-", locale=locale(encoding="Windows-1250"))
ozemlja <- separate(ozemlja, col=1, into= c("A=letni podatki", "skupno", "enota", "drzava"), sep="," )
ozemlja$`A=letni podatki` <- NULL #nepotrebni stolpci
ozemlja$skupno <- NULL
ozemlja$enota <- NULL
ozemlja <- ozemlja[-c(12),] #izbris vsote po vseh državah, to lahko izračunam, če bom sploh kje želela ta podatek

# TABELA 4: Površine evropskih držav

link <- "https://en.wikipedia.org/wiki/European_Union"
stran <- session(link) %>% read_html()
povrsine <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders floatright']") %>%
  .[[1]] %>% html_table(dec=".")
colnames(povrsine) <- c("drzava", "prestolnica", "pridruzitev", "prebivalci", "povrsina",
                        "gostota", "MEP")
for (col in c("povrsina", "prebivalci", "gostota")) {
  if (is.character(povrsine[[col]])) {
    povrsine[[col]] <- parse_number(povrsine[[col]], locale=sl)  #stolpec gledamo kot seznam [[]] in zamenjamo mankajoce z na, na ostalih pa uporabimo sl
  }
}
for (i in 1:ncol(povrsine)) {         #kaj sem to naredila? od lani, ugotovi!
  if (is.character(povrsine[[i]])) {
    Encoding(povrsine[[i]]) <- "UTF-8"
  }
}
povrsine$prestolnica <- NULL   #vseh teh stoplcev ne potrebujem
povrsine$pridruzitev <- NULL
povrsine$prebivalci <- NULL
povrsine$gostota <- NULL
povrsine$MEP <- NULL
povrsine=povrsine[ -c(28), ] #odstranitev zadnje vrstice
