# dimulai dari hati yang bersih
rm(list=ls())

# load libraries
library(dplyr)
library(stringdist)

# fungsi untuk menghitung simmilarity
kesamaan = function(a,b){
  jarak = stringdist(a,b,method = "jaccard")
  return(jarak)
}

# fungsi untuk membersihkan string
bersihin = function(text){
  text %>% 
    unique() %>% 
    janitor::make_clean_names() %>% 
    gsub("\\_"," ",.)
}

# import data
load("~/Documents/Sumut_Graber/Reporting/pre processing/grab.rda")
load("~/Documents/Sumut_Graber/Reporting/pre processing/gmaps.rda")

# untuk binjai
df_grab_binjai = df_grab %>% filter(grepl("pematang",kota,ignore.case = T))
df_maps_binjai = df_maps %>% filter(grepl("pematang",kota,ignore.case = T))

df_similarity = 
  expand.grid(df_grab_binjai$nama_resto %>% bersihin() %>% gsub("pematang siantar","",.),
              df_maps_binjai$nama_tempat %>% bersihin() %>% gsub("pematang siantar","",.)
              ) %>% 
  rename(grab = Var1,
         maps = Var2) %>% 
  rowwise() %>% 
  mutate(simi = kesamaan(grab,maps)) %>% 
  ungroup()

df_similarity %>% 
  group_by(grab) %>% 
  filter(simi <= .1) %>% 
  ungroup() %>% View()
