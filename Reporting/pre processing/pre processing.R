# pendahuluan
# sekarang sudah ada tiga kota yang diambil:
  # binjai
  # pematang siantar
  # tebing tinggi

# ==============================================================================
# pendahuluan
# bebersih data
rm(list=ls())
# libraries
library(dplyr)
library(tidyr)
# set working directory
setwd("~/Documents/Sumut_Graber/Reporting/pre processing")

# ==============================================================================
# Gabung Data Google

# binjai
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Binjai/Google Maps"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # import data bakmi
  load(file_name)
  # bebersih data
  df_binjai = 
    do.call(rbind,data_gmaps) %>% 
    mutate(kota = "Binjai",
           link = url) %>% 
    separate(url,
             into = c("dummy","save"),
             sep = "!3d") %>% 
    select(-dummy) %>% 
    separate(save,
             into = c("lng","save"),
             sep = "!4d") %>% 
    separate(save,
             into = c("lat","dummy"),
             sep = "\\?") %>% 
    select(-dummy) %>% 
    mutate(ratings = gsub("\\,",".",ratings),
           ratings = as.numeric(ratings),
           reviews = gsub("[a-z]","",stringr::str_remove(reviews," ")),
           lat = as.numeric(lat),
           lng = as.numeric(lng)
           )

# pematang siantar 
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Pematang Siantar/Google Maps"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # import data bakmi
  load(file_name)
  # bebersih data
  df_pematang_siantar = 
    do.call(rbind,data_gmaps) %>% 
    mutate(kota = "Pematang Siantar",
           link = url) %>% 
    separate(url,
             into = c("dummy","save"),
             sep = "!3d") %>% 
    select(-dummy) %>% 
    separate(save,
             into = c("lng","save"),
             sep = "!4d") %>% 
    separate(save,
             into = c("lat","dummy"),
             sep = "\\?") %>% 
    select(-dummy) %>% 
    mutate(ratings = gsub("\\,",".",ratings),
           ratings = as.numeric(ratings),
           reviews = gsub("[a-z]","",stringr::str_remove(reviews," ")),
           lat = as.numeric(lat),
           lng = as.numeric(lng)
    )

# tebing tinggi 
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Tebing Tinggi/Google Maps"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # import data bakmi
  load(file_name)
  # bebersih data
  df_tebing_tinggi = 
    do.call(rbind,data_gmaps) %>% 
    mutate(kota = "Tebing Tinggi",
           link = url) %>% 
    separate(url,
             into = c("dummy","save"),
             sep = "!3d") %>% 
    select(-dummy) %>% 
    separate(save,
             into = c("lng","save"),
             sep = "!4d") %>% 
    separate(save,
             into = c("lat","dummy"),
             sep = "\\?") %>% 
    select(-dummy) %>% 
    mutate(ratings = gsub("\\,",".",ratings),
           ratings = as.numeric(ratings),
           reviews = gsub("[a-z]","",stringr::str_remove(reviews," ")),
           lat = as.numeric(lat),
           lng = as.numeric(lng)
    )
  
# gabung semua data tersebut
df_maps = rbind(df_binjai,df_pematang_siantar)   
# gabung semua data tersebut
df_maps = rbind(df_tebing_tinggi,df_maps) 

# kita save dulu ya
save(df_maps,file = "gmaps.rda")










# ==============================================================================
# Gabung Data Grab
rm(list=ls())

# binjai
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Binjai/Grab"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # kita load dulu
  temp = vector("list",length(file_name))
  for(i in 1:length(file_name)){
    load(file_name[i])
    temp[[i]] = data_final
  }
  df_binjai = do.call(rbind,temp) %>% distinct() %>% mutate(kota = "binjai")

# pematang siantar
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Pematang Siantar/Grab"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # kita load dulu
  temp = vector("list",length(file_name))
  for(i in 1:length(file_name)){
    load(file_name[i])
    temp[[i]] = data_final
  }
  df_pematang_siantar = do.call(rbind,temp) %>% distinct() %>% mutate(kota = "pematang siantar")

# tebing tinggi
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Tebing Tinggi/Grab"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # kita load dulu
  temp = vector("list",length(file_name))
  for(i in 1:length(file_name)){
    load(file_name[i])
    temp[[i]] = data_final
  }
  df_tebing_tinggi = do.call(rbind,temp) %>% distinct() %>% mutate(kota = "tebing tinggi")
  
# kita gabung dulu semua datanya
df_grab = rbind(df_binjai,df_pematang_siantar) %>% rbind(.,df_tebing_tinggi)
# kita save dulu ya
save(df_grab,file = "grab.rda")

# == DONE == 