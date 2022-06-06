rm(list=ls())
setwd("E:/DATA SCIENCE/Sumut Grab Gmaps/Tahap II/Algoritma/Grab/Scraper")

library(dplyr)
library(tidyr)

# kota yang terlibat
kota = c("medan","binjai","pematang siantar","tebing tinggi")

# ambil semua rda dalam folder
rdas = list.files(pattern = "*.rda")

# mempersiapkan data frame rda
df = data.frame(rdas) %>% mutate(city = NA)
for(i in 1:nrow(df)){
  for(j in 1:length(kota)){
    df$city[i] = ifelse(grepl(kota[j],df$rdas[i],ignore.case = T),
                        kota[j],
                        df$city[i])
  }
}

# proses pengambilan data frame yang sudah discrape
temp = vector("list",nrow(df))
for(i in 1:nrow(df)){
  load(rdas[i])
  data_final$kota = df$city[i]
  temp[[i]] = data_final
}

# cek apakah semua hasil scrape berupa data frame atau bukan
for(i in 1:22){
  print(is.data.frame(temp[[i]]))
}
# hapus yang bukan data frame
temp[[9]] = NULL
temp[[21]] = NULL
temp[[17]] = NULL

# merging
data_akhir = 
  do.call(bind_rows,temp) %>% 
  distinct() %>% 
  filter(!is.na(nama_resto))

save(data_akhir,
     file = "clean_grab.rda")
