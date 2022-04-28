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
scrape_google_maps = function(link_baru){
  remote_driver$navigate(link_baru)
  Sys.sleep(7)
  # output
  output = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% {
      tibble(
        nama_tempat = html_nodes(.,".fontHeadlineLarge") %>% html_text() %>% .[1],
        alamat = html_nodes(.,".AG25L:nth-child(1) .fontBodyMedium") %>% html_text()
      )
    }
  # berapa banyak orang yang review
  reviews = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes(".mmu3tf .Yr7JMd-pane-hSRGPd") %>% 
    html_text()
  reviews = ifelse(length(reviews) == 0,NA,reviews)
  # berapa ratingnya
  rating = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes(".aMPvhf-fI6EEc-KVuj8d") %>% 
    html_text()
  rating = ifelse(length(rating) == 0,NA,rating)
  # mengambil data review google maps
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
  # gabungin data
  output$rating = rating
  output$reviews = reviews
  output$review = review
  output$url = link_baru
  return(output)
}

# function III
# proses untuk scrape semua informasi
# function paling ultimate
cari_tempat = function(nama_tempat){
  # membuka situs google maps
  remote_driver$navigate("https://www.google.co.id/maps/")
  Sys.sleep(4)
  # cari maps
  cari_maps = remote_driver$findElement(using = 'css', value = '#searchboxinput')
  cari_maps$sendKeysToElement(list(nama_tempat,key = "enter"))
  Sys.sleep(2)
  # ambil hasil pencarian teratas
  url_tempat = ambil_link()
  print(paste0("Ditemukan: ",
               length(url_tempat),
               "=====",
               url_tempat)
        )
  Sys.sleep(2)
  # kalau ada hasilnya
  if(!is.na(url_tempat)){
    tes = scrape_google_maps(url_tempat)
  }
  Sys.sleep(4)
  # jika tidak ada hasilnya
  if(is.na(url_tempat)){
    url_tempat = remote_driver$getCurrentUrl()[[1]]
    tes = scrape_google_maps(url_tempat)
    }
  # return hasil function
  return(tes)
}

# function untuk text pre-processing
# fungsi untuk menghitung simmilarity
library(stringdist)
kesamaan = function(a,b){
  jarak = 1 - stringdist(a,b,method = "cosine")
  return(jarak)
}

# fungsi untuk membersihkan string
bersihin = function(text){
  text %>% 
    unique() %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
}


# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "101.0.4951.41" )
remote_driver = driver[["client"]] 

