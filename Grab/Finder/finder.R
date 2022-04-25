rm(list=ls())

url = "https://food.grab.com/id/en/restaurants"

load("~/Documents/Sumut_Graber/Reporting/pre processing/gmaps.rda")

nama_tempat_all = 
  df_maps %>% 
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

nama_tempat = nama_tempat_all[1]

remote_driver$navigate(url)
# cari maps
cari_maps = remote_driver$findElement(using = 'css', value = '#page-content > div:nth-child(2) > div > div.sectionContent___2XGJB.sectionSearch___3ZuiE > span > input')
cari_maps$sendKeysToElement(list(nama_tempat,key = "enter"))


padanan = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>% 
  html_nodes(".name___2epcT") %>% 
  html_text() %>% 
  .[1]

padanan
