library(dplyr)
library(rvest)
library(RSelenium)

rm(list=ls())

# halaman google maps dari kota yang akan diambil
url = "https://www.google.co.id/maps/search/Restaurants/@2.9622735,99.0596673,16z/data=!3m1!4b1!4m8!2m7!3m6!1sRestaurants!2sPematangsiantar,+Pematang+Siantar+City,+North+Sumatra!3s0x3031845c5ac9d49d:0xec50414d3469acee!4m2!1d99.0626377!2d2.965147"

# memulai selenium
driver =  RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver = driver[["client"]] 

# membuka situs google maps
remote_driver$navigate(url)

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
  return(links)
}

# bikin rumah
links_total = vector("list")
# mencari klik load more
button_element <- remote_driver$findElement(using = 'css', value = "#ppdPk-Ej1Yeb-LgbsSe-tJiF1e > img")

# ini proses semi automatis
# saat halaman maps terbuka, kita scroll ke bawah manual
for(i in 10:15){
  links_total[[i]] = ambil_link()
  Sys.sleep(runif(1,3,5))
  button_element$clickElement()
  print(i)
}


  # karena sudah malam, jadi disave dulu
#save(links_total,file = "uji coba binjai.rda")
#load("uji coba binjai.rda")

# proses penggabungan semua links tempat 
all_links = do.call(c,links_total) %>% unique()

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
  output$url = url
  return(output)
}

# siapin rumah dulu
data_gmaps = vector("list",length(all_links))

for(i in 1:length(all_links)){
  data_gmaps[[i]] = scrape_google_maps(all_links[i])
  tunggu = runif(1,1,2)
  Sys.sleep(tunggu)
  print(i)
}

save(data_gmaps,file = "gmaps_binjai.rda")
