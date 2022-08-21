# 3. faza: Vizualizacija podatkov

#Priprava Tabele 1 za vizualizacijo

dejanski_odhodi <- filter(odhodi, potniki != 0) # odstranitev držav, kamor ni letelo nobeno letalo
odhodi_na_mesec <- filter(dejanski_odhodi, drzava == "Države prihoda/odhoda letal - SKUPAJ")
odhodi_na_mesec$potniki <- as.numeric(odhodi_na_mesec$potniki)

# Vsota po mesecih, da nastane tabela po letih

na_leto <- aggregate(x = odhodi_na_mesec$potniki,
                     by = list(odhodi_na_mesec$leto),
                     FUN = sum)
na_leto <- na_leto[-c(19),] #ker so podatki samo za pol leta 2022
colnames(na_leto) <- c("leto", "potniki")

# GRAF 1: ODHODI POTNIKOV Z BRNIKA NA LETO OD 2004 DO 2021

options(scipen=5) #da ne bo znanstvenega zapisa na grafih
graf1 <- plot(na_leto$leto, na_leto$potniki, main = "Odhodi potnikov z Brnika na leto", xlab = "Leto", ylab = "Število potnikov", type="l", col="blue")






# #Prikaz spreminjanja cen
# spr_cen <- plot(cene$leto, cene$povpr_cena, main = "Spreminjanje cene povprečne povratne letalske vozovnice za lete znotraj ZDA", xlab="Leto", ylab="Povprečna cena [$]", type="l", col="blue")