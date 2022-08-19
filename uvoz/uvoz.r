# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark=",", grouping_mark=".")


# UVOZ CEN LETALSKIH KART Z BTS.GOV
 
cene <- read_xlsx("podatki/cene letalskih kart.xlsx", skip=4)
names(cene) <- c("leto", "povpr_cena_realna", "spr_prejsnje_leto", "spr_1995", "povpr_cena_nominalna", 6:7)
cene=cene[ -c(29:31), ] #odstranitev zadnjih treh vrstic


# UVOZ POVRšIN DRžAV EVROPSKE UNIJE Z WIKIPEDIJE

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


# 
# #Prikaz spreminjanja cen
# spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")

