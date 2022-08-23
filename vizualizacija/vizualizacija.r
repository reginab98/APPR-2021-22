# 3. faza: Vizualizacija podatkov

source("uvoz/uvoz.r", encoding="UTF-8")

#Priprava Tabele 1 za vizualizacijo

odhodi <- filter(odhodi, potniki != "-") # odstranitev vrstic, kjer ni podatka
odhodi$potniki <- as.numeric(odhodi$potniki)
dejanski_odhodi <- filter(odhodi, potniki != 0) # odstranitev držav, kamor ni letelo nobeno letalo
dejanski_odhodi <- filter(dejanski_odhodi, potniki != "-") # odstranitev vrstic, kjer ni podatka
odhodi_na_mesec <- filter(dejanski_odhodi, drzava == "Države prihoda/odhoda letal - SKUPAJ")

# Vsota po mesecih, da nastane tabela po letih

na_leto <- aggregate(x = odhodi_na_mesec$potniki,
                     by = list(odhodi_na_mesec$leto),
                     FUN = sum)
na_leto <- na_leto[-c(19),] #ker so podatki samo za pol leta 2022
colnames(na_leto) <- c("Leto", "Število potnikov")
options(scipen=5) #da ne bo znanstvenega zapisa na grafih

# GRAF 1: ODHODI POTNIKOV Z BRNIKA NA LETO OD 2004 DO 2021

graf1 <- ggplot(data=na_leto, aes(x=Leto, y=`Število potnikov`))+
  geom_bar(stat="identity", fill = "blue")+
  theme_ipsum(plot_title_size=16)+
  theme(
    axis.text.x = element_text(angle = 90, hjust = 0.5),
    panel.grid.major.x = element_blank())+
  ggtitle("Odhodi potnikov z Brnika na leto")
graf1

# Vsota po državah skozi vsa leta

brez_skupaj <- filter(dejanski_odhodi, drzava != "Države prihoda/odhoda letal - SKUPAJ")
po_drzavah <- aggregate(x = brez_skupaj$potniki,
                       by = list(brez_skupaj$drzava),
                       FUN = sum)
colnames(po_drzavah) <- c("drzava", "potniki")

# Razvrstitev držav po številu potnikov

razvrscene_drzave <- po_drzavah[order(po_drzavah$potniki, decreasing = TRUE),] #ni pomagalo, ker ggplot2 vseeno narise po abecedi

# ZEMLJEVID 1: ODHODI POTNIKOV Z BRNIKA V DRŽAVE SKOZI VSA LETA

