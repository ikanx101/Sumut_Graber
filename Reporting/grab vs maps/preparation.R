rm(list=ls())
library(dplyr)
library(ggplot2)
library(tidyr)

# fungsi untuk membersihkan string
bersihin = function(text){
  text %>% 
    unique() %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
}

# ambil data asli grab
load("~/Documents/Sumut_Graber/Reporting/pre processing/grab.rda")
df_grab  = 
  df_grab %>% 
  filter(!grepl("supermarket|mart|specialty",kategori_resto,ignore.case = T)) %>% 
  rowwise() %>% 
  mutate(nama_merchant_clean = bersihin(nama_resto)) %>% 
  ungroup()
