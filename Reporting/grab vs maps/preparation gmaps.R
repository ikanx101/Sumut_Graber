rm(list = ls())

library(dplyr)
library(tidyr)

# set working directory
setwd("~/NUTRIFOOD Sumut Graber/Reporting/grab vs maps")

# ambil data awal yang masih murni
load("~/NUTRIFOOD Sumut Graber/Reporting/pre processing/gmaps.rda")

# ambil data hasil pencarian di grab
load("~/NUTRIFOOD Sumut Graber/Grab/Finder/maps binjai di grab.rda")
load("~/NUTRIFOOD Sumut Graber/Grab/Finder/maps pematang di grab.rda")
load("~/NUTRIFOOD Sumut Graber/Grab/Finder/maps tebing di grab.rda")

# kita tambah nama kota dan samakan ya
data_binjai$kota = "binjai"
data_pematang_siantar$kota = "pematang siantar"
data_tebing_tinggi$kota = "tebing tinggi"

data_maps_find = rbind(data_binjai,data_pematang_siantar)
data_maps_find = rbind(data_maps_find,data_tebing_tinggi)

# bikin function untuk menghitung kesamaan
# load libraries
library(stringdist)

# fungsi untuk menghitung simmilarity
kesamaan = function(n){
  a = 
    data_maps_find$maps %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
  b = 
    data_maps_find$grab %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
  jarak_1 = stringdist(a,b,method = "jaccard")
  jarak_2 = stringdist(a,b,method = "cosine")
  output = (jarak_1 + jarak_2)/2
  return(output)
}

# paralel
library(parallel)
numCores = detectCores()
result = 
  mclapply(10,
           kesamaan,
           mc.cores = numCores)

data_maps_find$similarity = result[[1]]

save(data_maps_find,df_maps,file = "gmaps_ready.rda")