svet <- map_data("world")
po_drzavah_zem <- po_drzavah
colnames(po_drzavah_zem) = c("region", "potniki")
Sys.setlocale(locale = "Slovenian") #da dela slovar - č-ji so problem
slovar <- c("Albanija"="Albania",
            "Alžirija"="Algeria",
            "Armenija"="Armenia",
            "Avstrija"="Austria",
            "Azerbajdžan"="Azerbaijan",
            "Belgija"="Belgium",
            "Belorusija"="Belarus",
            "Bolgarija"="Bulgaria",
            "Bosna in Hercegovina"="Bosnia and Herzegovina",
            "Češka republika"="Czech Republic",
            "Ciper"="Cyprus",
            "Črna Gora"="Montenegro",
            "Danska"="Denmark",
            "Egipt"="Egypt",
            "Estonija"="Estonia",
            "Finska"="Finland",
            "Francija"="France",
            "Gibraltar"="Gibraltar",
            "Grčija"="Greece",
            "Gruzija"="Georgia",
            "Hrvaška"="Croatia",
            "Iran (Islamska republika)"="Iran",
            "Irska"="Ireland",
            "Islandija"="Iceland",
            "Italija"="Italy",
            "Izrael"="Israel",
            "Japonska"="Japan",
            "Jordanija"="Jordan",
            "Južna Afrika"="South Africa",
            "Kanada"="Canada",
            "Katar"="Qatar",
            "Kitajska (Ljudska republika)"="China",
            "Kosovo"="Kosovo",
            "Kuvajt"="Kuwait",
            "Latvija"="Latvia",
            "Libijska Arabska Džamahirija"="Libya",
            "Litva"="Lithuania",
            "Luksemburg"="Luxembourg",
            "Madžarska"="Hungary",
            "Malta"="Malta",
            "Maroko"="Morocco",
            "Moldavija (Republika)"="Moldova",
            "Nemčija"="Germany",
            "Nizozemska"="Netherlands",
            "Norveška"="Norway",
            "Oman"="Oman",
            "Poljska"="Poland",
            "Portugalska"="Portugal",
            "Romunija"="Romania",
            "Ruska federacija"="Russia",
            "Saudska Arabija"="Saudi Arabia",
            "Severna Makedonija"="North Macedonia",
            "Sirska Arabska Republika"="Syria",
            "Slovaška"="Slovakia",
            "Slovenija"="Slovenia",
            "Španija"="Spain",
            "Srbija"="Serbia",
            "Srbija in Črna Gora"="Serbia",
            "Švedska"="Sweden",
            "Švica"="Switzerland",
            "Tanzanija"="Tanzania",
            "Tunizija"="Tunisia",
            "Turčija"="Turkey",
            "Turkmenistan"="Turkmenistan",
            "Ukrajina"="Ukraine",
            "Uzbekistan"= "Uzbekistan",
            "Združene države" = "USA",
            "Združeni arabski emirati"="United Arab Emirates",
            "Združeno kraljestvo"= "UK")
po_drzavah_zem <- po_drzavah_zem %>% mutate(region = slovar[region])
svet <- left_join(svet, po_drzavah_zem, by="region")
#svet1<- svet %>% filter(!is.na(svet$potniki))
zemljevid1 <- ggplot(svet, aes(x = long, y = lat, group = group)) +
  scale_fill_gradient(name = "Število potnikov", low = "blue", high = "red", na.value = "grey90")+
  geom_polygon(aes(fill = potniki), color = "black")+
  theme(axis.text = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank())
zemljevid1

# GRAF 2: Število potnikov po državah destinacijah

drzave_stolpci <- razvrscene_drzave
colnames(drzave_stolpci) = c("Država", "Število potnikov")
rownames(drzave_stolpci)<-1:nrow(drzave_stolpci)
drzave_stolpci <- drzave_stolpci[-c(16:69),] #samo top 10

graf2 <- ggplot(data=drzave_stolpci, aes(x=reorder(Država,-`Število potnikov`), y=`Število potnikov`))+
  geom_bar(stat="identity", fill = "blue")+
  theme_ipsum(plot_title_size=16)+
  theme(axis.text.x = element_text(angle = 90, hjust = 0.3),
        axis.title.x = element_blank(),
        panel.grid.major.x = element_blank())+
  ggtitle("Deset najpogosteje obiskanih držav")
graf2

# Analiza letalskega potniškega prometa nad ozemlji EU

slovar_kratic <- c("AT"="Austria",
                   "BE"="Belgium",
                   "BG"="Bulgaria",
                   "CH"="Switzerland",
                   "CY"="Cyprus",
                   "CZ"="Czech Republic",
                   "DK"="Denmark",
                   "EE"="Estonia",
                   "EL"="Greece",
                   "FI"="Finland",
                   "FR"="France",
                   "HR"="Croatia",
                   "IE"="Ireland",
                   "IT"="Italy",
                   "LV"="Latvia",
                   "LT"="Lithuania",
                   "LU"="Luxembourg",
                   "HU"="Hungary",
                   "MT"="Malta",
                   "DE"="Germany",
                   "NL"="Netherlands",
                   "NO"="Norway",
                   "PL"="Poland",
                   "PT"="Portugal",
                   "RO"="Romania",
                   "SK"="Slovakia",
                   "SI"="Slovenia",
                   "ES"="Spain",
                   "SE"="Sweden")
