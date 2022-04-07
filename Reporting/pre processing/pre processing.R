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
  # bebersih kategori
  kategori = kategori %>% gsub(".rda","",.) %>% gsub("\\_"," ",.)
  # import data bakmi
  i = 1
  load(file_name[i])
  df_1_1 = 
    do.call(rbind,bakmi) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data cafe
  i = 2
  load(file_name[i])
  df_1_2 = 
    do.call(rbind,cafe) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data mie ayam
  i = 3
  load(file_name[i])
  df_1_3 = 
    do.call(rbind,mie_ayam) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data roti bakar
  i = 4
  load(file_name[i])
  df_1_4 = 
    do.call(rbind,roti_bakar) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # gabung data binjai
  df_binjai = rbind(df_1_1,df_1_2) %>% rbind(.,df_1_3) %>% rbind(.,df_1_4)
  
# pematang siantar 
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Pematang Siantar/Google Maps"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # bebersih kategori
  kategori = kategori %>% gsub(".rda","",.) %>% gsub("\\_"," ",.)
  # import data bakmi
  i = 1
  load(file_name[i])
  df_1_1 = 
    do.call(rbind,bakmi) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data cafe
  i = 2
  load(file_name[i])
  df_1_2 = 
    do.call(rbind,cafe) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data mie ayam
  i = 3
  load(file_name[i])
  df_1_3 = 
    do.call(rbind,mie_ayam) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data roti bakar
  i = 4
  load(file_name[i])
  df_1_4 = 
    do.call(rbind,roti_bakar) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # gabung data pematang siantar
  df_pematang_siantar = rbind(df_1_1,df_1_2) %>% rbind(.,df_1_3) %>% rbind(.,df_1_4)
  
# tebing tinggi 
  # path
  path = "~/Documents/Sumut_Graber/Grab/Data/Tebing Tinggi/Google Maps"
  # kategori
  kategori = list.files(path)
  # ambil semua file name
  file_name = paste0(path,"/",kategori)
  # bebersih kategori
  kategori = kategori %>% gsub(".rda","",.) %>% gsub("\\_"," ",.)
  # import data bakmi
  i = 1
  load(file_name[i])
  df_1_1 = 
    do.call(rbind,bakmi) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data cafe
  i = 2
  load(file_name[i])
  df_1_2 = 
    do.call(rbind,cafe) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data mie ayam
  i = 3
  load(file_name[i])
  df_1_3 = 
    do.call(rbind,mie_ayam) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # import data roti bakar
  i = 4
  load(file_name[i])
  df_1_4 = 
    do.call(rbind,roti_bakar) %>% 
    filter(!is.na(lat)) %>% 
    mutate(kategori = kategori[i]) %>% 
    distinct()
  # gabung data tebing tinggi
  df_tebing_tinggi = rbind(df_1_1,df_1_2) %>% rbind(.,df_1_3) %>% rbind(.,df_1_4)  
  
# gabung semua data tersebut
df_binjai = df_binjai %>% mutate(kota = "binjai")
df_pematang_siantar = df_pematang_siantar %>% mutate(kota = "pematang siantar")
df_tebing_tinggi = df_tebing_tinggi %>% mutate(kota = "tebing tinggi")
df_maps = rbind(df_binjai,df_pematang_siantar) %>% rbind(.,df_tebing_tinggi)
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