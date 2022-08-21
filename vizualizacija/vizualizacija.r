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



# GRAF 2: ODHODI POTNIKOV Z BRNIKA V DRŽAVE SKOZI VSA LETA
#na tem grafu bo prikazanih 10 držav, kamor je letelo največ potnikov s stolpičnim diagramom
#tukaj bo tudi zemljevid sveta, drzave kamor leti več potnikov bojo temnejše ali kaj takega

#izbira parih držav, kjer bi predvidevala sezonskost, npr Grčija (poleti več letov), Egipt (kdaj je sezona), Rusija(kdaj je premraz), lahko pa tudi kakšno od top držav, če bo mogoče tam kakšna sezonskost


# #Prikaz spreminjanja cen
# spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")