nad_eu <- ozemlja %>% mutate(drzava=slovar_kratic[drzava])
povrsine_in_km_nad_ozemlji <- left_join(nad_eu, povrsine, by="drzava")
povrsine_in_km_nad_ozemlji<- povrsine_in_km_nad_ozemlji %>% filter(!is.na(povrsine_in_km_nad_ozemlji$povrsina_km2))
povrsine_in_km_nad_ozemlji$"2011" <- as.numeric(povrsine_in_km_nad_ozemlji$"2011")
povrsine_in_km_nad_ozemlji$"2012" <- as.numeric(povrsine_in_km_nad_ozemlji$"2012")
povrsine_in_km_nad_ozemlji$"2013" <- as.numeric(povrsine_in_km_nad_ozemlji$"2013")
povrsine_in_km_nad_ozemlji$"2014" <- as.numeric(povrsine_in_km_nad_ozemlji$"2014")
povrsine_in_km_nad_ozemlji$"2015" <- as.numeric(povrsine_in_km_nad_ozemlji$"2015")
povrsine_in_km_nad_ozemlji$"2016" <- as.numeric(povrsine_in_km_nad_ozemlji$"2016")
povrsine_in_km_nad_ozemlji$"2017" <- as.numeric(povrsine_in_km_nad_ozemlji$"2017")
povrsine_in_km_nad_ozemlji$"2018" <- as.numeric(povrsine_in_km_nad_ozemlji$"2018")
povrsine_in_km_nad_ozemlji$"2019" <- as.numeric(povrsine_in_km_nad_ozemlji$"2019")
povrsine_in_km_nad_ozemlji$"2020" <- as.numeric(povrsine_in_km_nad_ozemlji$"2020")
povrsine_in_km_nad_ozemlji$povrsina_km2 <- as.numeric(povrsine_in_km_nad_ozemlji$povrsina_km2)
neki <- povrsine_in_km_nad_ozemlji %>% select(-drzava, -povrsina_km2) %>% mutate(total=rowSums(.)) 
vsota <- neki$total 
povprecje <- vsota / povrsine_in_km_nad_ozemlji$povrsina_km2
povprecje <- as.data.frame(povprecje, encoding = "UTF-8")           #ne vem, kako bi spremenila decimalne pike v vejice v zadnjem stolpcu
povrsine_in_km_nad_ozemlji <- bind_cols(povrsine_in_km_nad_ozemlji, povprecje)
za_graf <- select(povrsine_in_km_nad_ozemlji, c(`drzava`, `povprecje`))
slovar_eu <- c("Austria"="Avstrija",
            "Belgium"="Belgija",
            "Bulgaria"="Bolgarija",
            "Czech Republic"="Češka republika",
            "Cyprus"="Ciper",
            "Denmark"= "Danska",
            "Estonia"="Estonija",
            "Finland"="Finska",
            "France"="Francija",
            "Greece"="Grčija",
            "Croatia"="Hrvaška",
            "Ireland"="Irska",
            "Italy"="Italija",
            "Latvia"="Latvija",
            "Lithuania"="Litva",
            "Luxembourg"="Luksemburg",
            "Hungary"="Madžarska",
            "Malta"="Malta",
            "Germany"= "Nemčija",
            "Netherlands"="Nizozemska",
            "Poland"="Poljska",
            "Portugal"="Portugalska",
            "Romania"="Romunija",
            "Slovakia"="Slovaška",
            "Slovenia"="Slovenija",
            "Spain"="Španija",
            "Sweden"="Švedska")
za_graf <- za_graf %>% mutate(drzava = slovar_eu[drzava])
colnames(za_graf)=c("drzava", "Milijon potniških kilometrov na km^2 ozemlja")

# GRAF 3: GOSTOTA LETALSKEGA POTNIŠKEGA PROMETA NAD DRŽAVAMI EVROPSKE UNIJE

