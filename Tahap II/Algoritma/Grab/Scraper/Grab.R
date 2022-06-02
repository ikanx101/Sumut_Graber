library(dplyr)
library(rvest)
library(RSelenium)

#setwd("~/Documents/Sumut_Graber/Grab/Scraper")
setwd("E:/DATA SCIENCE/Sumut Grab Gmaps/Tahap II/Algoritma/Grab/Scraper")

kota = "medan"

# dimulai dari hati yang bersih
rm(list=ls())

# function utk scrape grab
scrape_grab = function(url){
  remote_driver$navigate(url)
  Sys.sleep(12)
  rekap_hasil = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% {
      tibble(
        nama_resto = html_nodes(.,".name___1Ls94") %>% html_text(),
        kategori_resto = html_nodes(.,".cuisine___3sorn") %>% html_text(),
        rating_resto = html_nodes(.,".ratingText___1Q08c") %>% html_text() %>% ifelse(identical(.,character(0)),0,.),
        menu_resto = html_nodes(.,".itemName___UD_E_ h3") %>% html_text(),
        harga = html_nodes(.,".discountedPrice___3MBVA") %>% html_text()
      )
    }
  return(rekap_hasil)
}

# =========================================================================================

# halaman depan grab
url = "https://food.grab.com/id/en/restaurants"

# memulai selenium
driver = RSelenium::rsDriver(browser = "chrome",
                             chromever = "101.0.4951.41" )
remote_driver = driver[["client"]] 

# membuka situs grab
remote_driver$navigate(url)


# log nama
nama_file = Sys.time() %>% janitor::make_clean_names()
#nama_file = paste0("E:/DATA SCIENCE/Sumut Grab Gmaps/Tahap II/Algoritma/Grab/Scraper/",nama_file," - ",kota,".rda")
nama_file = paste0("~/Documents/Sumut_Graber/Tahap II/Algoritma/Grab/Scraper/",nama_file," - ",kota,".rda")

# mencari klik load more
button_element = remote_driver$findElement(using = 'css', value = ".ant-btn-block")
# mengklik load more sekian kali
for(i in 1:10){
  button_element$clickElement()
  print(paste0("sudah diklik load more ",i," x"))
  Sys.sleep(5)
}

# dapetin semua links restoran yang ada
urls = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>% 
  html_nodes("a") %>% 
  html_attr("href")

# siapin url
urls = urls[grepl("/restaurant/",urls)]
links = paste0("https://food.grab.com",urls)
links = links[!grepl("error",links)]


# buat rumahnya dalam list
hasil = vector("list", length(links))

# proses scraping semua links
for(i in 1:length(links)){
  hasil[[i]] = scrape_grab(links[i])
  pesan = paste0("Proses scrape situs ke-",i," dari total: ",length(links))
  print(pesan)
  }
# gabung semua data final
data_final = do.call(rbind,hasil)
data_final = 
  data_final %>% 
  mutate(rating_resto = as.numeric(rating_resto),
         harga = gsub("\\.","",harga),
         harga = as.numeric(harga))

# save ke dalam rda
save(data_final,
     file = nama_file)

# close connection
remote_driver$close()
