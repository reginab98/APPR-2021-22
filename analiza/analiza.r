# 4. faza: Napredna analiza podatkov

# Iz podatkov o odhodih potnikov v Grčijo od 2004 do 2019 bom ocenila, število in razporeditev odhodov po mesecih v Grčijo v letu 2020,
# če ne bi bilo epidemije koronavirusa.

source("vizualizacija/vizualizacija.r", encoding="UTF-8")

# GRAF 8: OCENA ODHODOV V GRČIJO V 2020, ČE NE BI BILO EPIDEMIJE KORONAVIRUSA

grcija_do_19 <- grcija_vse %>% slice(1:192)
grcija_meseci <- aggregate(x = grcija_do_19$potniki,
                     by = list(grcija_do_19$mesec),
                     FUN = "mean")
colnames(grcija_meseci) <- c("Mesec", "Število potnikov")
graf8 <- ggplot(data=grcija_meseci, aes(x=Mesec, y=`Število potnikov`))+
  geom_bar(stat="identity", fill = "blue")+
  theme_ipsum()+
  theme(panel.grid.major.x = element_blank())+
  ggtitle("Odhodi potnikov z Brnika v Grčijo v letu 2020, če ne bi bilo epidemije koronavirusa")
graf8