graf3 <- ggplot(data=za_graf, aes(x=reorder(drzava,-`Milijon potniških kilometrov na km^2 ozemlja`), y=`Milijon potniških kilometrov na km^2 ozemlja`)) +
  geom_bar(stat="identity", fill = "blue")+
  theme_ipsum(plot_title_size=12)+
  theme(axis.text.x = element_text(angle = 90, hjust = 0.3),
        axis.title.x = element_blank(),
        panel.grid.major.x = element_blank())+
  ggtitle("Gostota letalskega potniškega prometa nad državami Evropske unije")
graf3
                                                            
# GRAF 4: CENE LETALSKIH KART

cene_graf4 <- cene
colnames(cene_graf4) = c("Leto", "Povprečna cena[$]")
graf4 <- ggplot(data= cene_graf4, aes(x=Leto, y=`Povprečna cena[$]`))+
  geom_line(aes(group=1), size=1, color="blue")+
  theme_ipsum(plot_title_size=16)+
  theme(axis.text.x = element_text(angle = 60, hjust = 0.7),
      panel.grid.major.x = element_blank())+
  ggtitle("Cene letalskih kart")
graf4
  
# GRAF 5: ŠTEVILO POTNIKOV IN CENE KART MED 2004 IN 2021

cene1 <- cene[-c(1:9),]
cene1 <- cene1[-c(19),]
podatki_cene_potniki <- bind_cols(data.frame(leto=2004:2021), `Število potnikov` = na_leto$`Število potnikov`, `Povprečna cena` = cene1$povpr_cena_realna)
names(podatki_cene_potniki)[1] <- "Leto"
koef <- max(podatki_cene_potniki$`Število potnikov`) / max(podatki_cene_potniki$`Povprečna cena`)
graf5 <- ggplot(podatki_cene_potniki, aes(x=Leto))+
  geom_line(aes(y = `Število potnikov`), size=1, color="blue")+
  geom_line(aes(y = `Povprečna cena` * koef), size=1, color="red")+
  scale_y_continuous(name = "Število potnikov", sec.axis=sec_axis(~./koef, name = "Povprečna cena"))+
  theme_ipsum(plot_title_size=16)+
  ggtitle("Primerjava števila potnikov in cen kart")
graf5

#Analiza potovanj v Grčijo
grcija_vse <- filter(odhodi, drzava == "Grčija")
grcija_vse$Mesec <- as.yearmon(paste(grcija_vse$leto, grcija_vse$mesec), "%Y %m")
grcija_10 <- grcija_vse %>% slice(61:192)
names(grcija_10)[4] <- "Število potnikov"

# GRAF 6: ŠTEVILO ODHODOV V GRČIJO NA MESEC MED 2009 IN 2019 - 11 LET
graf6 <- ggplot(data= grcija_10, aes(x=Mesec, y=`Število potnikov`))+
  geom_line(aes(group=1), size=1, color="blue")+
  theme_ipsum(plot_title_size=16)+
  theme(axis.text.x = element_text(angle = 60, hjust = 0.7),
        panel.grid.major.x = element_blank())+
  ggtitle("Število mesečnih odhodov v Grčijo 2009-2019")
graf6

# GRAF 7: ŠTEVILO ODHODOV V GRČIJO NA MESEC MED 2015 IN 2017 - 3 LETA
grcija_3 <- grcija_10 %>% slice(97:132)
graf7 <- ggplot(data= grcija_3, aes(x=Mesec, y=`Število potnikov`))+
  geom_line(aes(group=1), size=1, color="blue")+
  theme_ipsum(plot_title_size=16)+
  theme(axis.text.x = element_text(angle = 60, hjust = 0.7),
        panel.grid.major.x = element_blank())+
  ggtitle("Število mesečnih odhodov v Grčijo 2015-2017")
graf7

# Napoved odhodov v Grčijo za eno leto naprej -> NAPREDNA ANALIZA

