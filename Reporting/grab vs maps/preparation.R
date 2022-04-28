rm(list=ls())
library(dplyr)
library(ggplot2)
library(tidyr)

# ambil function hitung jarak
source("~/Documents/Sumut_Graber/Reporting/persamaan/hitung jarak.R")

# kita hapus yang paling akhir
bersihin_simi = function(news){
  news = gsub("pematang|tebing","",news)
  news = strsplit(news,split = " ") %>% unlist()
  news = news[-length(news)] %>% paste(collapse = " ")
  return(news)
}

# ambil data asli grab
load("~/Documents/Sumut_Graber/Reporting/pre processing/grab.rda")
df_grab  = 
  df_grab %>% 
  filter(!grepl("supermarket|mart|specialty",kategori_resto,ignore.case = T)) %>% 
  rowwise() %>% 
  mutate(nama_merchant_clean = bersihin(nama_resto)) %>% 
  ungroup()
nama_merchant = df_grab$nama_merchant_clean %>% unique()

# ambil data hasil pencarian grab di gmaps
load("~/Documents/Sumut_Graber/Google Maps/Finder/cari cafe sumut/hasil cocok grab gmaps sumut.rda")
simi_simi = 
  simi_simi %>% 
  rename(grab = ig) %>% 
  rowwise() %>% 
  mutate(grab = bersihin_simi(grab)) %>% 
  ungroup() %>% 
  filter(grepl(paste(nama_merchant,collapse = "|"),
               grab))

save(data_final,df_grab,simi_simi,file = "grab ke gmaps.rda")