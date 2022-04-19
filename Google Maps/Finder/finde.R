setwd("~/Documents/Sumut_Graber/Google Maps/Finder")

rm(list=ls())

library(dplyr)
library(rvest)
library(RSelenium)

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
    strsplit(split = "Orang lain juga menelusuri") %>% 
    unlist() %>% 
    .[1] %>% 
    stringr::str_squish()
  output$review = review
  output$url = url
  return(output)
}



# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# set url
url = "https://www.google.co.id/maps/"

# membuka situs google maps
remote_driver$navigate(url)

cari_produk = remote_driver$findElement(using = 'css', value = '#searchboxinput')
cari_produk$sendKeysToElement(list("mushalla nurul hikmah bekasi jaya",key = "enter"))



url_1 = ambil_link()
tes = scrape_google_maps(url_1)

