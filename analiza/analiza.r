# 4. faza: Napredna analiza podatkov

#Analiza potovanj v Grčijo - nadaljevanje

# Iz podatkov o odhodih potnikov v Grčijo od 2004 do 2019 bom ocenila, število in razporeditev odhodov po mesecih
# v Grčijo do konca leta 2023, če ne bi bilo epidemije koronavirusa.

source("vizualizacija/vizualizacija.r", encoding="UTF-8")

grcija_do_19 <- grcija_vse %>% slice(1:192)
x <- grcija_do_19$potniki

x <- ts(x, start = c(2004, 1), frequency = 12) #Iz podatkov naredimo časovno vrsto. To odpre veliko možnosti za analizo in napovedovanje.

# Prikaz časovne vrste

graf9 <- autoplot(x)+
  ggtitle("Odhodi v Grčijo skozi čas")+
  ylab("Število potnikov")+
  xlab("Mesec")+
  theme_ipsum(plot_title_size=12)
graf9

#Analiza trenda in sezonskosti
# Ni trenda, tako da direktno sezonskost.

#Prikaz sezonskosti 1

graf10 <- ggseasonplot(x)+
  ggtitle("Odhodi v Grčijo")+
  ylab("Število potnikov")+
  xlab("Mesec")+
  guides(fill=guide_legend(title="Leto"))+     #NE ZNAM SPREMENITI NASLOVA LEGENDE IZ YEAR V LETO https://stackoverflow.com/questions/14622421/how-to-change-legend-title-in-ggplot
  theme_ipsum(plot_title_size=12)
graf10

# Prikaz sezonskosti 2
# Modre črtice so povprečja po mesecih, črne so gibanje števila potnikov za posamezen mesec skozi vsa leta.
graf11 <- ggsubseriesplot(x) # Vidimo, da so povprečja po mesecih zelo različna.
graf11
  

#ISKANJE NAJBOLJŠEGA MODELA

#1. MODEL: SEASONAL NAIVE METHOD
# x_t = x_{t-s} + e_t <- pomen: vrednost v januarju je enaka vrednosti iz januarja predhodnega leta + neka naključna napaka (e_t).
# To metodo lahko uporabimo, ker imamo zelo očitno sezonskost.
fit <- snaive(x) #Iz summary odčitana vrednost standardnega odklona: Residual SD = 959.1274. Toliko je standardni odklon od tega, da smo rekli, da je vrednost v nekem mesecu enaka vrednosti v tem mesecu eno leto nazaj.
print(summary(fit))
checkresiduals(fit)
#Glede na acf graf to ni najbolj idealna metoda, ker kar nekaj črtic gleda ven iz modrega pasu (95% interval zaupanja).

#2. MODEL: FIT ETS METHOD
# R preizkusi vse exponential smoothing modele in vrne najboljšega.
fit_ets <- ets(x)     #sigma = Residual SD = 961.8926
print(summary(fit_ets))
checkresiduals(fit_ets)  # Glede na acf ne izgleda bolje, zdi se mi celo slabše. Tudi SD je večji.

# 3. MODEL: ARIMA MODEL
# Tudi tukaj R preizkusi vse ARIMA modele in izbere najboljšega.
fit_arima <- auto.arima(x, D=1, stepwise=FALSE, approximation = FALSE, trace= TRUE) #d=1 bi naredil isto kot df za trend, D=1 naredi to za sezonskost, torej prvo razliko, zato da se znebimo sezonskosti. To pa moramo zato, ker za ARIMA potrebujemo stacionarno časovno vrsto.
print(summary(fit_arima))   # Residual SD = 737.2191 <- Boljši od prejšnjih dveh.
checkresiduals(fit_arima)   # Tudi acf izgleda najboljši od vseh treh, še vedno pa jih je nekaj (samo 3) zunaj intervala zaupanja, tako da zagotovo obstaja boljši model, ki pa je najverjetneje zelo kompleksen.
# Izbran: Best model: ARIMA(1,0,2)(0,1,0)[12] 

# Torej: Od vseh treh, ki smo jih preizkusili, je najboljši model ARIMA.

# NAPOVED
#Napoved je narejena glede na podatke do konca 2019. Privzamemo, da ni bilo epidemije koronavirusa.

napoved <- forecast(fit_arima, h=48) #Napoved za 48 mesecev, torej do konca leta 2023.
print(summary(napoved)) #prikaže napovedi

graf12 <- autoplot(napoved, include=120)+    #Samo zadnjih 120 mesecev, torej 10 let, da se bolje vidi.
  ggtitle("Napoved odhodov v Grčijo do konca leta 2023 glede na podatke do konca leta 2019")+
  ylab("Število potnikov")+
  xlab("Mesec")+
  theme_ipsum(plot_title_size=12)
graf12

graf13 <- autoplot(napoved, include=60)+        #Samo zadnjih 60 mesecev, torej 5 let.
  ggtitle("Napoved odhodov v Grčijo do konca leta 2023 glede na podatke do konca leta 2019")+ 
  ylab("Število potnikov")+
  xlab("Mesec")+
  theme_ipsum(plot_title_size=12)
graf13















