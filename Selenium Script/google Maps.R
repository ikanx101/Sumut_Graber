library(dplyr)
library(rvest)
library(RSelenium)

rm(list=ls())

# halaman depan grab
url = "https://www.google.co.id/maps/search/gym/@-6.2210925,107.0185126,15z/data=!3m1!4b1"

# memulai selenium
driver <- RSelenium::rsDriver(browser = "chrome",
                              chromever = "99.0.4844.35" )
remote_driver <- driver[["client"]] 

# membuka situs grab
remote_driver$navigate(url)

# kita ambil linknya dulu
urls = 
  remote_driver$getPageSource()[[1]] %>% 
  read_html() %>% 
  html_nodes("a") %>% 
  html_attr("href")

# siapin url
links = urls[grepl("maps/place",urls)]
links


# ini adalah function untuk scrape info dari google maps
scrape_google_maps = function(url){
  remote_driver$navigate(url)
  Sys.sleep(3)
  nama_tempat = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes("#pane > div > div.Yr7JMd-pane-content.cYB2Ge-oHo7ed > div > div > div.x3AX1-LfntMc-header-title > div.x3AX1-LfntMc-header-title-ma6Yeb-haAclf > div.x3AX1-LfntMc-header-title-ij8cu > div:nth-child(1) > h1 > span:nth-child(1)") %>% 
    html_text()
  
  ratings = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes("#pane > div > div.Yr7JMd-pane-content.cYB2Ge-oHo7ed > div > div > div.x3AX1-LfntMc-header-title > div.x3AX1-LfntMc-header-title-ma6Yeb-haAclf > div.x3AX1-LfntMc-header-title-ij8cu > div.x3AX1-LfntMc-header-title-ij8cu-haAclf > div > div.gm2-body-2.h0ySl-wcwwM-RWgCYc > div.OAO0-ZEhYpd-vJ7A6b.OAO0-ZEhYpd-vJ7A6b-qnnXGd > span > span > span") %>% 
    html_text()
  
  reviews = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes("#pane > div > div.Yr7JMd-pane-content.cYB2Ge-oHo7ed > div > div > div.x3AX1-LfntMc-header-title > div.x3AX1-LfntMc-header-title-ma6Yeb-haAclf > div.x3AX1-LfntMc-header-title-ij8cu > div.x3AX1-LfntMc-header-title-ij8cu-haAclf > div > div.gm2-body-2.h0ySl-wcwwM-RWgCYc > span:nth-child(3) > span > span > span.OAO0-ZEhYpd-vJ7A6b.OAO0-ZEhYpd-vJ7A6b-qnnXGd > span:nth-child(1) > button") %>% 
    html_text()
  
  alamat = 
    remote_driver$getPageSource()[[1]] %>% 
    read_html() %>% 
    html_nodes("#pane > div > div.Yr7JMd-pane-content.cYB2Ge-oHo7ed > div > div > div:nth-child(7) > div:nth-child(1) > button > div.AeaXub > div.rogA2c > div.QSFF4-text.gm2-body-2") %>% 
    html_text()
  
  url_google = links[i]
  
  return(data.frame(nama_tempat,ratings,reviews,alamat,url_google))
}

