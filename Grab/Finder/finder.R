rm(list=ls())
setwd("~/Documents/Sumut_Graber/Grab/Finder")

url = "https://food.grab.com/id/en/restaurants"

load("~/Documents/Sumut_Graber/Reporting/pre processing/gmaps.rda")

# mulai dari binjai
nama_tempat_all = 
  df_maps %>% 
  filter(kota == "Tebing Tinggi") %>% 
  .$nama_tempat %>% 
  unique()

# memanggil semua libraries yang terlibat
library(dplyr)
library(rvest)
library(RSelenium)

# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 
remote_driver$navigate(url)

# function scrape
cariin_donk = function(nama_tempat){
  # balik lagi
  remote_driver$navigate(url)
  # cari maps
  cari_maps = remote_driver$findElement(using = 'css', 
                                        value = '#page-content > div:nth-child(2) > div > div.sectionContent___2XGJB.sectionSearch___3ZuiE > span > input')
  cari_maps$sendKeysToElement(list(nama_tempat,
                                   key = "enter"))
  Sys.sleep(4)
  padanan = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes(".name___2epcT") %>% 
    html_text() %>% 
    .[1]
  # output
  return(padanan)
}

# template
hasil = rep(NA,length(nama_tempat_all))
for(i in 1:length(hasil)){
  hasil[i] = cariin_donk(nama_tempat_all[i])
  print(paste0("Scrape ",i," DONE dari ",length(hasil)))
}

data_tebing_tinggi = data.frame(maps = nama_tempat_all,
                         grab = hasil)
save(data_tebing_tinggi,file = "maps tebing di grab.rda")
