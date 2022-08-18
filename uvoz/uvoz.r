# 2. faza: Uvoz podatkov

nastavitve <- function(){sl <- locale("sl", decimal_mark=",", grouping_mark=".")}


# UVOZ ODHODOV LETAL PO DRŽAVAH, mesečno


             
#UVOZ POVRšIN DRžAV EVROPSKE UNIJE Z WIKIPEDIJE

uvozi.povrsine <- function() {
  link <- "https://en.wikipedia.org/wiki/European_Union"
  stran <- session(link) %>% read_html()
  povrsine <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders']") %>%
    .[[1]] %>% html_table(dec=".")
  for (i in 1:ncol(povrsine)) {
    if (is.character(povrsine[[i]])) {
      Encoding(povrsine[[i]]) <- "UTF-8"
    }
  }
  colnames(povrsine) <- c("drzava", "prestolnica", "pridruzitev", "prebivalci", "povrsina",
                          "gostota", "MEP")
  sl <- locale("sl", decimal_mark=",", grouping_mark=".")
  for (col in c("povrsina", "prebivalci", "gostota")) {
    if (is.character(povrsine[[col]])) {
      povrsine[[col]] <- parse_number(povrsine[[col]], locale=sl)  #stolpec gledamo kot seznam [[]] in zamenjamo mankajoce z na, na ostalih pa uporabimo sl
    }
  }
  povrsine$prestolnica <- NULL   #vseh teh stoplcev ne potrebujem
  povrsine$pridruzitev <- NULL
  povrsine$prebivalci <- NULL
  povrsine$gostota <- NULL
  povrsine$MEP <- NULL
  return(povrsine)
}


#UVOZ CEN LETALSKIH KART Z BTS.GOV

uvozi.cene <- function() {
  cene <- read_csv2("podatki/cene.csv", col_names=c("leto", "povpr_cena", 1:25),
                    locale=locale(encoding="Windows-1250"), skip=5)
  cene$"1" <- NULL   #vseh teh stolpcev ne potrebujem
  cene$"2" <- NULL
  cene$"3" <- NULL
  cene$"4" <- NULL
  cene$"5" <- NULL
  cene$"6" <- NULL
  cene$"7" <- NULL
  cene$"8" <- NULL
  cene$"9" <- NULL
  cene$"10" <- NULL
  cene$"11" <- NULL
  cene$"12" <- NULL
  cene$"13" <- NULL
  cene$"14" <- NULL
  cene$"15" <- NULL
  cene$"16" <- NULL
  cene$"17" <- NULL
  cene$"18" <- NULL
  cene$"19" <- NULL
  cene$"20" <- NULL
  cene$"21" <- NULL
  cene$"22" <- NULL
  cene$"23" <- NULL
  cene$"24" <- NULL
  cene$"25" <- NULL
  cene=cene[ -c(28:30), ] #odstranitev zadnjih treh vrstic
  return(cene)
}

#Prikaz spreminjanja cen
spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")

