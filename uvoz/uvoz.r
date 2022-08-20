# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")
source("lib/libraries.r", encoding="UTF-8") #kaj je to? mogoce rabim

# UVOZ CEN LETALSKIH KART Z BTS.GOV
 
cene <- read_xlsx("podatki/cene letalskih kart.xlsx", skip=4)
names(cene) <- c("leto", "povpr_cena_realna", "spr_prejsnje_leto", "spr_1995", "povpr_cena_nominalna", 6:7)
cene=cene[ -c(29:31), ] #odstranitev zadnjih treh vrstic

# #Prikaz spreminjanja cen
# spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")


# UVOZ POVRšIN DRžAV EVROPSKE UNIJE Z WIKIPEDIJE

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




