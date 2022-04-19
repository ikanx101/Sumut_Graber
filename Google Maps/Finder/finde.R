# ==============================================================================
#
# GOOGLE MAPS FINDER
# by: ikanx101.com
# digunakan untuk mencari tempat di google maps
#
# ==============================================================================

# set working directory
setwd("~/Documents/Sumut_Graber/Google Maps/Finder")

# dimulai dari hati yang bersih
rm(list=ls())

# memanggil semua libraries yang terlibat
library(dplyr)
library(rvest)
library(RSelenium)

# function I
# proses utk scrape link tempat
ambil_link = function(){
  # kita ambil linknya dulu
  urls = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes("a") %>% 
    html_attr("href")
  
  # siapin url
  links = urls[grepl("maps/place",urls)]
  return(links[1])
}

# function II
# ini adalah function untuk scrape info dari google maps
scrape_google_maps = function(url){
  remote_driver$navigate(url)
  Sys.sleep(7)
  output = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% {
      tibble(
        nama_tempat = html_nodes(.,".fontHeadlineLarge span") %>% html_text() %>% .[1],
        ratings = html_nodes(.,".aMPvhf-fI6EEc-KVuj8d") %>% html_text(),
        reviews = html_nodes(.,".mmu3tf .Yr7JMd-pane-hSRGPd") %>% html_text(),
        alamat = html_nodes(.,".AG25L:nth-child(1) .fontBodyMedium") %>% html_text()
      )
    }
  review = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes(".Yr7JMd-pane-content-ZYyEqf") %>% 
    html_text() %>% 
    .[5] %>% 
    strsplit(split = "Ringkasan ulasan diberikan oleh") %>% 
    unlist() %>% 
    .[2] %>% 
    stringr::str_squish() %>% 
    strsplit(split = "TrustYou. 5 4 3 2 1") %>% 
    unlist() %>% 
    .[2] %>% 
    strsplit(split = "Orang lain juga menelusuri") %>% 
    unlist() %>% 
    .[1]
  output$review = review
  output$url = url
  return(output)
}

# function III
# proses untuk scrape semua informasi
# function paling ultimate
cari_tempat = function(nama_tempat){
  # set url
  url = "https://www.google.co.id/maps/"
  # membuka situs google maps
  remote_driver$navigate(url)
  # cari maps
  cari_maps = remote_driver$findElement(using = 'css', value = '#searchboxinput')
  cari_maps$sendKeysToElement(list(nama_tempat,key = "enter"))
  # ambil hasil pencarian teratas
  url_1 = ambil_link()
  # kalau ada hasilnya
  if(length(url) == 1){
    tes = scrape_google_maps(url_1)
  }
  # jika tidak ada hasilnya
  if(length(url) != 1){tes = NA}
  # return hasil function
  return(tes)
}

# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

