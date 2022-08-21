# 3. faza: Vizualizacija podatkov

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
colnames(na_leto) <- c("leto", "potniki")

# GRAF 1: ODHODI POTNIKOV Z BRNIKA NA LETO OD 2004 DO 2021

options(scipen=5) #da ne bo znanstvenega zapisa na grafih
graf1 <- plot(na_leto$leto, na_leto$potniki, main = "Odhodi potnikov z Brnika na leto", xlab = "Leto", ylab = "Število potnikov", type="l", col="blue")

# Vsota po državah skozi vsa leta

brez_skupaj <- filter(dejanski_odhodi, drzava != "Države prihoda/odhoda letal - SKUPAJ")
po_drzavah <- aggregate(x = brez_skupaj$potniki,
                       by = list(brez_skupaj$drzava),
                       FUN = sum)
colnames(po_drzavah) <- c("drzava", "potniki")

# Razvrstitev držav po številu potnikov

razvrscene_drzave <- po_drzavah[order(po_drzavah$potniki, decreasing = TRUE),]

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
po_drzavah_zem <- po_drzavah_zem %>% mutate(region=slovar[region])
svet <- left_join(svet, po_drzavah_zem, by="region")
svet1<- svet %>% filter(!is.na(svet$potniki))
zemljevid1 <- ggplot(svet, aes(x = long, y = lat, group = group)) +
  scale_fill_gradient(name = "Število potnikov", low = "blue", high = "red", na.value = "grey90")+
  geom_polygon(aes(fill = potniki), color = "black")+
  theme(axis.text.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        rect = element_blank())
zemljevid1

#izbira parih držav, kjer bi predvidevala sezonskost, npr Grčija (poleti več letov), Egipt (kdaj je sezona), Rusija(kdaj je premraz), lahko pa tudi kakšno od top držav, če bo mogoče tam kakšna sezonskost


# #Prikaz spreminjanja cen
# spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")